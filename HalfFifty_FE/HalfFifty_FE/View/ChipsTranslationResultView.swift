//
//  ChipsTranslationResultView.swift
//  HalfFifty_FE
//
//  Created by 김민지 on 4/29/25.
//

import SwiftUI

public struct ChipsTranslationResultView: View {
    @Binding var items: [String]
    let horizontalSpacing: CGFloat
    let verticalSpacing: CGFloat

    public init(
        items: Binding<[String]>,
        horizontalSpacing: CGFloat = 8,
        verticalSpacing: CGFloat = 8
    ) {
        self._items = items
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
    }

    public var body: some View {
        ZStack(alignment: .topTrailing) {
            GeometryReader { geometry in
                FlexibleView(
                    availableWidth: geometry.size.width,
                    data: items,
                    spacing: horizontalSpacing
                ) { item in
                    ChipsView(title: item)
                }
            }

            // 'X' 버튼
            Button(action: {
                items.removeAll() // 리스트 초기화
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
                    .font(.system(size: 20))
                    .padding(2)
            }
        }
    }
}
