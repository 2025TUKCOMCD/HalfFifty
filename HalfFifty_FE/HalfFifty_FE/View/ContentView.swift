//  ContentView.swift
//  HalfFifty_FE
//
//  Created by 김민지 on 1/6/25.
//

import SwiftUI

struct ContentView: View {
    // 메인 뷰 표시 여부
    @State private var showMainView = false
    
    // 튜토리얼 뷰 표시 여부
    @State private var showTutorialView = false
    
    // 메뉴 표시 여부
    @State var showMenuView: Bool = false

    // UserViewModel 인스턴스 생성
    @StateObject private var userViewModel = UserViewModel()
    
    // userId로 fetchUser를 중복 호출하지 않기 위한 플래그
    @State private var didFetchUser = false
        
    var body: some View {
        let drag = DragGesture()
            .onEnded {
                if $0.translation.width < -100 {
                    withAnimation(.easeOut(duration: 0.4)) {
                        self.showMenuView = false
                    }
                }
            }
        
        let isLoggedIn = !userViewModel.userId.isEmpty // 로그인 여부 판단
        
        return NavigationStack {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    if !isLoggedIn {
                        LoginView()
                            .environmentObject(userViewModel)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        if self.showMainView {
                            if self.showTutorialView {
                                TutorialView(showTutorialView: $showTutorialView) // 바인딩 전달
                            } else {
                                // 메뉴 표시 여부 바인딩
                                MainView(showMenuView: $showMenuView)
                                    .frame(width: geometry.size.width, height: geometry.size.height)
                                    .disabled(self.showMenuView) // 메뉴 표시 상태면 메인 뷰 비활성화
                                
                                if self.showMenuView {
                                    MenuView(showMenuView: $showMenuView, userViewModel: userViewModel)
                                        .transition(.move(edge: .leading).combined(with: .opacity))
                                        .zIndex(2) // 항상 최상위에 있도록 설정
                                }
                            }
                        } else {
                            SplashView()
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                        withAnimation {
                                            let isFirstLaunch = !UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
                                            self.showTutorialView = isFirstLaunch
                                            self.showMainView = true
                                            
                                            if isFirstLaunch {
                                                UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
                                            }
                                        }
                                    }
                                }
                        }
                    }
                }
                .gesture(drag)
            }
        }
        // 앱 시작 시 이미 userId가 있다면 한 번만 조회
        .onAppear {
            if !userViewModel.userId.isEmpty && !didFetchUser {
                didFetchUser = true
                userViewModel.fetchUser(userId: userViewModel.userId)
            }
        }
        .onChange(of: userViewModel.userId, initial: true) { oldValue, newValue in
            guard !newValue.isEmpty, !didFetchUser else { return }
            didFetchUser = true
            userViewModel.fetchUser(userId: newValue)
        }

    }
}

#Preview {
    ContentView()
}
