//
//  ChipView.swift
//  HalfFifty_FE
//
//  Created by 김민지 on 4/29/25.
//

import SwiftUI

public struct ChipsView: View {
    private var title: String

    public init(title: String) {
        self.title = title
    }

    public var body: some View {
        Text(title)
            .font(.caption)
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 3)
            .background(Color(red: 0.2549019607843137, green: 0.4117647058823529, blue: 0.8823529411764706))
            .cornerRadius(16)
            .frame(height: 24)
            .fixedSize()
    }
}
