//
//  KeywordSettingsView.swift
//  HalfFifty_FE
//
//  Created by 임정윤 on 2/12/25.
//

import SwiftUI

struct KeywordSettingsView: View {
    @State private var keywords = ["김민지", "김망디", "김망디렁이"]
    @State private var searchText = ""
    @State private var selectedKeyword: String?

    var filteredKeywords: [String] {
        if searchText.isEmpty {
            return keywords
        } else {
            return keywords.filter { $0.contains(searchText) }
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                SearchBar(text: $searchText)
                    .padding(.top, 16)

                List {
                    ForEach(filteredKeywords, id: \.self) { keyword in
                        HStack {
                            Text(keyword)
                            Spacer()
                        }
                        .swipeActions(edge: .trailing) {
                            Button("삭제") {
                                if let index = keywords.firstIndex(of: keyword) {
                                    keywords.remove(at: index)
                                }
                            }
                            .tint(.red)

                            NavigationLink(destination: KeywordAddView(keyword: keyword)) {
                                Button("편집") {}
                            }
                            .tint(.gray)
                        }
                    }
                }
                .listStyle(PlainListStyle())
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
        }
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
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .padding(.leading, 8)
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
