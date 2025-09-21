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
    var userVM: UserViewModel?
    
    var isFrontCamera: Bool = false
    var cameraFrame: CGRect = .zero
    private var captureSession: AVCaptureSession!
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    private var currentDevice: AVCaptureDevice!
    private var handLandmarker: HandLandmarker!
    private var videoInput: AVCaptureDeviceInput!
    private var videoOutput: AVCaptureVideoDataOutput!
    
    private let overlayView = UIImageView()
    private let maxFrames = 30
    private var keypointsBuffer: [[[[Double]]]] = []
    private let minimumHandConfidence: Float = 0.5
    private var lastAppendTimeMS: Int? = nil
    private let maxGapMS: Int = 1200
    
    private var requestQueue: [[[[[Double]]]]] = []
    private var isRequesting: Bool = false
    
    // Overlay calibration
    private var overlayScaleX: CGFloat = 0.92
    private var overlayScaleY: CGFloat = 2.0
    private var overlayShiftX: CGFloat = 0.0
    private var overlayShiftY: CGFloat = 80.0
    
    private var progressStep = 0
    private let totalSteps = 5
    
    private var userId: String {
        userVM?.userId ?? "5cbd5b33-833f-430a-97f3-96706b12ce71"
    }
    
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
        overlayView.isUserInteractionEnabled = false
        overlayView.backgroundColor = .clear
        view.addSubview(overlayView)
        view.bringSubviewToFront(overlayView)
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
                // handle error if needed
            }
        }
        captureSession.commitConfiguration()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        videoPreviewLayer.frame = view.bounds

        let overlayImageSize = overlayView.image?.size ?? CGSize(width: 1, height: 1)
        let cameraAspectRatio = videoPreviewLayer.bounds.width / videoPreviewLayer.bounds.height
        let overlayAspectRatio = overlayImageSize.width / overlayImageSize.height

        var newOverlayFrame = videoPreviewLayer.bounds
        if cameraAspectRatio > overlayAspectRatio {
            newOverlayFrame.size.width = newOverlayFrame.height * overlayAspectRatio
        } else {
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
            // handle error if needed
        }
    }
    
    // 프레임 데이터 처리
    private func processFrame(_ pixelBuffer: CVPixelBuffer, timestamp: Int) {
        guard handLandmarker != nil else { return }
        
        let format = CVPixelBufferGetPixelFormatType(pixelBuffer)
        if format != kCVPixelFormatType_32BGRA {
            guard let convertedBuffer = convertPixelBufferToBGRA(pixelBuffer) else { return }
            processValidFrame(convertedBuffer, timestamp: timestamp)
            return
        }
        processValidFrame(pixelBuffer, timestamp: timestamp)
    }
    
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
    
    private func processValidFrame(_ pixelBuffer: CVPixelBuffer, timestamp: Int) {
        do {
            let mpImage = try MPImage(pixelBuffer: pixelBuffer)
            try handLandmarker.detectAsync(image: mpImage, timestampInMilliseconds: timestamp)
        } catch {
            // handle error if needed
        }
    }
    
    // 랜드마크 및 연결선 그리기
    private func drawHandLandmarks(_ result: HandLandmarkerResult) {
        let cameraResolution = videoPreviewLayer.bounds.size
        let overlayResolution = overlayView.bounds.size

        guard overlayResolution.width.isFinite, overlayResolution.height.isFinite,
              overlayResolution.width > 0, overlayResolution.height > 0 else { return }
        guard cameraResolution.width > 0, cameraResolution.height > 0 else { return }

        UIGraphicsBeginImageContextWithOptions(overlayResolution, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.clear(CGRect(origin: .zero, size: overlayResolution))
        context.setStrokeColor(UIColor.green.cgColor)
        context.setLineWidth(2.0)

        let cx = overlayResolution.width  * 0.5
        let cy = overlayResolution.height * 0.5

        let scaleX = overlayResolution.width  / cameraResolution.width
        let scaleY = overlayResolution.height / cameraResolution.height
        let minScale = min(scaleX, scaleY)

        for hand in result.landmarks {
            var points: [CGPoint] = []
            for landmark in hand {
                var x = CGFloat(landmark.x) * cameraResolution.width  * minScale
                var y = (1 - CGFloat(landmark.y)) * cameraResolution.height * minScale

                if isFrontCamera {
                    let tempX = x
                    x = overlayResolution.width - y
                    y = tempX
                } else {
                    let tempX = x
                    x = y
                    y = overlayResolution.height - tempX
                    y = overlayResolution.height - y
                }

                x = (x - cx) * overlayScaleX + cx + overlayShiftX
                y = (y - cy) * overlayScaleY + cy + overlayShiftY

                points.append(CGPoint(x: x, y: y))

                let circleRect = CGRect(x: x - 3, y: y - 3, width: 6, height: 6)
                context.setFillColor(UIColor.red.cgColor)
                context.fillEllipse(in: circleRect)
            }

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
        (0, 1), (1, 2), (2, 3), (3, 4),
        (0, 5), (5, 6), (6, 7), (7, 8),
        (0, 9), (9, 10), (10, 11), (11, 12),
        (0, 13), (13, 14), (14, 15), (15, 16),
        (0, 17), (17, 18), (18, 19), (19, 20),
        (5, 9), (9, 13), (13, 17)
    ]
}

// HandLandmarkerLiveStreamDelegate 구현
extension CameraViewController: HandLandmarkerLiveStreamDelegate {
    func handLandmarker(
      _ handLandmarker: HandLandmarker,
      didFinishDetection result: HandLandmarkerResult?,
      timestampInMilliseconds: Int,
      error: Error?
    ) {
        guard let result = result else { return }
        let now = timestampInMilliseconds

        DispatchQueue.main.async { self.drawHandLandmarks(result) }

        if result.landmarks.isEmpty || !self.isHandDetectionConfident(result: result) {
            if let last = self.lastAppendTimeMS, now - last > self.maxGapMS {
                self.keypointsBuffer.removeAll()
                self.progressStep = 0
            }
            return
        }

        if let keypoints = self.extractKeypoints(from: result) {
            self.keypointsBuffer.append(keypoints)
            self.lastAppendTimeMS = now
        }

        if self.keypointsBuffer.count >= self.maxFrames {
            self.sendTranslationRequest(with: self.keypointsBuffer)
            self.keypointsBuffer.removeAll()
        }
    }
    
    private func isHandDetectionConfident(result: HandLandmarkerResult) -> Bool {
        guard !result.handedness.isEmpty else { return false }
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
            Array(repeating: [0.0, 0.0, 0.0], count: 21),
            Array(repeating: [0.0, 0.0, 0.0], count: 21)
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
            isRequesting = false
            return
        }

        let requestBody: [String: Any] = [
            "userId": userId,
            "keypoints": currentKeypoints
        ]

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
                        self.processNextRequestIfNeeded()
                    }
                }
                guard error == nil, let data = data else { return }
                do {
                    let decodedResponse = try JSONDecoder().decode(TranslationResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.showTranslationResult(response: decodedResponse)
                    }
                } catch {
                    // handle decode error if needed
                }
            }.resume()
        } catch {
            isRequesting = false
        }
    }
    
    private func showTranslationResult(response: TranslationResponse) {
        let status = (response.status ?? "").lowercased()

        switch status {
        case "processing":
            let step = parseStep(response.message)
            if let cur = step?.current, let tot = step?.total {
                progressStep = cur
            } else {
                progressStep = min(progressStep + 1, totalSteps)
            }
            NotificationCenter.default.post(
                name: .TranslationProgress,
                object: nil,
                userInfo: [
                    "message": response.message ?? "수화 인식 중...",
                    "current": progressStep,
                    "total": step?.total ?? totalSteps
                ]
            )

        case "failed":
            progressStep = 0
            NotificationCenter.default.post(
                name: .TranslationFailed,
                object: nil,
                userInfo: ["message": response.message ?? "수화 인식 실패"]
            )

        case "success":
            progressStep = 0
            NotificationCenter.default.post(
                name: .TranslationSuccess,
                object: nil,
                userInfo: [
                    "translatedWord": response.translatedWord ?? "",
                    "probability": response.probability ?? 0
                ]
            )

        default:
            if response.success, let word = response.translatedWord {
                progressStep = 0
                NotificationCenter.default.post(
                    name: .TranslationSuccess,
                    object: nil,
                    userInfo: ["translatedWord": word, "probability": response.probability ?? 0]
                )
            } else {
                progressStep = 0
                NotificationCenter.default.post(
                    name: .TranslationFailed,
                    object: nil,
                    userInfo: ["message": response.message ?? "인식 실패"]
                )
            }
        }
    }
    
    private func parseStep(_ message: String?) -> (current: Int, total: Int)? {
        guard let msg = message else { return nil }
        let pattern = #"\(\s*(\d+)\s*\/\s*(\d+)\s*\)"#
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return nil }
        guard let m = regex.firstMatch(in: msg, range: NSRange(msg.startIndex..., in: msg)) else { return nil }
        guard let r1 = Range(m.range(at: 1), in: msg),
              let r2 = Range(m.range(at: 2), in: msg) else { return nil }
        return (Int(msg[r1]) ?? 0, Int(msg[r2]) ?? 0)
    }
    
    private func summarizePayload(_ keypoints: [[[[Double]]]]) -> String {
        let frames = keypoints.count
        let hands  = keypoints.first?.count ?? 0
        let points = keypoints.first?.first?.count ?? 0
        let dims   = keypoints.first?.first?.first?.count ?? 0

        var samples: [String] = []
        if frames > 0, hands > 0, points > 0, dims > 0 {
            let f0 = 0, h0 = 0
            let pCount = min(points, 3)
            for p in 0..<pCount {
                let arr = keypoints[f0][h0][p]
                samples.append("p\(p)=\(arr)")
            }
        }
        return "frames=\(frames), hands/frame=\(hands), points/hand=\(points), dims/point=\(dims), sample(f0,h0): \(samples.joined(separator: ", "))"
    }

    private func prettySize(_ bytes: Int) -> String {
        if bytes < 1024 { return "\(bytes) B" }
        let kb = Double(bytes) / 1024.0
        if kb < 1024 { return String(format:"%.1f KB", kb) }
        let mb = kb / 1024.0
        return String(format:"%.2f MB", mb)
    }
}

// API 응답 구조체
struct TranslationResponse: Codable {
    let success: Bool
    let translatedWord: String?
    let translationId: String?
    let probability: Float?
    let message: String?
    let status: String?
}

// 상태 알림
extension Notification.Name {
    static let TranslationProgress = Notification.Name("TranslationProgress")
    static let TranslationFailed   = Notification.Name("TranslationFailed")
    static let TranslationSuccess  = Notification.Name("TranslationSuccess")
}

// AVCaptureVideoDataOutputSampleBufferDelegate 구현
extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let timestamp = Int(CMSampleBufferGetPresentationTimeStamp(sampleBuffer).seconds * 1000)
        processFrame(pixelBuffer, timestamp: timestamp)
    }
}
