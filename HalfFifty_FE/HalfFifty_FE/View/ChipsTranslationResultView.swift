//
//  ChipsTranslationResultView.swift
//  HalfFifty_FE
//
//  Created by 김민지 on 4/29/25.
//

import SwiftUI

public struct ChipsTranslationResultView: View {
    let items: [String]
    let horizontalSpacing: CGFloat
    let verticalSpacing: CGFloat

    public init(
        items: [String],
        horizontalSpacing: CGFloat = 8,
        verticalSpacing: CGFloat = 8
    ) {
        self.items = items
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
    }

    public var body: some View {
        GeometryReader { geometry in
            FlexibleView(
                availableWidth: geometry.size.width,
                data: items,
                spacing: horizontalSpacing
            ) { item in
                ChipsView(title: item)
            }
        }
    }
}
