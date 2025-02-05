//
//  UserView.swift
//  HalfFifty_FE
//
//  Created by 김민지 on 2/4/25.
//

import SwiftUI

struct UserView: View {
    @ObservedObject var userViewModel: UserViewModel // ViewModel 사용

    var body: some View {
        VStack {
            List {
                Section {
                    UserInfoRow(title: "이름", value: "유수현")
                    UserInfoRow(title: "전화번호", value: userViewModel.phoneNumber)
                    UserInfoRow(title: "계정 생성일", value: userViewModel.createdAt)
                }
                
                Section {
                    NavigationLink(destination: NicknameEditView(userViewModel: userViewModel)) { // 닉네임을 바인딩하여 전달
                        HStack {
                            Text("닉네임")
                                .foregroundColor(.black)
                            Spacer()
                            Text(userViewModel.nickname) // 변경된 닉네임 반영
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
        }
        .navigationTitle("사용자 정보")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// 사용자 정보 행 뷰
struct UserInfoRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.black)
            Spacer()
            Text(value)
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    NavigationStack {
        UserView(userViewModel: UserViewModel())
    }
}
