//
//  ContentView.swift
//  HalfFifty_Watch Watch App
//
//  Created by 임정윤 on 1/14/25.
//

import SwiftUI
import UserNotifications
import WatchConnectivity
import WatchKit

struct ContentView: View {
    @State private var inputText: String = ""
    @StateObject private var wcDelegate = WatchSessionDelegate()
    
    @State private var showAlert = false
    @State private var alertMessage = ""

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
            }
            .padding()
            .navigationTitle("手다쟁이")
            .alert(isPresented: $showAlert) {
                Alert(title: Text("키워드 알림"), message: Text(alertMessage), dismissButton: .default(Text("확인")))
            }
        }
        .onAppear {
            wcDelegate.activateSession()
            wcDelegate.onKeywordReceived = { keyword in
                alertMessage = "'\(keyword)' 키워드가 감지되었습니다"
                showAlert = true
                WKInterfaceDevice.current().play(.notification)
            }
        }
    }
}

class WatchSessionDelegate: NSObject, ObservableObject, WCSessionDelegate {
    var onKeywordReceived: ((String) -> Void)?
    
    func activateSession() {
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession 활성화 실패: \(error.localizedDescription)")
        } else {
            print("WCSession 활성화 성공")
        }
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let keyword = message["keyword"] as? String {
            print("워치에서 키워드 수신: \(keyword)")
            DispatchQueue.main.async {
                self.onKeywordReceived?(keyword)
            }
        }
    }

    func sessionReachabilityDidChange(_ session: WCSession) {
        if session.isReachable {
            print("iPhone과 연결됨 (reachable)")
        } else {
            print("iPhone과 연결 끊김 (not reachable)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
