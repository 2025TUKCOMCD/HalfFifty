//
//  ContentView.swift
//  HalfFifty_Watch Watch App
//
//  Created by 임정윤 on 1/14/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
                VStack(spacing: 5) {
                    NavigationLink(destination: VoiceTransformView()) {
                        HStack(spacing: 8) {
                            ZStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 32, height: 32)
                                Image(systemName: "mic.fill")
                                    .foregroundColor(Color(red: 0.2549019607843137, green: 0.4117647058823529, blue: 0.8823529411764706))
                            }
                            Text("음성변환")
                                .font(.headline)
                                .foregroundColor(.primary)
                            Spacer()
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray).opacity(0.3))
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    NavigationLink(destination: KeywordView()) {
                        HStack(spacing: 8) {
                            ZStack {
                                Circle()
                                    .fill(Color(red: 0.2549019607843137, green: 0.4117647058823529, blue: 0.8823529411764706))
                                    .frame(width: 32, height: 32)
                                Image(systemName: "tag.fill")
                                    .foregroundColor(.white)
                            }
                            Text("키워드 관리")
                                .font(.headline)
                                .foregroundColor(.primary)
                            Spacer()
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray).opacity(0.3))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            .padding()
            .navigationTitle("手다쟁이")
        }
    }
}

#Preview {
    ContentView()
}
