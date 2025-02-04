//
//  STTManager.swift
//  HalfFifty_FE
//
//  Created by 임정윤 on 2/4/25.
//

import Foundation
import AVFoundation
import Speech
import WatchConnectivity

class STTManager: NSObject, WCSessionDelegate, ObservableObject {
    static let shared = STTManager()
    
    @Published var transcribedText: String = ""

    override init() {
        super.init()
        requestSpeechRecognitionPermission()

        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }

    // 음성 인식 권한 요청
    private func requestSpeechRecognitionPermission() {
        SFSpeechRecognizer.requestAuthorization { status in
            switch status {
            case .authorized:
                print("음성 인식 권한 허용됨")
            case .denied:
                print("음성 인식 권한 거부됨")
            default:
                print("음성 인식을 사용할 수 없음")
            }
        }
    }

    // Apple Watch에서 오디오 파일을 수신하면 호출
    func session(_ session: WCSession, didReceive file: WCSessionFile) {
        let fileURL = file.fileURL
        print("📂 Apple Watch에서 오디오 파일 수신: \(fileURL)")
        transcribeAudio(url: fileURL)
    }

    // STT 변환
    private func transcribeAudio(url: URL) {
        let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "ko-KR"))
        let request = SFSpeechURLRecognitionRequest(url: url)

        recognizer?.recognitionTask(with: request) { result, error in
            guard let result = result else {
                print("STT 변환 오류: \(error?.localizedDescription ?? "알 수 없는 오류")")
                return
            }

            if result.isFinal {
                DispatchQueue.main.async {
                    self.transcribedText = result.bestTranscription.formattedString
                    print("변환된 텍스트: \(self.transcribedText)")

                    // Apple Watch로 STT 변환 결과 전송
                    self.sendTranscribedTextToWatch()
                }
            }
        }
    }

    // 변환된 텍스트를 Apple Watch로 전송
    private func sendTranscribedTextToWatch() {
        guard WCSession.default.isReachable else { return }
        
        let message: [String: Any] = ["sttResult": transcribedText]
        WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: { error in
            print("Apple Watch로 STT 결과 전송 실패: \(error.localizedDescription)")
        })
    }

    // iPhone과 Apple Watch 간 세션이 활성화되었을 때 호출
    func session(_ session: WCSession, activationDidCompleteWith state: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession 활성화 실패: \(error.localizedDescription)")
        } else {
            print("WCSession 활성화 완료")
        }
    }

    // iPhone이 Apple Watch와 페어링을 해제했을 때 호출
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("WCSession 비활성화됨")
    }

    // 새로운 Apple Watch가 페어링되었을 때 호출
    func sessionDidDeactivate(_ session: WCSession) {
        WCSession.default.activate() // 다시 세션 활성화
    }
}
