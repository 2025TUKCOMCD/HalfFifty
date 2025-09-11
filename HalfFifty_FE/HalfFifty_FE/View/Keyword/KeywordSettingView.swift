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
    @EnvironmentObject var userVM: UserViewModel

    @State private var keywords: [Keyword] = []
    @State private var searchText = ""
    @State private var isLoading = false
    @State private var isEditing = false

    private var filteredKeywords: [Keyword] {
        searchText.isEmpty ? keywords : keywords.filter { $0.keyword.contains(searchText) }
    }

    var body: some View {
        NavigationStack {
            VStack {
                SearchBar(text: $searchText)
                    .padding(.top, 16)

                if userVM.userId.isEmpty {
                    // 로그인 전 가드
                    Spacer()
                    Text("로그인 후 키워드를 설정할 수 있어요.")
                        .foregroundColor(.gray)
                        .font(.caption)
                    Spacer()
                } else if isLoading {
                    ProgressView("Loading...")
                } else {
                    if keywords.isEmpty {
                        VStack {
                            Spacer()
                            Text("키워드가 존재하지 않습니다.")
                                .foregroundColor(.gray)
                                .font(.caption)
                            Spacer()
                        }
                    } else {
                        List {
                            ForEach(filteredKeywords) { keyword in
                                HStack {
                                    Text(keyword.keyword)
                                    Spacer()
                                }
                                .contextMenu {
                                    NavigationLink(destination: KeywordAddView(keyword: keyword.keyword,
                                                                               keywordId: keyword.keywordId)) {
                                        Label("편집", systemImage: "pencil")
                                    }
                                    Button(role: .destructive) {
                                        deleteKeyword(keywordId: keyword.keywordId)
                                    } label: {
                                        Label("삭제", systemImage: "trash")
                                    }
                                }
                                .swipeActions(edge: .trailing) {
                                    Button("삭제") { deleteKeyword(keywordId: keyword.keywordId) }
                                        .tint(.red)
                                    NavigationLink(destination: KeywordAddView(keyword: keyword.keyword,
                                                                               keywordId: keyword.keywordId)) {
                                        Text("편집")
                                    }
                                    .tint(.gray)
                                }
                            }
                        }
                        .listStyle(.plain)
                    }
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
                    .disabled(userVM.userId.isEmpty)
                }
            }
            .onAppear { fetchKeywords() } // 화면 진입 시도
            .onChange(of: userVM.userId, initial: true) { _, newValue in
                if !newValue.isEmpty { fetchKeywords() }
            }
            // iOS 16 이하 호환 필요하면 위 onChange 대신 아래 사용:
            // .task(id: userVM.userId) { if !userVM.userId.isEmpty { fetchKeywords() } }
        }
    }

    private func fetchKeywords() {
        guard !userVM.userId.isEmpty,
              let url = URL(string: "\(userVM.baseUrl)keyword/user/\(userVM.userId)") else { return }

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
                    let decoded = try JSONDecoder().decode(KeywordResponse.self, from: data)
                    if decoded.success {
                        self.keywords = decoded.keywordList
                    } else {
                        print("Failed to fetch keywords: \(decoded.message)")
                    }
                } catch {
                    print("Decoding error: \(error.localizedDescription)")
                }
            }
        }.resume()
    }

    private func deleteKeyword(keywordId: UUID) {
        guard !userVM.userId.isEmpty,
              let url = URL(string: "\(userVM.baseUrl)keyword") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "keywordId": keywordId.uuidString,
            "userId": userVM.userId
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
                    let decoded = try JSONDecoder().decode(DeleteKeywordResponse.self, from: data)
                    if decoded.success {
                        self.keywords.removeAll { $0.keywordId == keywordId }
                    } else {
                        print("Failed to delete keyword: \(decoded.message)")
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
                Button("취소") { text = "" }
                    .foregroundColor(.blue)
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    NavigationStack {
        KeywordSettingsView()
            .environmentObject({
                let vm = UserViewModel()
                vm.userId = "5cbd5b33-833f-430a-97f3-96706b12ce7" // 미리보기용
                return vm
            }())
    }
}
