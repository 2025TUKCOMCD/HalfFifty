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
        GeometryReader { geometry in
            VStack(spacing: 8) {
                HStack {
                    Spacer()
                    Text("음성변환")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                }
                .frame(maxWidth: .infinity)
                
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
                .frame(maxWidth: .infinity, minHeight: geometry.size.height * 0.75)
                .background(Color.gray.opacity(0.3))
                .cornerRadius(10)
                
                Button(action: {
                    isRecording.toggle()
                }) {
                    ZStack {
                        Circle()
                            .frame(width: geometry.size.height * 0.16, height: geometry.size.height * 0.16)
                            .foregroundColor(.white)
                        Image(systemName: isRecording ? "waveform" : "mic.fill")
                            .foregroundColor(.blue)
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .foregroundColor(.white)
        }
    }
}

struct VoiceTransformView_Previews: PreviewProvider {
    static var previews: some View {
        VoiceTransformView()
    }
}
