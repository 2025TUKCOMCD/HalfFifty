//
//  WatchNotificationManager.swift
//  HalfFifty_FE
//
//  Created by 임정윤 on 2/4/25.
//

import WatchConnectivity

class WatchNotificationManager: NSObject, WCSessionDelegate, ObservableObject {
    static let shared = WatchNotificationManager()
    @Published var receivedSTTResult: String = ""

    override init() {
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }

    // iPhone에서 전송한 STT 변환 결과를 Apple Watch에서 수신
    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        if let sttResult = message["sttResult"] as? String {
            DispatchQueue.main.async {
                self.receivedSTTResult = sttResult
                print("📩 Apple Watch에서 STT 변환 결과 수신: \(sttResult)")
            }
        }
    }

    // Apple Watch와 iPhone 간 세션이 활성화되었을 때 호출
    func session(_ session: WCSession, activationDidCompleteWith state: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession 활성화 실패: \(error.localizedDescription)")
        } else {
            print("WCSession 활성화 완료")
        }
    }
}
