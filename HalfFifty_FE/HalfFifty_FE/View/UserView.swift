//
//  UserView.swift
//  HalfFifty_FE
//
//  Created by 김민지 on 2/4/25.
//

import SwiftUI

struct UserView: View {
    @State private var nickname: String = "유고양" // 임시
    
    var body: some View {
        VStack {
            // 사용자 정보 리스트
            List {
                Section {
                    UserInfoRow(title: "이름", value: "유수현")
                    UserInfoRow(title: "전화번호", value: "010-4148-8137")
                    UserInfoRow(title: "계정 생성일", value: "2024.01.07")
                }
                
                Section {
                    NavigationLink(destination: NicknameEditView(nickname: $nickname)) {
                        HStack {
                            Text("닉네임")
                                .foregroundColor(.black)
                            Spacer()
                            Text(nickname)
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
    NavigationView {
        UserView()
    }
}
