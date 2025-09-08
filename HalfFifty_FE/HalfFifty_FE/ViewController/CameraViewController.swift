//
//  CameraViewController.swift
//  HalfFifty_FE
//
//  Created by 김민지 on 1/25/25.
//

import UIKit
import AVFoundation
import MediaPipeTasksVision

class CameraViewController: UIViewController {
    var isFrontCamera: Bool = false
    var cameraFrame: CGRect = .zero
    private var captureSession: AVCaptureSession!
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    private var currentDevice: AVCaptureDevice!
    private var handLandmarker: HandLandmarker!
    private var videoInput: AVCaptureDeviceInput!
    private var videoOutput: AVCaptureVideoDataOutput!
    
    private let overlayView = UIImageView() // 랜드마크 및 연결선 표시용 레이어
    private let maxFrames = 30
    private var keypointsBuffer: [[[[Double]]]] = []
    private let minimumHandConfidence: Float = 0.8 // 손 인식 확신 기준
    
    private var requestQueue: [[[ [ [Double] ] ]]] = [] // 요청 대기열
    private var isRequesting: Bool = false // 요청 중 여부
    
    // Overlay 캘리브레이션
    private var overlayScaleX: CGFloat = 0.92   // 가로 폭 줄이기
    private var overlayScaleY: CGFloat = 2.0   // 세로 높이 늘리기

