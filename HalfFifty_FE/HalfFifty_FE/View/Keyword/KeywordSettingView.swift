//
//  KeywordSettingsView.swift
//  HalfFifty_FE
//
//  Created by 임정윤 on 2/12/25.
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

struct KeywordSettingsView: View {
    @State private var userId = "9f373112-8e93-4444-a403-a986f8bea4a3"
    @State private var keywords: [Keyword] = []
    @State private var searchText = ""
    @State private var isLoading = false
    @State private var isEditing = false

    var filteredKeywords: [Keyword] {
        if searchText.isEmpty {
            return keywords
        } else {
            return keywords.filter { $0.keyword.contains(searchText) }
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                SearchBar(text: $searchText)
                    .padding(.top, 16)

                if isLoading {
                    ProgressView("Loading...")
                } else {
                    List {
                        ForEach(filteredKeywords) { keyword in
                            HStack {
                                Text(keyword.keyword)
                                Spacer()
                            }
                            .contextMenu {
                                NavigationLink(destination: KeywordAddView(keyword: keyword.keyword, keywordId: keyword.keywordId)) {
                                    Label("편집", systemImage: "pencil")
                                }
                                Button(role: .destructive) {
                                    deleteKeyword(keywordId: keyword.keywordId)
                                } label: {
                                    Label("삭제", systemImage: "trash")
                                }
                            }
                            .swipeActions(edge: .trailing) {
                                Button("삭제") {
                                    deleteKeyword(keywordId: keyword.keywordId)
                                }
                                .tint(.red)

                                NavigationLink(destination: KeywordAddView(keyword: keyword.keyword, keywordId: keyword.keywordId)) {
                                    Text("편집")
                                }
                                .tint(.gray)
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .background(Color.white)
            .navigationTitle("키워드 설정")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem {
                    NavigationLink(destination: KeywordAddView()) {
                        Image(systemName: "plus")
                    }
                }
            }
            .onAppear {
                fetchKeywords()
            }
            .onDisappear {
                fetchKeywords()
            }
        }
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

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            TextField("", text: $text)
                .padding(7)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        if text.isEmpty {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .padding(.leading, 8)
                        }
                        Spacer()
                    }
                )
            
            if !text.isEmpty {
                Button("취소") {
                    text = ""
                }
                .foregroundColor(.blue)
            }
        }
        .padding(.horizontal)
    }
}

struct KeywordSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        KeywordSettingsView()
    }
}
