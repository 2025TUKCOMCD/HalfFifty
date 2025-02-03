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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera() // 카메라 설정
        setupHandLandmarker() // Mediapipe HandLandmarker 설정
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

        // 백그라운드 스레드에서 실행
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
                    
                    if position == .back {
                        if initialBackCameraZoomFactor == 1.0 {
                            initialBackCameraZoomFactor = currentDevice.videoZoomFactor
                        } else {
                            try? currentDevice.lockForConfiguration()
                            currentDevice.videoZoomFactor = initialBackCameraZoomFactor
                            currentDevice.unlockForConfiguration()
                        }
                    }
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
        overlayView.frame = view.bounds
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        captureSession.stopRunning()
    }
    
    // HandLandmarker의 실시간 감지 결과를 처리할 클래스
    class HandLandmarkerResultProcessor: NSObject, HandLandmarkerLiveStreamDelegate {
        weak var parent: CameraViewController?

        init(parent: CameraViewController) {
            self.parent = parent
        }

        func handLandmarker(
            _ handLandmarker: HandLandmarker,
            didFinishDetection result: HandLandmarkerResult?,
            timestampInMilliseconds: Int,
            error: Error?
        ) {
            guard let result = result else { return }
            DispatchQueue.main.async {
                self.parent?.drawLandmarks(result.landmarks)
            }
        }
    }

    // Mediapipe HandLandmarker 초기화
    func setupHandLandmarker() {
        guard let modelPath = Bundle.main.path(forResource: "hand_landmarker", ofType: "task") else {
            print("hand_landmarker.task 모델을 찾을 수 없습니다.")
            return
        }

        do {
            let options = HandLandmarkerOptions()
            options.baseOptions.modelAssetPath = modelPath
            options.runningMode = .liveStream  // 실시간 스트리밍 모드 설정
            options.numHands = 2 // 감지할 손의 최대 개수
            options.minHandDetectionConfidence = 0.5
            options.minHandPresenceConfidence = 0.5
            options.minTrackingConfidence = 0.5

            handProcessor = HandLandmarkerResultProcessor(parent: self)
            options.handLandmarkerLiveStreamDelegate = handProcessor

            handLandmarker = try HandLandmarker(options: options)
        } catch {
            print("HandLandmarker 초기화 중 에러 발생: \(error.localizedDescription)")
        }
    }

    // 프레임 데이터 처리
    func processFrame(_ pixelBuffer: CVPixelBuffer, timestamp: Int) {
        guard let handLandmarker = handLandmarker else { return }

        // 픽셀 버퍼를 정사각형으로 변환
        guard let resizedPixelBuffer = resizePixelBufferToSquare(pixelBuffer) else {
            print("정사각형으로 변환 중 에러 발생")
            return
        }

        do {
            // Mediapipe 이미지 생성
            let mpImage = try MPImage(pixelBuffer: resizedPixelBuffer)

            // Live Stream 모드에서는 detectAsync 사용
            try handLandmarker.detectAsync(image: mpImage, timestampInMilliseconds: timestamp)
        } catch {
            print("프레임 처리 중 에러 발생: \(error.localizedDescription)")
        }
    }

    func resizePixelBufferToSquare(_ pixelBuffer: CVPixelBuffer) -> CVPixelBuffer? {
        let width = CVPixelBufferGetWidth(pixelBuffer)
        let height = CVPixelBufferGetHeight(pixelBuffer)
        let squareSize = min(width, height) // 정사각형 기준 크기
        
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let context = CIContext()
        
        // 정사각형 크기로 크롭
        let croppedImage = ciImage.cropped(to: CGRect(x: 0, y: 0, width: CGFloat(squareSize), height: CGFloat(squareSize)))
        
        // 새로운 PixelBuffer 생성
        var newPixelBuffer: CVPixelBuffer?
        let pixelBufferAttributes: [String: Any] = [
            kCVPixelBufferCGImageCompatibilityKey as String: true,
            kCVPixelBufferCGBitmapContextCompatibilityKey as String: true
        ]
        
        let status = CVPixelBufferCreate(
            kCFAllocatorDefault,
            Int(squareSize),
            Int(squareSize),
            kCVPixelFormatType_32BGRA,
            pixelBufferAttributes as CFDictionary,
            &newPixelBuffer
        )
        
        guard status == kCVReturnSuccess, let outputPixelBuffer = newPixelBuffer else {
            return nil
        }
        
        // 변환된 이미지를 새로운 PixelBuffer에 렌더링
        context.render(croppedImage, to: outputPixelBuffer)
        return outputPixelBuffer
    }

    // 랜드마크 및 연결선 그리기
    func drawLandmarks(_ landmarks: [[NormalizedLandmark]]) {
        DispatchQueue.main.async {
            // 기존 랜드마크 제거
            self.view.layer.sublayers?.removeAll(where: { $0.name == "landmark" || $0.name == "connection" })

            let viewWidth = self.cameraFrame.width
            let viewHeight = self.cameraFrame.height
            let yOffsetCorrection: CGFloat = self.isFrontCamera ? viewHeight * 0.05 : 0  // 전면 카메라 Y 보정값 추가

            for hand in landmarks {
                var adjustedLandmarks: [CGPoint] = []

                for landmark in hand {
                    var x = CGFloat(landmark.x) * viewWidth
                    var y = (1.0 - CGFloat(landmark.y)) * viewHeight

                    if self.isFrontCamera {
                        // 전면 카메라: 180도 회전 및 좌우 반전 해제
                        x = viewWidth - x
                        y = viewHeight - y - yOffsetCorrection  // Y 보정값 적용
                    } else {
                        // 후면 카메라: 좌우 반전 해제
                        x = viewWidth - x
                    }

                    // 90도 회전 문제 해결 (x와 y를 서로 변환)
                    let tempX = x
                    x = y
                    y = viewHeight - tempX

                    adjustedLandmarks.append(CGPoint(x: x, y: y))

                    // 랜드마크 점
                    let pointLayer = CALayer()
                    pointLayer.name = "landmark"
                    pointLayer.frame = CGRect(x: x - 2.5, y: y - 2.5, width: 5, height: 5)
                    pointLayer.cornerRadius = 2.5
                    pointLayer.backgroundColor = UIColor.red.cgColor
                    self.view.layer.addSublayer(pointLayer)
                }

                // 연결선에도 동일한 Y 보정 적용
                let connections = HandLandmarker.handConnections
                for connection in connections {
                    var startLandmark = adjustedLandmarks[connection.0]
                    var endLandmark = adjustedLandmarks[connection.1]

                    // Y 보정값 적용
                    if self.isFrontCamera {
                        startLandmark.y -= yOffsetCorrection
                        endLandmark.y -= yOffsetCorrection
                    }

                    let lineLayer = CAShapeLayer()
                    lineLayer.name = "connection"
                    let path = UIBezierPath()
                    path.move(to: startLandmark)
                    path.addLine(to: endLandmark)
                    lineLayer.path = path.cgPath
                    lineLayer.strokeColor = UIColor.green.cgColor
                    lineLayer.lineWidth = 2.0
                    self.view.layer.addSublayer(lineLayer)
                }
            }
        }
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

// AVCaptureVideoDataOutputSampleBufferDelegate 구현
extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        // 타임스탬프 추출 (밀리초 단위)
        let timestamp = CMSampleBufferGetPresentationTimeStamp(sampleBuffer).seconds * 1000

        // detectAsync 호출
        processFrame(pixelBuffer, timestamp: Int(timestamp))
    }
}