    // 미세 위치 보정 (픽셀 단위, 우/하 이동)
    private var overlayShiftX: CGFloat = 0.0
    private var overlayShiftY: CGFloat = 80.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
        setupHandLandmarker()
        setupOverlayView()
    }
    
    // 카메라 초기화
    private func setupCamera() {
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .high
        switchCamera(toFront: isFrontCamera)
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer)
        
        setupVideoOutput()
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
    }
    
    private func setupOverlayView() {
        overlayView.frame = view.bounds
        overlayView.contentMode = .scaleAspectFill
        view.addSubview(overlayView)
    }
    
    private func setupVideoOutput() {
        videoOutput = AVCaptureVideoDataOutput()
        
        videoOutput.videoSettings = [
            kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA
        ]
        
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        }
    }
    
    func switchCamera() {
        isFrontCamera.toggle()
        switchCamera(toFront: isFrontCamera)
    }
    
    private func switchCamera(toFront: Bool) {
        captureSession.beginConfiguration()
        
        if let currentInput = captureSession.inputs.first {
            captureSession.removeInput(currentInput)
        }
        
        let position: AVCaptureDevice.Position = toFront ? .front : .back
        if let newDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position) {
            do {
                let newInput = try AVCaptureDeviceInput(device: newDevice)
                if captureSession.canAddInput(newInput) {
                    captureSession.addInput(newInput)
                    currentDevice = newDevice
                    videoInput = newInput
                }
            } catch {
                print("카메라 전환 오류: \(error)")
            }
        }
        
        captureSession.commitConfiguration()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        videoPreviewLayer.frame = view.bounds
        
        // 오버레이 뷰 비율 유지하면서 크기 조정
        let cameraAspectRatio = videoPreviewLayer.bounds.width / videoPreviewLayer.bounds.height
        let overlayAspectRatio = overlayView.image?.size.width ?? 1.0 / (overlayView.image?.size.height ?? 1.0)
        
        var newOverlayFrame = videoPreviewLayer.bounds
        
        if cameraAspectRatio > overlayAspectRatio {
            // 카메라가 더 넓을 경우 → 높이를 기준으로 조정
            newOverlayFrame.size.width = newOverlayFrame.height * overlayAspectRatio
        } else {
            // 카메라가 더 좁을 경우 → 너비를 기준으로 조정
            newOverlayFrame.size.height = newOverlayFrame.width / overlayAspectRatio
        }
        
        overlayView.frame = newOverlayFrame
        overlayView.center = videoPreviewLayer.position
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        captureSession.stopRunning()
    }
    
    // Mediapipe HandLandmarker 초기화
    private func setupHandLandmarker() {
        guard let modelPath = Bundle.main.path(forResource: "hand_landmarker", ofType: "task") else {
            print("hand_landmarker.task 모델을 찾을 수 없습니다.")
            return
        }
        
        do {
            let options = HandLandmarkerOptions()
            options.baseOptions.modelAssetPath = modelPath
            options.runningMode = .liveStream
            options.numHands = 2
            options.minHandDetectionConfidence = 0.5
            options.minHandPresenceConfidence = 0.5
            options.minTrackingConfidence = 0.5
            options.handLandmarkerLiveStreamDelegate = self
            
            handLandmarker = try HandLandmarker(options: options)
        } catch {
            print("HandLandmarker 초기화 중 에러 발생: \(error.localizedDescription)")
        }
    }
    
    // 프레임 데이터 처리
    private func processFrame(_ pixelBuffer: CVPixelBuffer, timestamp: Int) {
        guard handLandmarker != nil else { return }
        
        let format = CVPixelBufferGetPixelFormatType(pixelBuffer)
        if format != kCVPixelFormatType_32BGRA {
            print("Unsupported pixel format detected: \(format). Converting to kCVPixelFormatType_32BGRA.")
            guard let convertedBuffer = convertPixelBufferToBGRA(pixelBuffer) else {
                print("픽셀 버퍼 변환 실패")
                return
            }
            processValidFrame(convertedBuffer, timestamp: timestamp)
            return
        }
        
        processValidFrame(pixelBuffer, timestamp: timestamp)
    }
    
    // `kCVPixelFormatType_32BGRA`로 변환하는 함수 추가
    private func convertPixelBufferToBGRA(_ pixelBuffer: CVPixelBuffer) -> CVPixelBuffer? {
        let width = CVPixelBufferGetWidth(pixelBuffer)
        let height = CVPixelBufferGetHeight(pixelBuffer)
        
        var bgraBuffer: CVPixelBuffer?
        let attributes: [String: Any] = [
            kCVPixelBufferCGImageCompatibilityKey as String: true,
            kCVPixelBufferCGBitmapContextCompatibilityKey as String: true,
            kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA
        ]
        
        let status = CVPixelBufferCreate(
            kCFAllocatorDefault, width, height,
            kCVPixelFormatType_32BGRA,
            attributes as CFDictionary,
            &bgraBuffer
        )
        
        guard status == kCVReturnSuccess, let outputBuffer = bgraBuffer else {
            return nil
        }
        
        // 변환된 픽셀 버퍼에 원본 데이터 복사
        CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
        CVPixelBufferLockBaseAddress(outputBuffer, [])
        
        if let src = CVPixelBufferGetBaseAddress(pixelBuffer),
           let dst = CVPixelBufferGetBaseAddress(outputBuffer) {
            memcpy(dst, src, CVPixelBufferGetDataSize(pixelBuffer))
        }
        
        CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly)
        CVPixelBufferUnlockBaseAddress(outputBuffer, [])
        
        return outputBuffer
    }
    
    // 변환된 프레임을 처리하는 함수
    private func processValidFrame(_ pixelBuffer: CVPixelBuffer, timestamp: Int) {
        do {
            let mpImage = try MPImage(pixelBuffer: pixelBuffer)
            try handLandmarker.detectAsync(image: mpImage, timestampInMilliseconds: timestamp)
        } catch {
            print("프레임 처리 중 에러 발생: \(error.localizedDescription)")
        }
    }
    
    // 랜드마크 및 연결선 그리기
    private func drawHandLandmarks(_ result: HandLandmarkerResult) {
        let cameraResolution = videoPreviewLayer.bounds.size
        let overlayResolution = overlayView.bounds.size
        if cameraResolution.width == 0 || cameraResolution.height == 0 { return }

        UIGraphicsBeginImageContext(overlayResolution)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.clear(CGRect(origin: .zero, size: overlayResolution))
        context.setStrokeColor(UIColor.green.cgColor)
        context.setLineWidth(2.0)

        // 캘리브레이션 중심(중앙 기준으로 스케일링해야 왜곡이 안 생김)
        let cx = overlayResolution.width  * 0.5
        let cy = overlayResolution.height * 0.5

        // 비율 보정 계산(기존 코드 유지)
        let scaleX = overlayResolution.width  / cameraResolution.width
        let scaleY = overlayResolution.height / cameraResolution.height
        let minScale = min(scaleX, scaleY)

        for hand in result.landmarks {
            var points: [CGPoint] = []

            for landmark in hand {
                var x = CGFloat(landmark.x) * cameraResolution.width  * minScale
                var y = (1 - CGFloat(landmark.y)) * cameraResolution.height * minScale

                if isFrontCamera {
                    // 전면: 90° 오른쪽 회전 (기존 로직 유지)
                    let tempX = x
                    x = overlayResolution.width - y
                    y = tempX
                } else {
                    // 후면: 90° 왼쪽 회전 + Y축 반전 (기존 로직 유지)
                    let tempX = x
                    x = y
                    y = overlayResolution.height - tempX
                    y = overlayResolution.height - y
                }

                // ✅ 여기서 "가로 축소 / 세로 확대" 캘리브레이션 적용
                x = (x - cx) * overlayScaleX + cx + overlayShiftX
                y = (y - cy) * overlayScaleY + cy + overlayShiftY

                points.append(CGPoint(x: x, y: y))

                // 점 찍기
                let circleRect = CGRect(x: x - 3, y: y - 3, width: 6, height: 6)
                context.setFillColor(UIColor.red.cgColor)
                context.fillEllipse(in: circleRect)
            }

            // 연결선
            for (startIndex, endIndex) in HandLandmarker.handConnections {
                if startIndex < points.count, endIndex < points.count {
                    let start = points[startIndex]
                    let end = points[endIndex]
                    context.move(to: start)
                    context.addLine(to: end)
                    context.strokePath()
                }
            }
        }

        overlayView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
}

