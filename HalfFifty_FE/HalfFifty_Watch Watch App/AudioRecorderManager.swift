//
//  AudioRecorderManager.swift
//  HalfFifty_FE
//
//  Created by 임정윤 on 2/4/25.
//

import AVFoundation
import WatchConnectivity

class AudioRecorderManager: NSObject, ObservableObject {
    static let shared = AudioRecorderManager()
    private var audioRecorder: AVAudioRecorder?
    private var recordingSession: AVAudioSession!
    private let fileName = "recordedAudio.m4a"
    private var timer: Timer?

    @Published var transcribedText: String = "" // 변환된 텍스트 저장

    override init() {
        super.init()
        setupAudioSession()
    }

    func setupAudioSession() {
        recordingSession = AVAudioSession.sharedInstance()
        try? recordingSession.setCategory(.record, mode: .default, options: .allowBluetooth)
        try? recordingSession.setActive(true)
    }

    func startRecordingLoop() {
        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
            self.startRecording()
        }
    }

    func stopRecordingLoop() {
        timer?.invalidate()
        timer = nil
        stopRecording()
    }

    private func startRecording() {
        let audioFilename = getFileURL()
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record(forDuration: 10)
        } catch {
            print("녹음 시작 실패: \(error.localizedDescription)")
        }
    }

    private func stopRecording() {
        audioRecorder?.stop()
    }

    private func getFileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent(fileName)
    }

    private func sendAudioFileToiPhone() {
        guard WCSession.default.isReachable else { return }
        
        let fileURL = getFileURL()
        WCSession.default.transferFile(fileURL, metadata: nil)
    }
}

extension AudioRecorderManager: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            sendAudioFileToiPhone()
        }
    }
}
