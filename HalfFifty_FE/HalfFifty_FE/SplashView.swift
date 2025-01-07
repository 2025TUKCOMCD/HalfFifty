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
                
                Text("手다쟁이")
                    .foregroundColor(Color(red: 0.2549, green: 0.4118, blue: 0.8824))
                    .font(.system(size: 24))
                    .padding(.top, 10) // 이미지와 텍스트 사이 여백
                
                Spacer() // 아래쪽 여백
            }
        }
    }
}

#Preview {
    SplashView()
}
