//
//  KeywordView.swift
//  HalfFifty_Watch Watch App
//
//  Created by 임정윤 on 1/17/25.
//

import SwiftUI

struct Keyword: Identifiable, Codable {
    let keywordId: UUID
    let keyword: String
    
    var id: UUID { keywordId }
}

struct KeywordResponse: Codable {
    let success: Bool
    let message: String
    let keywordList: [Keyword]
}

struct DeleteKeywordResponse: Codable {
    let success: Bool
    let message: String
}
struct KeywordView: View {
    @State private var userId = "9f373112-8e93-4444-a403-a986f8bea4a3"
    @State private var keywords: [Keyword] = []
    @State private var isLoading = false
    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading...")
            } else {
                List {
                    ForEach(keywords) { keyword in
                        Text(keyword.keyword)
                            .font(.title3)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    deleteKeyword(keywordId: keyword.keywordId)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                                .tint(.red)
                            }
                    }
                    
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
        .navigationTitle("키워드 관리")
    }
    
    private func fetchKeywords() {
        guard let url = URL(string: "http://54.180.92.32/keyword/user/\(userId)") else { return }
        
        isLoading = true
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
                
                if let error = error {
                    print("Error fetching keywords: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    let decodedResponse = try JSONDecoder().decode(KeywordResponse.self, from: data)
                    if decodedResponse.success {
                        self.keywords = decodedResponse.keywordList
                    } else {
                        print("Failed to fetch keywords: \(decodedResponse.message)")
                    }
                } catch {
                    print("Decoding error: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    private func deleteKeyword(keywordId: UUID) {
        guard let url = URL(string: "http://54.180.92.32/keyword") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "keywordId": keywordId.uuidString,
            "userId": userId
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error deleting keyword: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    let decodedResponse = try JSONDecoder().decode(DeleteKeywordResponse.self, from: data)
                    if decodedResponse.success {
                        self.keywords.removeAll { $0.keywordId == keywordId }
                    } else {
                        print("Failed to delete keyword: \(decodedResponse.message)")
                    }
                } catch {
                    print("Decoding error: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    }
}

struct KeywordView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            KeywordView()
        }
    }
}
