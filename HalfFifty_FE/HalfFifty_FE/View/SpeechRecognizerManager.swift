//
//  SpeechRecognizerManager.swift
//  HalfFifty_FE
//
//  Created by 임정윤 on 6/22/25.
//

import Speech
import AVFoundation
import UserNotifications
import WatchConnectivity

class SpeechRecognizerManager: NSObject, ObservableObject {
    private let audioEngine = AVAudioEngine()
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ko-KR"))
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var isRecording = false
    private var isRetrying = false
    
    @Published var keywords: [Keyword] = []
    @Published var recognizedText = ""

    override init() {
        super.init()
        setupWatchSession()
    }

    func setupWatchSession() {
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }

    func startRecording() {
        print("음성 녹음 중")
        guard !isRecording, !audioEngine.isRunning, !isRetrying else {
            print("녹음 상태 확인 - 이미 녹음 중이거나 대기 중")
            return
        }

        SFSpeechRecognizer.requestAuthorization { status in
            guard status == .authorized else {
                print("STT 권한 거부됨")
                return
            }

            DispatchQueue.main.async {
                do {
                    self.recognitionTask?.cancel()
                    self.recognitionTask = nil
                    
                    let audioSession = AVAudioSession.sharedInstance()
                    try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
                    try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
                    
                    self.request = SFSpeechAudioBufferRecognitionRequest()
                    guard let recognitionRequest = self.request else {
                        print("RecognitionRequest 생성 실패")
                        return
                    }
                    recognitionRequest.shouldReportPartialResults = true
                    
                    let inputNode = self.audioEngine.inputNode
                    inputNode.removeTap(onBus: 0)
                    
                    let recordingFormat = inputNode.outputFormat(forBus: 0)
                    inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
                        recognitionRequest.append(buffer)
                    }
                    
                    self.audioEngine.prepare()
                    try self.audioEngine.start()
                    
                    self.isRecording = true
                    self.isRetrying = false
                    
                    self.recognitionTask = self.speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
                        if let result = result {
                            let text = result.bestTranscription.formattedString
                            DispatchQueue.main.async {
                                self.recognizedText = text
                                print("인식된 텍스트: \(text)")
                                self.checkForKeyword(text: text)
                            }
                        }
                        
                        if let error = error {
                            print("음성 인식 오류: \(error.localizedDescription)")
                            self.stopRecording()
                            self.retryStartRecordingWithDelay()
                        }
                    }
                } catch {
                    print("녹음 시작 실패: \(error.localizedDescription)")
                    self.stopRecording()
                    self.retryStartRecordingWithDelay()
                }
            }
        }
    }

    func stopRecording() {
        if isRecording {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
            recognitionTask?.cancel()
            recognitionTask = nil
            isRecording = false
            
            do {
                try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
            } catch {
                print("AVAudioSession 비활성화 실패: \(error.localizedDescription)")
            }
            print("녹음 중지됨")
        }
    }

    private func retryStartRecordingWithDelay() {
        guard !isRetrying else { return }
        isRetrying = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.isRetrying = false
            self?.startRecording()
        }
    }

    private var keywordDetected = false

    private func checkForKeyword(text: String) {
        if keywordDetected { return }
        
        let textWithoutSpaces = text.replacingOccurrences(of: " ", with: "").lowercased()
        
        for keyword in keywords {
            let keywordWithoutSpaces = keyword.keyword.replacingOccurrences(of: " ", with: "").lowercased()
            
            if textWithoutSpaces.contains(keywordWithoutSpaces) {
                keywordDetected = true
                triggerNotification(message: "키워드 '\(keyword.keyword)'(이)가 탐지되었습니다")
                
                DispatchQueue.main.async {
                    self.recognizedText = ""
                    self.stopRecording()

                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self.startRecording()
                        self.keywordDetected = false
                    }
                }
                break
            }
        }
    }


    func fetchKeywords() {
        guard let url = URL(string: "http://54.180.92.32/keyword/user/9f373112-8e93-4444-a403-a986f8bea4a3") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("키워드 가져오기 실패: \(error.localizedDescription)")
                return
            }

            guard let data = data else { return }

            do {
                let decodedResponse = try JSONDecoder().decode(KeywordResponse.self, from: data)
                DispatchQueue.main.async {
                    if decodedResponse.success {
                        self.keywords = decodedResponse.keywordList
                        print("서버에서 키워드 로드 완료: \(self.keywords)")
                    } else {
                        print("키워드 가져오기 실패: \(decodedResponse.message)")
                    }
                }
            } catch {
                print("키워드 디코딩 오류: \(error.localizedDescription)")
            }
        }.resume()
    }

    private func triggerNotification(message: String) {
        let content = UNMutableNotificationContent()
        content.title = "키워드 알림"
        content.body = message
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )

        UNUserNotificationCenter.current().add(request)

        if let keyword = message.components(separatedBy: "'").dropFirst().first {
            sendKeywordAlertToWatch(keyword: keyword)
        }
    }

    private func sendKeywordAlertToWatch(keyword: String) {
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(["keyword": keyword], replyHandler: nil) { error in
                print("워치 전송 실패: \(error.localizedDescription)")
            }
        } else {
            print("워치 연결 안됨 (WCSession not reachable)")
        }
    }
}

extension SpeechRecognizerManager: WCSessionDelegate {
    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) {
        WCSession.default.activate()
    }
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession 활성화 실패: \(error.localizedDescription)")
        } else {
            print("WCSession 활성화 완료")
        }
    }
}
