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
    // Properties
    var captureSession: AVCaptureSession? // 카메라 세션 관리
    var videoPreviewLayer: AVCaptureVideoPreviewLayer? // 카메라 미리보기 레이어
    var currentDevice: AVCaptureDevice? // 현재 사용 중인 카메라 디바이스
    var handLandmarker: HandLandmarker? // Mediapipe HandLandmarker 객체
    var isFrontCamera: Bool = true // 전면/후면 카메라 상태
    var cameraFrame: CGRect = .zero // MainView에서 전달받은 카메라 크기

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera() // 카메라 설정
        setupHandLandmarker() // Mediapipe HandLandmarker 설정
    }

    // 카메라 초기화
    func setupCamera() {
        captureSession = AVCaptureSession()
        guard let captureSession = captureSession else { return }

        if isFrontCamera {
            // 전면 카메라 설정
            currentDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
        } else {
            // 후면 카메라에서 기본 카메라(광각 카메라가 아닌 일반 1배율 카메라) 선택
            let deviceTypes: [AVCaptureDevice.DeviceType] = [
                .builtInTripleCamera,  // iPhone 11 Pro 이상
                .builtInDualCamera,    // iPhone X, XS, 11, 12, 13 기본 카메라
                .builtInWideAngleCamera // iPhone SE, iPhone 7, 8 기본 카메라
            ]
            
            let discoverySession = AVCaptureDevice.DiscoverySession(
                deviceTypes: deviceTypes,
                mediaType: .video,
                position: .back
            )

            currentDevice = discoverySession.devices.first  // 가장 먼저 감지된 기본 카메라 선택
            
            if let backCamera = currentDevice {
                do {
                    try backCamera.lockForConfiguration()
                    backCamera.videoZoomFactor = 1.0  // 1배율로 강제 설정
                    backCamera.unlockForConfiguration()
                } catch {
                    print("후면 카메라 1배율 설정 실패: \(error.localizedDescription)")
                }
            }
        }

        guard let videoCaptureDevice = currentDevice else {
            print("카메라를 찾을 수 없습니다.")
            return
        }

        do {
            // 기존 입력 제거 (카메라 전환 시 필요)
            if let currentInput = captureSession.inputs.first {
                captureSession.removeInput(currentInput)
            }

            let videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            if captureSession.canAddInput(videoInput) {
                captureSession.addInput(videoInput)
            } else {
                print("비디오 입력을 추가할 수 없습니다.")
                return
            }

            // 기존 출력 제거 후 다시 추가 (카메라 전환 시 필요)
            if let currentOutput = captureSession.outputs.first {
                captureSession.removeOutput(currentOutput)
            }

            let videoOutput = AVCaptureVideoDataOutput()
            videoOutput.videoSettings = [
                kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA
            ]
            videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
            if captureSession.canAddOutput(videoOutput) {
                captureSession.addOutput(videoOutput)
            } else {
                print("비디오 출력을 추가할 수 없습니다.")
                return
            }

            // 미리보기 레이어 설정
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = .resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            if let videoPreviewLayer = videoPreviewLayer {
                view.layer.addSublayer(videoPreviewLayer)
            }

            // 세션 시작
            DispatchQueue.global(qos: .userInitiated).async {
                captureSession.startRunning()
            }
        } catch {
            print("카메라 초기화 중 에러 발생: \(error.localizedDescription)")
        }
    }
    
    func switchCamera() {
        self.isFrontCamera.toggle()
        setupCamera()
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
            options.numHands = 2 // 감지할 손의 최대 개수
            
            handLandmarker = try HandLandmarker(options: options)
        } catch {
            print("HandLandmarker 초기화 중 에러 발생: \(error.localizedDescription)")
        }
    }

    // 프레임 데이터 처리
    func processFrame(_ pixelBuffer: CVPixelBuffer) {
        guard let handLandmarker = handLandmarker else { return }
        
        // 픽셀 버퍼를 정사각형으로 변환
        guard let resizedPixelBuffer = resizePixelBufferToSquare(pixelBuffer) else {
            print("정사각형으로 변환 중 에러 발생")
            return
        }
        
        do {
            // Mediapipe 이미지 생성
            let mpImage = try MPImage(pixelBuffer: resizedPixelBuffer)
            
            // 손 랜드마크 감지
            let result = try handLandmarker.detect(image: mpImage)
            
            // 감지 결과 표시
            drawLandmarks(result.landmarks)
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
        (0, 17), (17, 18), (18, 19), (19, 20)  // 새끼
    ]
}

// AVCaptureVideoDataOutputSampleBufferDelegate 구현
extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        processFrame(pixelBuffer)
    }
}
