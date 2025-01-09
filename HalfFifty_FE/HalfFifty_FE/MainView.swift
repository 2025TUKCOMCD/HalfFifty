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
            VStack {
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
                    
                    // 정렬을 위한 빈 투명 영역 추가
                    Color.clear
                        .frame(width: 24, height: 24)

                }
                .padding(.top, 22)
                .padding(.bottom, 22)
                .padding(.leading, 20)
                .padding(.trailing, 20)
                .frame(width: geometry.size.width)
                .background(Color.white)
                .shadow(radius: 4)
                
                VStack {
                    VStack {
                        // 번역 선택
                        HStack(alignment: .center) {
                            Text("수어")
                                .font(.system(size: 20))
                                .frame(width: 75)
                            
                            Spacer()
                            
                            // 번역 전환 버튼
                            Button(action: {
                                // 버튼 클릭 시
                            }) {
                                // 버튼 스타일
                                Image(systemName: "arrow.left.arrow.right")
                                    .padding(.horizontal, 19)
                                    .padding(.vertical, 6)
                                    .cornerRadius(18)
                                    .background(Color.white)
                                    .foregroundColor(Color(red: 0.2549019607843137, green: 0.4117647058823529, blue: 0.8823529411764706))
                                    .cornerRadius(18)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                // 버튼 클릭 시
                                
                            }) {
                                // 버튼 스타일
                                Text("한국어")
                                    .foregroundColor(Color.white)
                                    .font(.system(size: 20))
                                Image(systemName: "chevron.down")
                                    .imageScale(.small)
                            }
                            .frame(width: 75)
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 40)
                        .foregroundColor(Color.white)
                        .background(Color(red: 0.2549019607843137, green: 0.4117647058823529, blue: 0.8823529411764706))
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .cornerRadius(8)
                        .shadow(radius: 4)
                    }
                    
                    VStack(alignment: .center) {
                        // 카메라 꺼짐 아이콘
                        Image(systemName: "video.slash.fill")
                                .resizable() // 크기 조정 활성화
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 66)
                                .foregroundColor(.white)
                                .padding(.bottom, 2)
                        
                        // 상태 메시지
                        Text("카메라가 꺼져있습니다.")
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                            .multilineTextAlignment(.center) // 텍스트 정렬
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: geometry.size.height / 1.7)
                    .background(Color.black)
                    .cornerRadius(8)
                    .shadow(radius: 2) // 그림자 추가로 시각적 효과

                    // 안내 문구 영역
                    VStack {
                        Text("카메라가 켜지면 해당 기능이 활성화됩니다.")
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                    }
                    .frame(maxWidth: .infinity, maxHeight: geometry.size.height / 6)
                    .background(Color(red: 0.8509803921568627, green: 0.8509803921568627, blue: 0.8509803921568627))
                    .cornerRadius(8)
                    .shadow(radius: 2)
                }
                .padding(10)
            }
        }
    }
}

#Preview {
    MainView(showMenuView: .constant(false))
}
