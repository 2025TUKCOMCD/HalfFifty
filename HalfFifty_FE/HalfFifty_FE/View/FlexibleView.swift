//
//  FlexibleView.swift
//  HalfFifty_FE
//
//  Created by 김민지 on 4/29/25.
//

import SwiftUI

public struct FlexibleView<Data: Collection, Content: View>: View where Data.Element: Hashable {
    let availableWidth: CGFloat
    let data: Data
    let spacing: CGFloat
    let alignment: HorizontalAlignment
    let content: (Data.Element) -> Content

    public init(
        availableWidth: CGFloat,
        data: Data,
        spacing: CGFloat = 8,
        alignment: HorizontalAlignment = .leading,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.availableWidth = availableWidth
        self.data = data
        self.spacing = spacing
        self.alignment = alignment
        self.content = content
    }

    public var body: some View {
        let rows = generateRows()

        return VStack(alignment: alignment, spacing: spacing) {
            ForEach(0..<rows.count, id: \.self) { rowIndex in
                HStack(spacing: spacing) {
                    ForEach(rows[rowIndex], id: \.self) { item in
                        content(item)
                    }
                }
            }
        }
    }

    private func generateRows() -> [[Data.Element]] {
        var rows: [[Data.Element]] = [[]]
        var currentRowWidth: CGFloat = 0

        for item in data {
            let itemWidth = measureItemWidth(item)

            if currentRowWidth + itemWidth + spacing > availableWidth {
                rows.append([item])
                currentRowWidth = itemWidth + spacing
            } else {
                rows[rows.count - 1].append(item)
                currentRowWidth += itemWidth + spacing
            }
        }

        return rows
    }

    private func measureItemWidth(_ item: Data.Element) -> CGFloat {
        let hostingController = UIHostingController(rootView: content(item))
        hostingController.view.layoutIfNeeded()
        let size = hostingController.sizeThatFits(in: UIView.layoutFittingCompressedSize)
        return size.width
    }
}
