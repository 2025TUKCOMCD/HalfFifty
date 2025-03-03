//
//  CSView.swift
//  HalfFifty_FE
//
//  Created by 김민지 on 2/7/25.
//

import SwiftUI

struct InquiryView: View {
    @State private var questionText: String = ""
    @StateObject private var viewModel = AQViewModel()
    @Environment(\.presentationMode) var presentationMode // 화면 닫기용
    
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
                viewModel.saveAQ(userId: "9f373112-8e93-4444-a403-a986f8bea4a3", question: questionText) {
                    presentationMode.wrappedValue.dismiss() // 성공 시 화면 닫기
                }
            }) {
                Text("질문하기")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(questionText.isEmpty ? Color.gray.opacity(0.5) : Color.blue)
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

extension AQViewModel {
    func saveAQ(userId: String, question: String, completion: @escaping () -> Void) {
        guard let url = URL(string: "http://54.180.92.32/AQ") else { return }
        
        let requestData: [String: Any] = [
            "userId": userId,
            "question": question
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestData) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("질문 등록 오류: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    let decodedResponse = try JSONDecoder().decode(AQResponse.self, from: data)
                    if decodedResponse.success {
                        print("질문 등록 성공: \(decodedResponse.message)")
                        completion() // 성공 시 화면 닫기
                    } else {
                        print("질문 등록 실패: \(decodedResponse.message)")
                    }
                } catch {
                    print("디코딩 오류: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
}

#Preview {
    InquiryView()
}
