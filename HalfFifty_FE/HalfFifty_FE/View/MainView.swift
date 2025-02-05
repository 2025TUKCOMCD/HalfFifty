//
//  MainView.swift
//  HalfFifty_FE
//
//  Created by 김민지 on 1/8/25.
//

import SwiftUI
import AVFoundation

struct MainView: View {
    @Binding var showMenuView: Bool // 메뉴 표시 여부
    @State private var useCamera: Bool = false // 카메라 권한 여부
    @State private var onCamera: Bool = false // 카메라 활성화 여부
    @State private var isFrontCamera: Bool = false // 현재 카메라가 전면인지 후면인지 여부, true: 전면, false: 후면
    @State private var changeToSignLanguage: Bool = true // 번역 방향 여부
    @State private var text: String = "" // 번역할 문장
    @State var useMicrophone: Bool = false // 음성 입력 사용 여부
    @State private var cameraFrame: CGRect = .zero // 카메라 크기 저장

    var body: some View {
        GeometryReader { geometry in
            VStack {
                // Header
                ZStack {
                    // 배경과 그림자만 포함
                    Color.white
                        .frame(width: geometry.size.width, height: 56)
                        .overlay(
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.black.opacity(0.1), Color.clear]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .frame(height: 3), // 그림자 영역 높이
                            alignment: .bottom
                        )
                    
                    HStack {
                        // 햄버거 버튼
                        Button(action: {
                            // 버튼 클릭 시
                            withAnimation {
                                self.showMenuView.toggle()
                            }
                        }) {
                            // 버튼 스타일
                            Image(systemName: "line.3.horizontal")
                                .foregroundColor(.black)
                        }
                        
                        Spacer()
                        
                        // 로고
                        Image("text.logo")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 57.0, height: 15.0)
                        
                        Spacer()
                        
                        // 정렬을 위한 빈 투명 영역 추가
                        Color.clear
                            .frame(width: 24, height: 24)
                    }
                    .padding(.horizontal, 20)
                }
                
                // body
                VStack {
                    VStack {
                        HStack(alignment: .center) {
                            if self.changeToSignLanguage {
                                Text("수어")
                                    .font(.system(size: 20))
                                    .frame(width: 75)
                            } else {
                                // 번역어 선택
                                Button(action: {
                                    // 버튼 클릭 시
                                }) {
                                    // 버튼 스타일
                                    Text("한국어")
                                        .foregroundColor(.white)
                                        .font(.system(size: 20))
                                    Image(systemName: "chevron.down")
                                        .imageScale(.small)
                                }
                                .frame(width: 75)
                            }
                            
                            Spacer()
                            
                            // 번역 전환 버튼
                            Button(action: {
                                self.changeToSignLanguage.toggle()
                            }) {
                                // 버튼 스타일
                                Image(systemName: "arrow.left.arrow.right")
                                    .padding(.horizontal, 19)
                                    .padding(.vertical, 6)
                                    .background(Color.white)
                                    .foregroundColor(Color(red: 0.2549019607843137, green: 0.4117647058823529, blue: 0.8823529411764706))
                                    .cornerRadius(18)
                            }
                            
                            Spacer()
                            
                            if self.changeToSignLanguage {
                                // 번역어 선택
                                Button(action: {
                                    // 버튼 클릭 시
                                }) {
                                    // 버튼 스타일
                                    Text("한국어")
                                        .foregroundColor(.white)
                                        .font(.system(size: 20))
                                    Image(systemName: "chevron.down")
                                        .imageScale(.small)
                                }
                                .frame(width: 75)
                            } else {
                                Text("수어")
                                    .font(.system(size: 20))
                                    .frame(width: 75)
                            }
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 40)
                        .foregroundColor(Color.white)
                        .background(Color(red: 0.2549019607843137, green: 0.4117647058823529, blue: 0.8823529411764706))
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .cornerRadius(8)
                        .shadow(radius: 2)
                    }
                    
                    // 카메라 영역
                    if self.changeToSignLanguage {
                        ZStack {
                            if self.useCamera && self.onCamera {
                                CameraView(isFrontCamera: $isFrontCamera, cameraFrame: $cameraFrame)
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: geometry.size.height / 1.7)
                                    .cornerRadius(8)
                                    .shadow(radius: 2)
                                    .background(GeometryReader { proxy in
                                        Color.clear
                                            .onAppear {
                                                cameraFrame = proxy.frame(in: .global) // 초기 크기 저장
                                            }
                                            .onChange(of: proxy.size) { oldSize, newSize in
                                                cameraFrame = proxy.frame(in: .global) // 새로운 크기 업데이트
                                            }
                                    })
                            } else {
                                VStack(alignment: .center) {
                                    Spacer()
                                    
                                    VStack {
                                        // 카메라 꺼짐 아이콘
                                        Image(systemName: "video.slash.fill")
                                            .resizable() // 크기 조정 활성화
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 66)
                                            .foregroundColor(.white)
                                            .padding(.bottom, 2)
                                        
                                        // 상태 메시지
                                        if(!self.useCamera && !self.onCamera) {
                                            Text("카메라 권한이 없습니다.")
                                                .foregroundColor(.white)
                                                .font(.system(size: 16))
                                                .multilineTextAlignment(.center) // 텍스트 정렬
                                        } else if(!self.onCamera) {
                                            Text("카메라가 꺼져있습니다.")
                                                .foregroundColor(.white)
                                                .font(.system(size: 16))
                                                .multilineTextAlignment(.center) // 텍스트 정렬
                                        }
                                    }
                                    .padding(.top, 60)
                                    
                                    Spacer()
                                    
                                    // 카메라 on 버튼
                                    if !useCamera {
                                        Button("설정으로 이동") {
                                            openAppSettings()
                                        }
                                        .padding(.vertical, 13)
                                        .padding(.horizontal, 20)
                                        .background(Color.white)
                                        .foregroundColor(Color.blue)
                                        .cornerRadius(8)
                                        .padding(.bottom, 20)
                                    } else if !self.onCamera {
                                        Button(action: {
                                            self.onCamera = true
                                        }) {
                                            ZStack {
                                                Circle()
                                                    .fill(.white)
                                                    .frame(width: 40, height: 40)
                                                
                                                Image(systemName: "video.fill")
                                                    .foregroundColor(Color(red: 0.2549019607843137, green: 0.4117647058823529, blue: 0.8823529411764706))
                                            }
                                        }
                                        .padding(.bottom, 20)
                                    }
                                }
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: geometry.size.height / 1.7)
                                .background(Color.black)
                                .cornerRadius(8)
                                .shadow(radius: 2)
                            }
                            
                            // 카메라 전환 버튼
                            if self.useCamera && self.onCamera {
                                VStack {
                                    Spacer() // 나머지 공간을 차지하여 버튼을 하단에 배치

                                    Button(action: {
                                        self.isFrontCamera.toggle()
                                    }) {
                                        ZStack {
                                            Circle()
                                                .fill(.white)
                                                .frame(width: 40, height: 40)
                                            
                                            Image(systemName: "repeat")
                                                .foregroundColor(Color(red: 0.2549019607843137, green: 0.4117647058823529, blue: 0.8823529411764706))
                                        }
                                    }
                                    .padding(.bottom, 20) // 버튼과 하단 사이의 간격을 조정
                                }
                            }
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: geometry.size.height / 1.7)
                        .background(Color.black)
                        .cornerRadius(8)
                        .shadow(radius: 2)
                        