// Mediapipe의 손 연결 정의
extension HandLandmarker {
    static let handConnections = [
        (0, 1), (1, 2), (2, 3), (3, 4), // 엄지
        (0, 5), (5, 6), (6, 7), (7, 8), // 검지
        (0, 9), (9, 10), (10, 11), (11, 12), // 중지
        (0, 13), (13, 14), (14, 15), (15, 16), // 약지
        (0, 17), (17, 18), (18, 19), (19, 20),  // 새끼
        (5, 9), (9, 13), (13, 17) // 손바닥
    ]
}

// HandLandmarkerLiveStreamDelegate 구현
extension CameraViewController: HandLandmarkerLiveStreamDelegate {
    func handLandmarker(
        _ handLandmarker: HandLandmarker,
        didFinishDetection result: HandLandmarkerResult?,
        timestampInMilliseconds: Int,
        error: Error?) {
        
        guard let result = result else { return }
        
        DispatchQueue.main.async {
            self.drawHandLandmarks(result)
            
            if result.landmarks.isEmpty {
                print("손 인식 안됨 -> 버퍼 초기화")
                self.keypointsBuffer.removeAll()
                return
            }
            
            if !self.isHandDetectionConfident(result: result) {
                print("손 인식 확신도 낮음 -> 버퍼 초기화")
                self.keypointsBuffer.removeAll()
                return
            }
            
            // 모든 인식 결과를 즉시 저장
            if let keypoints = self.extractKeypoints(from: result) {
                self.keypointsBuffer.append(keypoints)
            }
            
            if self.keypointsBuffer.count >= self.maxFrames {
                self.sendTranslationRequest(with: self.keypointsBuffer)
                self.keypointsBuffer.removeAll()
            }
        }
    }
    
    private func isHandDetectionConfident(result: HandLandmarkerResult) -> Bool {
        guard !result.handedness.isEmpty else {
            return false
        }
        
        for handScoreList in result.handedness {
            if let firstScore = handScoreList.first, firstScore.score < minimumHandConfidence {
                return false
            }
        }
        
        return true
    }
    
    private func extractKeypoints(from result: HandLandmarkerResult) -> [[[Double]]]? {
        guard !result.landmarks.isEmpty else { return nil }
        
        var frameKeypoints: [[[Double]]] = [
            Array(repeating: [0.0, 0.0, 0.0], count: 21), // 왼손
            Array(repeating: [0.0, 0.0, 0.0], count: 21)  // 오른손
        ]
        
        for (index, hand) in result.landmarks.enumerated() {
            guard index < 2 else { break }
            for (j, landmark) in hand.enumerated() {
                frameKeypoints[index][j] = [Double(landmark.x), Double(landmark.y), Double(landmark.z)]
            }
        }
        
        return frameKeypoints
    }
    
    private func sendTranslationRequest(with keypoints: [[[[Double]]]]) {
        requestQueue.append(keypoints)
        processNextRequestIfNeeded()
    }

    private func processNextRequestIfNeeded() {
        guard !isRequesting, !requestQueue.isEmpty else { return }

        isRequesting = true
        let currentKeypoints = requestQueue.removeFirst()

        guard let url = URL(string: "http://3.34.3.103/translation") else {
            print("URL이 잘못되었습니다.")
            isRequesting = false
            return
        }

        let requestBody: [String: Any] = ["keypoints": currentKeypoints]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData

            URLSession.shared.dataTask(with: request) { data, response, error in
                defer {
                    DispatchQueue.main.async {
                        self.isRequesting = false
                        self.processNextRequestIfNeeded() // 다음 요청 진행
                    }
                }

                if let error = error {
                    print("네트워크 요청 실패: \(error.localizedDescription)")
                    return
                }

                guard let data = data else {
                    print("응답 데이터가 없습니다.")
                    return
                }

                do {
                    let decodedResponse = try JSONDecoder().decode(TranslationResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.showTranslationResult(response: decodedResponse)
                    }
                } catch {
                    print("JSON 디코딩 오류: \(error.localizedDescription)")
                }
            }.resume()
        } catch {
            print("JSON 변환 오류: \(error.localizedDescription)")
            isRequesting = false
        }
    }
    
    // 번역 결과를 UI에 표시하는 함수 추가
    private func showTranslationResult(response: TranslationResponse) {
        guard let translatedWord = response.translatedWord else {
            print("번역 실패: 알 수 없는 오류")
            return
        }
        
        // 결과를 NotificationCenter로 전달
        NotificationCenter.default.post(
            name: Notification.Name("TranslationResult"),
            object: nil,
            userInfo: ["translatedWord": translatedWord]
        )
    }
}

// API 응답 구조체
struct TranslationResponse: Codable {
    let success: Bool
    let translatedWord: String?
}

// AVCaptureVideoDataOutputSampleBufferDelegate 구현
extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let timestamp = Int(CMSampleBufferGetPresentationTimeStamp(sampleBuffer).seconds * 1000)
        processFrame(pixelBuffer, timestamp: timestamp)
    }
}
