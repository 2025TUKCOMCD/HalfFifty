//
//  KeywordView.swift
//  HalfFifty_Watch Watch App
//
//  Created by 임정윤 on 1/17/25.
//

import SwiftUI

struct KeywordView: View {
    @State private var keywords = ["김민지", "김먼지", "김망디", "김망디령이", "김민지"]

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(keywords, id: \.self) { keyword in
                        Text(keyword)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    deleteKeyword(keyword: keyword)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                                .tint(.red)
                            }
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("키워드 관리")
        }
    }

    private func deleteKeyword(keyword: String) {
        keywords.removeAll { $0 == keyword }
    }
}

struct KeywordView_Previews: PreviewProvider {
    static var previews: some View {
        KeywordView()
    }
}
