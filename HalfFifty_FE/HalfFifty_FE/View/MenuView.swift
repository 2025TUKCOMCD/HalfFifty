//
//  MenuView.swift
//  HalfFifty_FE
//
//  Created by 김민지 on 1/8/25.
//

import SwiftUI

struct MenuView: View {
    @Binding var showMenuView: Bool
    @ObservedObject var userViewModel: UserViewModel // ViewModel로 상태 관리

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                HStack {
                    // 사용자 이름
                    HStack(alignment: .bottom) {
                        Text(userViewModel.nickname) // ViewModel에서 닉네임 가져옴
                            .font(.system(size: 24))
                        Text("님")
                            .font(.system(size: 14))
                    }
                    
                    Spacer()
                    
                    // 로그아웃 버튼
                    HStack {
                        Text("로그아웃")
                            .foregroundColor(.gray)
                            .font(.system(size: 12))
                        Image(systemName: "chevron.forward")
                            .foregroundColor(.gray)
                            .imageScale(.small)
                    }
                }
                .padding(.bottom, 72)
                .padding(.top, 85)
                
                // 메뉴 목록
                VStack(alignment: .leading, spacing: 26) {
                    Button(action: {
                        withAnimation(.easeOut(duration: 0.4)) {
                            self.showMenuView = false
                        }
                    }) {
                        MenuItem(icon: "house", text: "홈")
                    }

                    NavigationLink(destination: Text("history")) {
                        MenuItem(icon: "clock.arrow.trianglehead.counterclockwise.rotate.90", text: "번역 기록")
                    }
                    
                    NavigationLink(destination: UserView(userViewModel: userViewModel)) { // ViewModel 전달
                        MenuItem(icon: "person", text: "사용자 정보")
                    }
                    
                    NavigationLink(destination: Text("keyword")) {
                        MenuItem(icon: "tag", text: "키워드")
                    }
                    
                    NavigationLink(destination: SettingView()) {
                        MenuItem(icon: "slider.horizontal.3", text: "설정")
                    }
                    
                    NavigationLink(destination: Text("tutorial")) {
                        MenuItem(icon: "lightbulb", text: "사용방법")
                    }
                }
                Spacer()
            }
            .padding(30)
            .frame(maxHeight: .infinity)
            .background(Color.white)
        }
    }
}

#Preview {
    MenuView(showMenuView: .constant(false), userViewModel: UserViewModel())
}

// 메뉴 아이템 공통 뷰
struct MenuItem: View {
    var icon: String
    var text: String

    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: icon)
                .imageScale(.small)
            Text(text)
                .font(.system(size: 18))
        }
        .foregroundColor(.black)
    }
}
