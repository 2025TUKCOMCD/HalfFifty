//
//  CustomerCenterView.swift
//  HalfFifty_FE
//
//  Created by 김민지 on 2/9/25.
//

import SwiftUI

struct CustomerCenterView: View {
    @StateObject private var viewModel = AQViewModel()
    @State private var selectedQuestionID: UUID? = nil
    
    var body: some View {
        VStack {
            if viewModel.aqs.isEmpty {
                Spacer()
                Text("질문이 존재하지 않습니다")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                Spacer()
            } else {
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(viewModel.aqs) { aq in
                            QuestionRow(
                                question: aq,
                                isExpanded: selectedQuestionID == aq.aqId
                            )
                            .onTapGesture {
                                withAnimation {
                                    selectedQuestionID = selectedQuestionID == aq.aqId ? nil : aq.aqId
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
                    .background(Color.blue)
                    .cornerRadius(8)
                    .padding(.horizontal, 16)
            }
            .padding(.bottom, 10)
        }
        .padding(.top, 16)
        .navigationTitle("고객센터")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(UIColor.systemGray6))
        .onAppear {
            viewModel.fetchAQ(userId: "1f273112-8e93-4444-a403-a986f8bea4a2")
        }
    }
}

struct QuestionRow: View {
    let question: AQ
    let isExpanded: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(question.isAnswer ? "답변완료" : "답변예정")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                
                Text(" | \(formattedDate(question.questionCreatedAt))")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                
                Spacer()
                
                if question.isAnswer {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)
                }
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

class AQViewModel: ObservableObject {
    @Published var aqs: [AQ] = []
    @Published var isLoading = false
    
    func fetchAQ(userId: String) {
        guard let url = URL(string: "http://54.180.92.32/AQ/user/\(userId)") else { return }
        
        isLoading = true
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    print("AQ 불러오기 오류: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    let decodedResponse = try JSONDecoder().decode(AQResponse.self, from: data)
                    if decodedResponse.success {
                        self.aqs = decodedResponse.AQList
                    } else {
                        print("AQ 불러오기 실패: \(decodedResponse.message)")
                    }
                } catch {
                    print("디코딩 오류: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
}

struct AQResponse: Codable {
    let success: Bool
    let message: String
    let AQList: [AQ]
}

struct AQ: Codable, Identifiable {
    let aqId: UUID
    let question: String
    let answer: String?
    let questionCreatedAt: String
    let answerCreatedAt: String?
    let isAnswer: Bool
    
    var id: UUID { aqId }
}

func formattedDate(_ dateString: String) -> String {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
    inputFormatter.locale = Locale(identifier: "ko_KR")
    inputFormatter.timeZone = TimeZone(abbreviation: "KST")
    
    if let date = inputFormatter.date(from: dateString) {
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy.MM.dd"
        return outputFormatter.string(from: date)
    }
    return "날짜 오류"
}

#Preview {
    CustomerCenterView()
}
