//
//  TutorialView.swift
//  HalfFifty_FE
//
//  Created by 임정윤 on 2/18/25.
//

import SwiftUI

struct TutorialView: View {
    private let images = ["tutorial-1", "tutorial-2"]
    @State private var currentIndex = 0
    @Binding var showTutorialView: Bool

    var body: some View {
        NavigationStack {
            VStack {
                GeometryReader { geometry in
                    ZStack {
                        Color(red: 89/255, green: 89/255, blue: 89/255)
                            .edgesIgnoringSafeArea(.all)

                        Image(images[currentIndex])
                            .resizable()
                            .scaledToFit()
                            .animation(.easeInOut, value: currentIndex)

                        HStack {
                            Button(action: {
                                if currentIndex > 0 {
                                    currentIndex -= 1
                                }
                            }) {
                                Image(systemName: "chevron.left")
                                    .font(.largeTitle)
                                    .foregroundColor(currentIndex > 0 ? .white : Color.white.opacity(0))
                                    .padding(.leading, 16)
                            }
                            .disabled(currentIndex == 0)
                            
                            Spacer()
                            
                            Button(action: {
                                if currentIndex < images.count - 1 {
                                    currentIndex += 1
                                }
                            }) {
                                Image(systemName: "chevron.right")
                                    .font(.largeTitle)
                                    .foregroundColor(currentIndex < images.count - 1 ? .white : Color.white.opacity(0))
                                    .padding(.trailing, 16)
                            }
                            .disabled(currentIndex == images.count - 1)
                        }
                    }
                }

                HStack {
                    Spacer()
                    HStack(spacing: 8) {
                        ForEach(0..<images.count, id: \.self) { index in
                            Circle()
                                .fill(index == currentIndex ? Color.white : Color.gray.opacity(0.5))
                                .frame(width: 8, height: 8)
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 20)
            }
            .navigationTitle("사용 방법")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if showTutorialView {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            showTutorialView = false
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.black)
                        }
                    }
                }
            }
            .toolbarBackground(Color.white, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .background(Color(red: 89/255, green: 89/255, blue: 89/255))
    }
}

#Preview {
    TutorialView(showTutorialView: .constant(true))
}
