//
//  CameraView.swift
//  HalfFifty_FE
//
//  Created by 김민지 on 1/12/25.
//

import SwiftUI
import AVFoundation

struct CameraView: UIViewControllerRepresentable {
    @Binding var isFrontCamera: Bool
    @Binding var cameraFrame: CGRect // MainView에서 전달받을 카메라 크기

    func makeUIViewController(context: Context) -> CameraViewController {
        let viewController = CameraViewController()
        viewController.isFrontCamera = isFrontCamera
        viewController.cameraFrame = cameraFrame // 카메라 크기 전달
        return viewController
    }

    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {
        if uiViewController.isFrontCamera != isFrontCamera {
            uiViewController.switchCamera()
        }

        if uiViewController.cameraFrame != cameraFrame {
            uiViewController.cameraFrame = cameraFrame
            uiViewController.view.setNeedsLayout() // ← layout 업데이트 유도
        }
    }
}
