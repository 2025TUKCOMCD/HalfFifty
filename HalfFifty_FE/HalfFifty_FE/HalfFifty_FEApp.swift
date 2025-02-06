//
//  HalfFifty_FEApp.swift
//  HalfFifty_FE
//
//  Created by 김민지 on 1/6/25.
//

import SwiftUI

@main
struct HalfFifty_FEApp: App {
    @StateObject private var fontSizeManager = FontSizeManager() // 앱 전역 폰트 설정

    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
                .environmentObject(fontSizeManager) // 모든 뷰에 적용
        }
    }
}
