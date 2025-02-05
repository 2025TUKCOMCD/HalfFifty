//
//  NicknameEditView.swift
//  HalfFifty_FE
//
//  Created by 김민지 on 2/5/25.
//

import SwiftUI

struct NicknameEditView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var userViewModel: UserViewModel
    @State private var tempNickname: String

    // "저장" 버튼 활성화 여부 (기존 닉네임과 입력값 비교)
    private var isSaveButtonEnabled: Bool {
        return !tempNickname.isEmpty && tempNickname != userViewModel.nickname
    }

    init(userViewModel: UserViewModel) {
        self.userViewModel = userViewModel
        self._tempNickname = State(initialValue: userViewModel.nickname)
    }

    var body: some View {
        VStack {
            // 닉네임 입력 필드
            VStack(alignment: .leading) {
                Text("닉네임")
                    .foregroundColor(.gray)
                    .font(.system(size: 12))
                    .padding(.leading)
                TextField("닉네임을 입력하세요", text: $tempNickname) // placeholder 없이 빈 값
                    .padding(12)
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color.white))
                    .disableAutocorrection(true)  // 자동 수정 비활성화
                    .textInputAutocapitalization(.never)  // 대문자 자동 변환 방지
            }
            .padding(.horizontal)
            .padding(.top, 20)

            Spacer()
        }
        .background(Color(UIColor.systemGray6))
        .onAppear {
            self.tempNickname = userViewModel.nickname // 키보드 세션이 사라지지 않도록 초기화
        }
        .navigationBarTitle("닉네임", displayMode: .inline) // 제목 중앙 정렬
        .navigationBarItems(
            leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) { },
            trailing: Button(action: {
                saveNickname() // "저장" 버튼을 눌렀을 때만 값 업데이트
            }) {
                Text("저장")
                    .foregroundColor(isSaveButtonEnabled ? .blue : .gray) // 활성화 여부에 따라 색상 변경
            }
            .disabled(!isSaveButtonEnabled) // 기존 닉네임과 다를 때만 활성화
        )
    }

    private func saveNickname() {
        userViewModel.nickname = tempNickname
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    NavigationStack {
        NicknameEditView(userViewModel: UserViewModel())
    }
}
