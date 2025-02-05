//
//  FontSizeSettingView.swift
//  HalfFifty_FE
//
//  Created by 김민지 on 2/6/25.
//

import SwiftUI

struct FontSizeSettingView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var fontSizeManager: FontSizeManager // 전역 폰트 설정 사용
    @State private var initialFontSize: CGFloat = 16 // 초기 글자 크기 저장

    let fontSizes: [CGFloat] = [12, 14, 16, 18, 20]
    let labels = ["작게", "조금 작게", "보통", "조금 크게", "크게"]

    var body: some View {
        VStack {
            Slider(
                value: Binding(
                    get: { Double(fontSizeManager.fontSize) },
                    set: { newValue in fontSizeManager.fontSize = CGFloat(newValue) }
                ),
                in: Double(fontSizes.first!)...Double(fontSizes.last!),
                step: 2
            )
            .accentColor(.blue)
            .padding(.horizontal)

            // 글자 크기 라벨
            HStack {
                ForEach(0..<labels.count, id: \.self) { index in
                    Text(labels[index])
                        .font(.system(size: fontSizes[index]))
                        .foregroundColor(fontSizes[index] == fontSizeManager.fontSize ? .blue : .black)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.top, 5)
            
            Spacer()
        }
        .padding(.top)
        .navigationTitle("글자 크기 설정")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(
            leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
            },
            trailing: Button("저장") {
                saveFontSize()
            }
            .foregroundColor(.blue)
            .disabled(fontSizeManager.fontSize == initialFontSize) // 초기 값과 비교하여 변경되지 않았으면 비활성화
        )
        .background(Color(UIColor.systemGray6))
        .onAppear {
            initialFontSize = fontSizeManager.fontSize // 초기 글자 크기 저장
        }
    }
    
    // 선택한 글자 크기 저장
    private func saveFontSize() {
        UserDefaults.standard.set(fontSizeManager.fontSize, forKey: "selectedFontSize")
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    NavigationView {
        FontSizeSettingView().environmentObject(FontSizeManager())
    }
}
