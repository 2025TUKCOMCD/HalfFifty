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
        overlayView.frame = view.bounds
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
        let imageSize = overlayView.bounds.size
        
        if imageSize.width == 0 || imageSize.height == 0 {
            print("이미지 크기 오류: \(imageSize), 기본 크기로 설정")
            return
        }

        UIGraphicsBeginImageContext(imageSize)
        guard let context = UIGraphicsGetCurrentContext() else { return }

        context.clear(CGRect(origin: .zero, size: imageSize))
        context.setStrokeColor(UIColor.green.cgColor)
        context.setLineWidth(2.0)

        for hand in result.landmarks {
            var points: [CGPoint] = []
            
            for landmark in hand {
                var x = CGFloat(landmark.x) * imageSize.width
                var y = (1 - CGFloat(landmark.y)) * imageSize.height
                
                if isFrontCamera {
                    // 전면 카메라: 90도 오른쪽 회전
                    let tempX = x
                    x = imageSize.width - y
                    y = tempX
                } else {
                    // 후면 카메라: 90도 왼쪽 회전 + y축 반전
                    let tempX = x
                    x = y
                    y = imageSize.height - tempX
                    y = imageSize.height - y
                }
                
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
        }
    }
}

// AVCaptureVideoDataOutputSampleBufferDelegate 구현
extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let timestamp = Int(CMSampleBufferGetPresentationTimeStamp(sampleBuffer).seconds * 1000)
        processFrame(pixelBuffer, timestamp: timestamp)
    }
}
