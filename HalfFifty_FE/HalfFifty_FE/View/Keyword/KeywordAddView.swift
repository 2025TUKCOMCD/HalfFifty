//
//  KeywordAddView.swift
//  HalfFifty_FE
//
//  Created by 임정윤 on 2/12/25.
//

import SwiftUI

struct KeywordAddView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var tempKeyword: String

    init(keyword: String = "") {
        _tempKeyword = State(initialValue: keyword)
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
            }
            .padding(.horizontal)
            .padding(.top, 20)

            Spacer()
        }
        .background(Color(UIColor.systemGray6))
        .navigationTitle("키워드 설정")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    saveKeyword()
                    dismiss()
                }) {
                    Text("저장")
                        .foregroundColor(isSaveButtonEnabled ? .blue : .gray)
                }
                .disabled(!isSaveButtonEnabled)
            }
        }
    }

    private func saveKeyword() {
        print("저장된 키워드: \(tempKeyword)")
    }
}

#Preview {
    NavigationStack {
        KeywordAddView()
    }
}
