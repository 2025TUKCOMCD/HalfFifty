//
//  ContentView.swift
//  HalfFifty_Watch Watch App
//
//  Created by 임정윤 on 1/14/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Spacer()
                Text("手다쟁이")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
            }
            
            VStack(spacing: 5) {
                Button(action: {
                    print("음성변환 버튼 클릭됨")
                }) {
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
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray).opacity(0.5))
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    print("키워드 관리 버튼 클릭됨")
                }) {
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
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray).opacity(0.5))
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
