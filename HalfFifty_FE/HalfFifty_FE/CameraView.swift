//
//  CameraView.swift
//  HalfFifty_FE
//
//  Created by 김민지 on 1/12/25.
//

import SwiftUI
import AVFoundation

struct CameraView: UIViewControllerRepresentable {
    @Binding var isFrontCamera: Bool // 전면/후면 카메라 상태
    
    func makeUIViewController(context: Context) -> CameraViewController {
        let viewController = CameraViewController()
        viewController.isFrontCamera = isFrontCamera
        return viewController
    }

    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {
        // 전면/후면 카메라 상태 변경 시 세션 재구성
        if uiViewController.isFrontCamera != isFrontCamera {
            uiViewController.isFrontCamera = isFrontCamera
            uiViewController.setupCamera()
        }
    }
}
