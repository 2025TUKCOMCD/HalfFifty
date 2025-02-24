//
//  FAQView.swift
//  HalfFifty_FE
//
//  Created by 김민지 on 2/7/25.
//

import SwiftUI

struct FAQView: View {
    @StateObject private var viewModel = FAQViewModel()
    @State private var selectedQuestion: UUID? = nil
    
    var body: some View {
        VStack {
            if viewModel.faqs.isEmpty {
                Spacer()
                Text("FAQ가 없습니다.")
                    .foregroundColor(.gray)
                Spacer()
            } else {
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(viewModel.faqs, id: \..faqId) { faq in
                            FAQItemView(
                                question: faq.question,
                                answer: faq.answer,
                                isExpanded: selectedQuestion == faq.faqId
                            )
                            .onTapGesture {
                                withAnimation {
                                    selectedQuestion = selectedQuestion == faq.faqId ? nil : faq.faqId
                                }
                            }
                        }
                    }
                }
                .padding()
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
        .background(Color(UIColor.systemGray6))
        .navigationTitle("FAQ")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetchFAQ()
        }
    }
}

struct FAQItemView: View {
    let question: String
    let answer: String
    let isExpanded: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("\(question)")
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

class FAQViewModel: ObservableObject {
    @Published var faqs: [FAQ] = []
    @Published var isLoading = false
    
    func fetchFAQ() {
        guard let url = URL(string: "http://54.180.92.32/FAQ") else { return }
        
        isLoading = true
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    print("FAQ 불러오기 오류: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    let decodedResponse = try JSONDecoder().decode(FAQResponse.self, from: data)
                    if decodedResponse.success {
                        self.faqs = decodedResponse.FAQList
                    } else {
                        print("FAQ 불러오기 실패: \(decodedResponse.message)")
                    }
                } catch {
                    print("디코딩 오류: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
}

struct FAQResponse: Codable {
    let success: Bool
    let message: String
    let FAQList: [FAQ]
}

struct FAQ: Codable, Identifiable {
    let faqId: UUID
    let question: String
    let answer: String
    
    var id: UUID { faqId }
}

#Preview {
    FAQView()
}
