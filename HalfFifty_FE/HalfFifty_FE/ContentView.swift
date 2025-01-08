//
//  ContentView.swift
//  HalfFifty_FE
//
//  Created by 김민지 on 1/6/25.
//

import SwiftUI

struct ContentView: View {
    // 메인 뷰 표시 여부
    @State private var showMainView = false
    
    // 메뉴 표시 여부
    @State var showMenuView: Bool = false
        
    var body: some View {
        // 오른쪽에서 왼쪽으로 드래그하여 메뉴를 닫을 수 있음
        let drag = DragGesture()
            .onEnded {
                if $0.translation.width < -100 {
                    withAnimation(.easeOut(duration: 0.4)) { // 닫기 애니메이션 설정
                        self.showMenuView = false
                    }
                }
            }
        
        return NavigationView {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    if self.showMainView {
                        // 메뉴 표시 여부 바인딩
                        MainView(showMenuView: $showMenuView)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .disabled(self.showMenuView ? true : false) // 메뉴 표시되어 있는 상태면 메인 뷰 기능 비활성화
                        
                        if self.showMenuView {
                            // 반투명한 배경 추가 (MenuView 외부 터치 감지)
                            Color.black.opacity(0.3)
                                .ignoresSafeArea()
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.4)) {
                                        self.showMenuView = false
                                    }
                                }
                            
                            // MenuView 추가
                            MenuView()
                                .frame(width: geometry.size.width / 1.5) // 메인 뷰 위에 1.5만큼만 오픈
                                .transition(.move(edge: .leading).combined(with: .opacity)) // 부드럽게 메뉴 열기
                        }
                    } else {
                        SplashView()
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                    withAnimation { // 시작 애니메이션도 동일한 속도로 설정
                                        self.showMainView = true
                                    }
                                }
                            }
                    }
                }
                .gesture(drag)
            }
        }
    }
}

#Preview {
    ContentView()
}
