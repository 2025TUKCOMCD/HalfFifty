//
//  MainView.swift
//  HalfFifty_FE
//
//  Created by 김민지 on 1/8/25.
//

import SwiftUI

struct MainView: View {
    // 메뉴 표시 여부 바인딩
    @Binding var showMenuView : Bool
    
    var body: some View {
        GeometryReader { geometry in
            // Header
            HStack {
                Button(action: {
                    // 버튼 클릭 시
                    withAnimation {
                        self.showMenuView = true
                    }
                }) {
                    // 버튼 스타일
                    Image(systemName: "line.3.horizontal")
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                // 로고
                Text("手다쟁이")
                    .font(.system(size: 15))
                
                Spacer()
                
                // 정렬을 위한 페이크 아이콘
                Image(systemName: "line.3.horizontal")
                    .foregroundColor(Color("AccentColor"))
            }
            .padding(.top, 22)
            .padding(.bottom, 22)
            .padding(.leading, 20)
            .padding(.trailing, 20)
            .frame(width: geometry.size.width)
        }
    }
}
