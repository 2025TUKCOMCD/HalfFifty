//
//  SplashView.swift
//  HalfFifty_FE
//
//  Created by 김민지 on 1/8/25.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color.white
                .opacity(0.3)
                .ignoresSafeArea() // 배경 색
            
            VStack {
                Spacer() // 위쪽 여백
                
                Image("logo") // 로고 이미지
                
                Spacer() // 아래쪽 여백
            }
        }
    }
}

#Preview {
    SplashView()
}
