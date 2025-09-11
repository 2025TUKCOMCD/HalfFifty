//  CSView.swift
//  HalfFifty_FE
//
//  Created by 김민지 on 2/7/25.
//

import SwiftUI

struct InquiryView: View {
    @EnvironmentObject var userVM: UserViewModel
    @StateObject private var viewModel = AQViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var questionText: String = ""
    @State private var isSubmitting = false
    @State private var showErrorAlert = false
    @State private var errorMessage = ""

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
                        Group {
                            if questionText.isEmpty {
                                Text("내용을 작성해주세요")
                                    .foregroundColor(.gray)
                                    .padding(15)
                                    .allowsHitTesting(false)
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
            Button(action: submit) {
                Text(isSubmitting ? "등록 중..." : "질문하기")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isButtonEnabled ? Color(red: 0.2549, green: 0.4118, blue: 0.8824) : Color.gray.opacity(0.5))
                    .cornerRadius(8)
            }
            .disabled(!isButtonEnabled)
            .padding(.bottom, 20)
        }
        .padding(.horizontal, 16)
        .background(Color(UIColor.systemGray6))
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .navigationTitle("질문하기")
        .navigationBarTitleDisplayMode(.inline)
        .alert("알림", isPresented: $showErrorAlert) {
            Button("확인", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }

    private var isButtonEnabled: Bool {
        !questionText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        && !userVM.userId.isEmpty
        && !isSubmitting
    }

    private func submit() {
        let trimmed = questionText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        guard !userVM.userId.isEmpty else {
            errorMessage = "로그인이 필요합니다."
            showErrorAlert = true
            return
        }

        isSubmitting = true
        viewModel.saveAQ(userId: userVM.userId,
                         question: trimmed,
                         baseUrl: userVM.baseUrl) { success in
            isSubmitting = false
            if success {
                dismiss()
            } else {
                errorMessage = "질문 등록에 실패했습니다. 잠시 후 다시 시도해주세요."
                showErrorAlert = true
            }
        }
    }
}

struct CreateAQResponse: Codable {
    let success: Bool
    let message: String
    let aqId: UUID?
}

extension AQViewModel {
    func saveAQ(userId: String,
                question: String,
                baseUrl: String,
                completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(baseUrl)AQ") else {
            completion(false)
            return
        }

        let requestData: [String: Any] = [
            "userId": userId,
            "question": question
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestData) else {
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("질문 등록 오류: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                if let http = response as? HTTPURLResponse,
                   !(200...299).contains(http.statusCode) {
                    completion(false)
                    return
                }
                guard let data = data else {
                    print("응답 데이터 없음")
                    completion(false)
                    return
                }
                do {
                    // 등록용 응답 모델로 디코딩 (예: CreateAQResponse)
                    struct CreateAQResponse: Codable {
                        let success: Bool
                        let message: String
                        let aqId: UUID?
                    }
                    let decoded = try JSONDecoder().decode(CreateAQResponse.self, from: data)
                    if decoded.success {
                        completion(true)
                    } else {
                        completion(false)
                    }
                } catch {
                    completion(false)
                }
            }
        }.resume()
    }
}


#Preview {
    NavigationStack {
        InquiryView()
            .environmentObject({
                let vm = UserViewModel()
                vm.userId = "5cbd5b33-833f-430a-97f3-96706b12ce7" // 미리보기용
                return vm
            }())
    }
}
