//
//  CSView.swift
//  HalfFifty_FE
//
//  Created by 김민지 on 2/7/25.
//

import SwiftUI

struct InquiryView: View {
    @State private var questionText: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            // 질문 입력란
            VStack {
                TextEditor(text: $questionText)
                    .frame(height: 200)
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(color: Color.gray.opacity(0.2), radius: 4)
                    .overlay(
                        // 플레이스홀더 텍스트
                        Group {
                            if questionText.isEmpty {
                                Text("내용을 작성해주세요")
                                    .foregroundColor(.gray)
                                    .padding(15)
                                    .allowsHitTesting(false) // 입력 방해 방지
                            }
                        }
                    )
            }
            .padding(.top, 16)
            
            // 안내 문구
            Text("해당 서비스의 궁금한 점에 대해 질문해주세요. 친절하게 답변해드립니다.")
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .padding(.top, 10)
                .padding(.leading, 10)
            
            Spacer()
            
            // 질문하기 버튼
            Button(action: {
                // 질문 제출 기능 추가 가능
            }) {
                Text("질문하기")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(questionText.isEmpty ? Color.gray.opacity(0.5) : Color(red: 0.2549019607843137, green: 0.4117647058823529, blue: 0.8823529411764706))
                    .cornerRadius(8)
            }
            .disabled(questionText.isEmpty)
            .padding(.bottom, 20)
        }
        .padding(.horizontal, 16)
        .background(Color(UIColor.systemGray6))
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .navigationTitle("질문하기")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    InquiryView()
}
