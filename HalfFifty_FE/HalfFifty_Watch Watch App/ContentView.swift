//
//  ContentView.swift
//  HalfFifty_Watch Watch App
//
//  Created by 임정윤 on 1/14/25.
//

import SwiftUI

struct ContentView: View {
    @State private var inputText: String = ""
    @ObservedObject private var notificationManager = WatchNotificationManager.shared
    private let recorder = AudioRecorderManager.shared  // 녹음 관리 객체 추가

    var body: some View {
        NavigationView {
            VStack(spacing: 5) {
                TextFieldLink(prompt: Text("음성을 녹음해주세요")) {
                    HStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 32, height: 32)
                            Image(systemName: "mic.fill")
                                .foregroundColor(.blue)
                        }
                        Text("음성변환")
                            .font(.headline)
                            .foregroundColor(.primary)
                        Spacer()
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray).opacity(0.3))
                } onSubmit: { newText in
                    inputText = newText
                }
                .buttonStyle(PlainButtonStyle())

                NavigationLink(destination: KeywordView()) {
                    HStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(Color.blue)
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

                // 변환된 텍스트 표시
                Text("STT 결과: \(notificationManager.receivedSTTResult)")
                    .foregroundColor(.blue)
                    .padding()
            }
            .padding()
            .navigationTitle("手다쟁이")
            .onAppear {
                recorder.startRecordingLoop()  // 앱 실행 시 자동으로 녹음 시작
            }
        }
    }
}
