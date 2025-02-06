//
//  FontSizeManager.swift
//  HalfFifty_FE
//
//  Created by 김민지 on 2/6/25.
//

import SwiftUI

class FontSizeManager: ObservableObject {
    @Published var fontSize: CGFloat = 16 {
        didSet {
            UserDefaults.standard.set(fontSize, forKey: "selectedFontSize")
        }
    }
    
    init() {
        if let savedSize = UserDefaults.standard.value(forKey: "selectedFontSize") as? CGFloat {
            self.fontSize = savedSize
        }
    }
}
