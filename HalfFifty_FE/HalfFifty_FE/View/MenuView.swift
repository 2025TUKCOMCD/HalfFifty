//
//  MenuView.swift
//  HalfFifty_FE
//
//  Created by 김민지 on 1/8/25.
//

import SwiftUI

struct MenuView: View {
    @Binding var showMenuView: Bool
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                // 사용자 이름과 로그아웃 버튼
                VStack(alignment: .leading) {
                    HStack {
                        // 사용자 이름
                        HStack(alignment: .bottom) {
                            Text("유고양이")
                                .font(.system(size: 24))
                            Text("님")
                                .font(.system(size: 14))
                        }
                        
                        Spacer()
                        
                        // 로그아웃 버튼
                        HStack {
                            Text("로그아웃")
                                .foregroundColor(Color(red: 0.4549019607843137, green: 0.4549019607843137, blue: 0.4549019607843137))
                                .font(.system(size: 12))
                            Image(systemName: "chevron.forward")
                                .foregroundColor(Color(red: 0.4549019607843137, green: 0.4549019607843137, blue: 0.4549019607843137))
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
                            HStack(alignment: .center) {
                                Image(systemName: "house")
                                    .imageScale(.small)
                                Text("홈")
                                    .font(.system(size: 18))
                            }
                            .foregroundColor(.black)
                        }
                        HStack(alignment: .center) {
                            NavigationLink(destination: Text("history")) {
                                Image(systemName: "clock.arrow.trianglehead.counterclockwise.rotate.90")
                                    .imageScale(.small)
                                Text("번역 기록")
                                    .font(.system(size: 18))
                            }
                            .foregroundColor(.black)
                        }
                        HStack(alignment: .center) {
                            NavigationLink(destination: UserView()) {
                                Image(systemName: "person")
                                    .imageScale(.small)
                                Text("사용자 정보")
                                    .font(.system(size: 18))
                            }
                            .foregroundColor(.black)
                        }
                        HStack(alignment: .center) {
                            NavigationLink(destination: Text("keyword")) {
                                Image(systemName: "tag")
                                    .imageScale(.small)
                                Text("키워드")
                                    .font(.system(size: 18))
                            }
                            .foregroundColor(.black)
                        }
                        HStack(alignment: .center) {
                            NavigationLink(destination: Text("setting")) {
                                Image(systemName: "slider.horizontal.3")
                                    .imageScale(.small)
                                Text("설정")
                                    .font(.system(size: 18))
                            }
                            .foregroundColor(.black)
                        }
                        HStack(alignment: .center) {
                            NavigationLink(destination: Text("tutorial")){
                                Image(systemName: "lightbulb")
                                    .imageScale(.small)
                                Text("사용방법")
                                    .font(.system(size: 18))
                            }
                            .foregroundColor(.black)
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
}

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

#Preview {
    MenuView(showMenuView: .constant(false))
}
