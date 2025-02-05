//
//  NicknameEditView.swift
//  HalfFifty_FE
//
//  Created by 김민지 on 2/5/25.
//

import SwiftUI

// 닉네임 수정 화면
struct NicknameEditView: View {
    @Environment(\.presentationMode) var presentationMode // 뒤로 가기 기능을 위한 환경 변수
    @Binding var nickname: String // 기존 닉네임 값

    var body: some View {
        Form {
            Section(header: Text("닉네임")) {
                TextField(nickname, text: $nickname)
            }
        }
        .navigationBarTitle("닉네임", displayMode: .inline) // 중앙 정렬된 제목
        .navigationBarItems(
            trailing: Button(action: {
                saveNickname()
            }) {
                Text("저장")
                    .foregroundColor(.blue)
            }
        )
        .background(Color(UIColor.systemGray6)) // 배경 색상 맞추기
    }

    // 닉네임 저장 함수 (API 연동)
    private func saveNickname() {
        print("닉네임 저장: \(nickname)")
        presentationMode.wrappedValue.dismiss() // 저장 후 닫기
    }
}

#Preview {
    // 테스트용 프리뷰
    NavigationView {
        NicknameEditView(nickname: .constant("유고양"))
    }
}
