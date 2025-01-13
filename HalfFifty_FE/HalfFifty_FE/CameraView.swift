//
//  CameraView.swift
//  HalfFifty_FE
//
//  Created by 김민지 on 1/12/25.
//

import SwiftUI
import AVFoundation

struct CameraView: UIViewControllerRepresentable {
    @Binding var isFrontCamera: Bool // 전면/후면 상태를 SwiftUI와 바인딩
    
    func makeUIViewController(context: Context) -> CameraViewController {
        let cameraVC = CameraViewController()
        cameraVC.currentDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: isFrontCamera ? .front : .back)
        return cameraVC
    }

    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {
        if (isFrontCamera && uiViewController.currentDevice?.position != .front) ||
            (!isFrontCamera && uiViewController.currentDevice?.position != .back) {
            uiViewController.switchCamera()
        }
    }
}

class CameraViewController: UIViewController {
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var currentDevice: AVCaptureDevice?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
    }
    
    func setupCamera() {
        captureSession = AVCaptureSession()
        guard let captureSession = captureSession else { return }
        
        currentDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) // 초기 카메라: 전면
        guard let videoCaptureDevice = currentDevice else { return }
        
        do {
            let videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            if captureSession.canAddInput(videoInput) {
                captureSession.addInput(videoInput)
            } else {
                print("Unable to add video input.")
            }
        } catch {
            print("Unable to access camera: \(error.localizedDescription)")
            return
        }
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = .resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        if let videoPreviewLayer = videoPreviewLayer {
            view.layer.addSublayer(videoPreviewLayer)
        }
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession?.startRunning()
        }
    }
    
    func switchCamera() {
        guard let captureSession = captureSession, let currentDevice = currentDevice else { return }
        captureSession.beginConfiguration()
        
        // 기존 입력 제거
        if let currentInput = captureSession.inputs.first {
            captureSession.removeInput(currentInput)
        }
        
        // 전면/후면 카메라 전환
        let newPosition: AVCaptureDevice.Position = currentDevice.position == .front ? .back : .front
        if let newDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: newPosition) {
            self.currentDevice = newDevice
            do {
                let newInput = try AVCaptureDeviceInput(device: newDevice)
                if captureSession.canAddInput(newInput) {
                    captureSession.addInput(newInput)
                } else {
                    print("Unable to add new video input.")
                }
            } catch {
                print("Unable to switch camera: \(error.localizedDescription)")
            }
        }
        
        captureSession.commitConfiguration()
    }
}
