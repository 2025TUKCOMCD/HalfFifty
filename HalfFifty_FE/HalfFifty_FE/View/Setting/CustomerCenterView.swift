//
//  CustomerCenterView.swift
//  HalfFifty_FE
//
//  Created by 김민지 on 2/9/25.
//

import SwiftUI

struct CustomerCenterView: View {
    @State private var questions: [Question] = [
//        Question(id: 1, date: "2025.01.07", status: .answered, question: "카메라로 얼굴을 인식하면 도용 관련 문제는 없나요?", answer: "얼굴 인식 기술은 매우 편리하지만, 도용에 대한 걱정이 있을 수 있습니다.\n이를 방지하기 위해 저희는 사진이나 영상으로는 인증이 되지 않도록 3D 얼굴 인식이나 심도 카메라 같은 안전한 기술을 사용하고 있습니다."),
//        Question(id: 2, date: "2025.01.07", status: .pending, question: "카메라로 얼굴을 인식하면 도용 관련 문제는 없나요?", answer: nil)
    ]
    @State private var selectedQuestionID: Int? = nil
    
    var body: some View {
        VStack {
            if questions.isEmpty {
                Spacer()
                Text("질문이 존재하지 않습니다")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                Spacer()
            } else {
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(questions) { question in
                            QuestionRow(
                                question: question,
                                isExpanded: selectedQuestionID == question.id
                            )
                            .onTapGesture {
                                withAnimation {
                                    selectedQuestionID = selectedQuestionID == question.id ? nil : question.id
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
            Spacer()
            
            NavigationLink(destination: InquiryView()) {
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
        .padding(.top, 16)
        .navigationTitle("고객센터")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(UIColor.systemGray6))
    }
}

struct QuestionRow: View {
    let question: Question
    let isExpanded: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(question.status.rawValue)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                
                Text(" | \(question.date)")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                
                Spacer()
                
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .foregroundColor(.gray)
            }
            
            Text("Q. \(question.question)")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.black)
            
            if isExpanded, let answer = question.answer {
                Text(answer)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .padding(.top, 5)
            }
        }
        .padding(10)
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: Color.gray.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}

struct Question: Identifiable {
    let id: Int
    let date: String
    let status: QuestionStatus
    let question: String
    let answer: String?
}

enum QuestionStatus: String {
    case answered = "답변완료"
    case pending = "답변예정"
}

#Preview {
    CustomerCenterView()
}
