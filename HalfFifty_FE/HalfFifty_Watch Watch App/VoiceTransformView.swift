//
//  HalfFifty_WatchApp.swift
//  HalfFifty_Watch Watch App
//
//  Created by 임정윤 on 1/16/25.
//
import SwiftUI

struct VoiceTransformView: View {
    @State private var isRecording = false

    var body: some View {
        VStack(spacing: 8) {
            VStack {
                HStack {
                    Text(isRecording ? "녹음 중..." : "음성 버튼을 눌러주세요.")
                        .foregroundColor(.gray)
                        .font(.body)
                        .padding()
                    Spacer()
                }
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.3))
            .cornerRadius(10)
            
            Button(action: {
                isRecording.toggle()
            }) {
                ZStack {
                    Circle()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.white)
                    Image(systemName: isRecording ? "waveform" : "mic.fill")
                        .foregroundColor(.blue)
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding()
        .navigationTitle("음성변환")
    }
}

struct VoiceTransformView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            VoiceTransformView()
        }
    }
}
