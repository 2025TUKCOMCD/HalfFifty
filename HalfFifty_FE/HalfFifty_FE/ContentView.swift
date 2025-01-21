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
                            .disabled(self.showMenuView) // 메뉴 표시 상태면 메인 뷰 비활성화
                        
                        if self.showMenuView {
                            // 반투명한 배경 추가 (MenuView 외부 터치 감지)
                            Color.black.opacity(0.3)
                                .ignoresSafeArea()
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.4)) {
                                        self.showMenuView = false
                                    }
                                }
                                .zIndex(1) // MenuView보다 뒤로 배치

                            // MenuView 추가
                            MenuView()
                                .frame(width: geometry.size.width / 1.5)
                                .transition(.move(edge: .leading).combined(with: .opacity))
                                .zIndex(2) // 항상 최상위에 있도록 설정
                        }
                    } else {
                        SplashView()
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                    withAnimation {
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
