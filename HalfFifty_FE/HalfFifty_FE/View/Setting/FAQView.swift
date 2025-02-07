//
//  FAQView.swift
//  HalfFifty_FE
//
//  Created by 김민지 on 2/7/25.
//

import SwiftUI

struct FAQView: View {
    @State private var selectedQuestion: Int? = nil
    let faqs: [(question: String, answer: String)] = [
        ("카메라로 얼굴을 인식하면 도용 관련 문제는 없나요?", "얼굴 인식 기술은 매우 편리하지만, 도용에 대한 걱정이 있을 수 있습니다.\n이를 방지하기 위해 저희는 사진이나 영상으로 인증이 되지 않도록 3D 얼굴 인식이나 센도 카메라 같은 안전한 기술을 사용하고 있습니다. 또한 얼굴 인식 외에도 비밀번호나 OTP 같은 추가 인증 방식을 적용해 보안을 더욱 강화하고 있습니다.\n고객님의 정보는 법적으로 안전하게 보호되며, 안심하고 서비스를 이용하실 수 있도록 최선을 다하고 있습니다."),
        ("카메라로 얼굴을 인식하면 도용 관련 문제는 없나요? 질문이 길어지면 어떡하죠?", "얼굴 인식 기술은 매우 편리하지만, 도용에 대한 걱정이 있을 수 있습니다.\n이를 방지하기 위해 저희는 사진이나 영상으로 인증이 되지 않도록 3D 얼굴 인식이나 센도 카메라 같은 안전한 기술을 사용하고 있습니다.")
    ]
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(faqs.indices, id: \.self) { index in
                        FAQItemView(
                            question: faqs[index].question,
                            answer: faqs[index].answer,
                            isExpanded: selectedQuestion == index
                        )
                        .onTapGesture {
                            withAnimation {
                                selectedQuestion = selectedQuestion == index ? nil : index
                            }
                        }
                    }
                }
                .padding()
            }
            
            Spacer()
            
            Button(action: {
                // 질문하기 버튼 동작 추가 가능
            }) {
                Text("질문하기")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 0.2549019607843137, green: 0.4117647058823529, blue: 0.8823529411764706))
                    .cornerRadius(8)
                    .padding(.horizontal, 16)
            }
            .padding(.bottom, 10)
        }
        .background(Color(UIColor.systemGray6))
        .navigationTitle("FAQ")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FAQItemView: View {
    let question: String
    let answer: String
    let isExpanded: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Q. \(question)")
                    .font(.system(size: 16, weight: .bold))
                
                Spacer()
                
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .foregroundColor(.gray)
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            
            if isExpanded {
                Text(answer)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
            }
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.gray.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    FAQView()
}
