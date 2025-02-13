//
//  KeywordAddView.swift
//  HalfFifty_FE
//
//  Created by 임정윤 on 2/12/25.
//

import SwiftUI

struct UpdateKeywordResponse: Codable {
    let success: Bool
    let message: String
    let keywordId: UUID?
}

struct KeywordAddView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var tempKeyword: String
    @State private var isLoading = false
    @State private var userId = "9f373112-8e93-4444-a403-a986f8bea4a3"
    
    var keywordId: UUID?

    init(keyword: String = "", keywordId: UUID? = nil) {
        _tempKeyword = State(initialValue: keyword)
        self.keywordId = keywordId
    }

    private var isSaveButtonEnabled: Bool {
        !tempKeyword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                TextField("키워드를 입력하세요", text: $tempKeyword)
                    .padding(12)
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color.white))
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.never)
                
                Text("특정 키워드가 주변에서 들리면 알림을 보냅니다.\n키워드를 입력해주세요.")
                    .foregroundColor(.gray)
                    .font(.footnote)
                    .frame(alignment: .leading)
                    .padding(.leading, 12)
                    .padding(.top, 4)
            }
            .padding(.horizontal)
            .padding(.top, 20)

            if isLoading {
                ProgressView("저장 중...")
                    .padding()
            }

            Spacer()
        }
        .background(Color(UIColor.systemGray6))
        .navigationTitle("키워드 설정")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    if let keywordId = keywordId {
                        updateKeyword(keywordId: keywordId)
                    } else {
                        addKeyword()
                    }
                }) {
                    Text("저장")
                        .foregroundColor(isSaveButtonEnabled ? .blue : .gray)
                }
                .disabled(!isSaveButtonEnabled || isLoading)
            }
        }
    }

    private func addKeyword() {
        guard let url = URL(string: "http://54.180.92.32/keyword"), !tempKeyword.isEmpty else { return }
        
        isLoading = true
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "userId": userId,
            "keyword": tempKeyword
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    print("Error updating keyword: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    let decodedResponse = try JSONDecoder().decode(UpdateKeywordResponse.self, from: data)
                    if decodedResponse.success {
                        print("키워드 수정 성공: \(decodedResponse.keywordId?.uuidString ?? "")")
                        self.dismiss()
                    } else {
                        print("키워드 수정 실패: \(decodedResponse.message)")
                    }
                } catch {
                    print("Decoding error: \(error.localizedDescription)")
                }
            }
        }.resume()

    }

    private func updateKeyword(keywordId: UUID) {
        guard let url = URL(string: "http://54.180.92.32/keyword"), !tempKeyword.isEmpty else { return }
        
        isLoading = true
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "keywordId": keywordId.uuidString,
            "userId": userId,
            "keyword": tempKeyword
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
                
                if let error = error {
                    print("Error updating keyword: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    let decodedResponse = try JSONDecoder().decode(UpdateKeywordResponse.self, from: data)
                    if decodedResponse.success {
                        print("키워드 수정 성공: \(decodedResponse.keywordId?.uuidString ?? "")")
                        dismiss()
                    } else {
                        print("키워드 수정 실패: \(decodedResponse.message)")
                    }
                } catch {
                    print("Decoding error: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
}

#Preview {
    NavigationStack {
        KeywordAddView()
    }
}