                        if(!self.useCamera || !self.onCamera) {
                            // 안내 문구 영역
                            VStack {
                                Text("카메라가 켜지면 해당 기능이 활성화됩니다.")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16))
                            }
                            .frame(maxWidth: .infinity, maxHeight: geometry.size.height / 6)
                            .background(Color(red: 0.8509803921568627, green: 0.8509803921568627, blue: 0.8509803921568627))
                            .cornerRadius(8)
                            .shadow(radius: 2)
                        }
                    } else {
                        // 번역할 내용 입력창
                        VStack(alignment: .center) {
                            TextEditor(text: $text)
                                .foregroundColor(.black)
                                .font(.system(size: 16))
                            
                            // 음성 받아쓰기 사용 버튼
                            Button(action: {
                                // 버튼 클릭 시
                                self.useMicrophone = !self.useMicrophone
                            }) {
                                // 버튼 스타일
                                ZStack {
                                    Circle()
                                        .fill(Color(red: 0.2549019607843137, green: 0.4117647058823529, blue: 0.8823529411764706))
                                        .frame(width: 40, height: 40)
                                    
                                    Image(systemName: self.useMicrophone ? "waveform" : "microphone.fill")                      .foregroundColor(.white)
                                }
                            }
                        }
                        .padding([.top, .leading, .trailing], 20)
                        .padding(.bottom, 10)
                        .frame(maxWidth: .infinity, maxHeight: geometry.size.height / 6)
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 2)
                        
                        // 3D 아바타
                        VStack {
                            
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: geometry.size.height / 1.7)
                        .background(Color.black)
                        .cornerRadius(8)
                        .shadow(radius: 2) // 그림자 추가로 시각적 효과
                    }
                }
                .padding(10)
            }
        }
        .navigationBarBackButtonHidden(true) // 기본 "< Back" 버튼 숨김
        .onAppear {
            checkCameraAuthorizationStatus()
        }
    }
    
    func checkCameraAuthorizationStatus() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            DispatchQueue.main.async { self.useCamera = true }
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async { self.useCamera = granted }
            }
        case .denied, .restricted:
            DispatchQueue.main.async {
                self.useCamera = false
                self.onCamera = false
            }
        @unknown default:
            DispatchQueue.main.async {
                self.useCamera = false
                self.onCamera = false
            }
        }
    }

    // 앱 설정 화면 열기
    func openAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    MainView(showMenuView: .constant(false))
}
