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
    @State private var tempFontSize: CGFloat = 16 // 슬라이더에서 임시 변경된 값
    @State private var isSaveButtonDisabled: Bool = true // 버튼 활성화 상태 관리

    let fontSizes: [CGFloat] = [12, 14, 16, 18, 20]
    let labels = ["작게", "조금 작게", "보통", "조금 크게", "크게"]

    var body: some View {
        VStack {
            Slider(
                value: Binding(
                    get: { Double(tempFontSize) }, // 임시 값 사용
                    set: { newValue in tempFontSize = CGFloat(newValue) }
                ),
                in: Double(fontSizes.first!)...Double(fontSizes.last!),
                step: 2
            )
            .accentColor(.blue)
            .padding(.horizontal)
            .onChange(of: tempFontSize) { _, _ in
                isSaveButtonDisabled = (tempFontSize == initialFontSize)
            }


            // 글자 크기 라벨
            HStack {
                ForEach(0..<labels.count, id: \.self) { index in
                    Text(labels[index])
                        .font(.system(size: fontSizes[index]))
                        .foregroundColor(fontSizes[index] == tempFontSize ? .blue : .black)
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
            .foregroundColor(isSaveButtonDisabled ? .gray : .blue) // 버튼 색상 변경
            .disabled(isSaveButtonDisabled) // 변경되지 않았다면 비활성화
        )
        .background(Color(UIColor.systemGray6))
        .onAppear {
            initialFontSize = fontSizeManager.fontSize // 초기값 저장
            tempFontSize = fontSizeManager.fontSize // 슬라이더와 동기화
            isSaveButtonDisabled = true // 초기 상태에서 비활성화
        }
    }
    
    // 선택한 글자 크기 저장
    private func saveFontSize() {
        fontSizeManager.fontSize = tempFontSize // 저장 시만 업데이트
        UserDefaults.standard.set(fontSizeManager.fontSize, forKey: "selectedFontSize")
        isSaveButtonDisabled = true // 저장 후 다시 비활성화
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    NavigationView {
        FontSizeSettingView().environmentObject(FontSizeManager())
    }
}
