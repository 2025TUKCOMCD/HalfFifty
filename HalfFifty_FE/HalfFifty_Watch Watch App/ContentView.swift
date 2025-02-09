//
//  ContentView.swift
//  HalfFifty_Watch Watch App
//
//  Created by 임정윤 on 1/14/25.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    @State private var inputText: String = ""
    @ObservedObject private var notificationManager = WatchNotificationManager.shared
    private let recorder = AudioRecorderManager.shared
    @State private var keywords: [Keyword] = []

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
                    checkForMatchingKeywords(text: newText) // 키워드와 매칭 확인
                }
                .buttonStyle(PlainButtonStyle())

                NavigationLink(destination: KeywordView(keywords: $keywords)) {
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
                recorder.startRecordingLoop()
                fetchKeywords()
            }
        }
    }
    
    private func fetchKeywords() {
        guard let url = URL(string: "http://54.180.92.32/keyword/user/9f373112-8e93-4444-a403-a986f8bea4a3") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error fetching keywords: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    let decodedResponse = try JSONDecoder().decode(KeywordResponse.self, from: data)
                    if decodedResponse.success {
                        self.keywords = decodedResponse.keywordList
                    } else {
                        print("Failed to fetch keywords: \(decodedResponse.message)")
                    }
                } catch {
                    print("Decoding error: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    private func checkForMatchingKeywords(text: String) {
        for keyword in keywords {
            if text.contains(keyword.keyword) {
                sendAlert(for: keyword.keyword)
                break
            }
        }
    }

    private func sendAlert(for keyword: String) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "키워드 감지"
        notificationContent.body = "감지된 키워드: \(keyword)"
        notificationContent.sound = .default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: notificationContent, trigger: nil)
        UNUserNotificationCenter.current().add(request)
    }
}
