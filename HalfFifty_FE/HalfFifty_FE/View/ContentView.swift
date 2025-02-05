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

    // UserViewModel 인스턴스 생성
    @StateObject private var userViewModel = UserViewModel()
        
    var body: some View {
        let drag = DragGesture()
            .onEnded {
                if $0.translation.width < -100 {
                    withAnimation(.easeOut(duration: 0.4)) {
                        self.showMenuView = false
                    }
                }
            }
        
        return NavigationStack {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    if self.showMainView {
                        // 메뉴 표시 여부 바인딩
                        MainView(showMenuView: $showMenuView)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .disabled(self.showMenuView) // 메뉴 표시 상태면 메인 뷰 비활성화
                        
                        if self.showMenuView {
                            MenuView(showMenuView: $showMenuView, userViewModel: userViewModel) // ViewModel 전달
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
