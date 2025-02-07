//
//  SettingView.swift
//  HalfFifty_FE
//
//  Created by 김민지 on 2/6/25.
//

import SwiftUI

struct SettingView: View {
    @State private var isOn = false
    @EnvironmentObject var fontSizeManager: FontSizeManager // 전역 폰트 설정 사용

    let fontSizes: [CGFloat] = [12, 14, 16, 18, 20]
    let labels = ["작게", "조금 작게", "보통", "조금 크게", "크게"]

    var body: some View {
        VStack {
            HStack {
                Toggle("푸시 알림", isOn: $isOn)
                    .toggleStyle(SwitchToggleStyle(tint: Color.blue))
                    .font(.system(size: fontSizeManager.fontSize))
            }
            .padding(.vertical)
            
            NavigationLink(destination: FontSizeSettingView()) {
                HStack {
                    Text("글자 크기 설정")
                        .foregroundStyle(.black)
                        .font(.system(size: fontSizeManager.fontSize))

                    Spacer()
                    
                    Text(getFontSizeLabel())
                        .foregroundColor(.blue)
                        .font(.system(size: fontSizeManager.fontSize))
                }
            }
            .padding(.vertical)
            
            NavigationLink(destination: FAQView()) {
                HStack {
                    Text("FAQ")
                        .foregroundStyle(.black)
                        .font(.system(size: fontSizeManager.fontSize))
                    Spacer()
                }
            }
            .padding(.vertical)
            
            NavigationLink(destination: Text("고객센터")) {
                HStack {
                    Text("고객센터")
                        .foregroundStyle(.black)
                        .font(.system(size: fontSizeManager.fontSize))
                    Spacer()
                }
            }
            .padding(.vertical)
            
            Spacer()
        }
        .padding(.horizontal, 28)
        .navigationTitle("설정")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    //현재 글자 크기에 맞는 라벨 반환
    private func getFontSizeLabel() -> String {
        let fontSizes: [CGFloat] = [12, 14, 16, 18, 20]
        let labels = ["작게", "조금 작게", "보통", "조금 크게", "크게"]
        
        if let index = fontSizes.firstIndex(of: fontSizeManager.fontSize) {
            return labels[index]
        }
        return "보통"
    }
}

#Preview {
    NavigationView {
        SettingView().environmentObject(FontSizeManager())
    }
}
