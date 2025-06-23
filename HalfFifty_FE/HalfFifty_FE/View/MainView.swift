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
    @State private var text: String = "" // 번역할 문장
    @State var useMicrophone: Bool = false // 음성 입력 사용 여부
    @State private var cameraFrame: CGRect = .zero // 카메라 크기 저장
    @State private var translationResultList: [String] = [] // 번역 결과 리스트

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
                            Text("수어")
                                .font(.system(size: 20))
                                .frame(width: 75)

                            Spacer()

                            Image(systemName: "arrow.right")
                                .padding(.horizontal, 19)
                                .padding(.vertical, 6)
                                .background(Color.white)
                                .foregroundColor(Color(red: 0.2549019607843137, green: 0.4117647058823529, blue: 0.8823529411764706))
                                .cornerRadius(18)

                            Spacer()

                            Text("한국어")
                                .font(.system(size: 20))
                                .frame(width: 75)
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
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 66)
                                        .foregroundColor(.white)
                                        .padding(.bottom, 2)

                                    // 상태 메시지
                                    if(!self.useCamera && !self.onCamera) {
                                        Text("카메라 권한이 없습니다.")
                                            .foregroundColor(.white)
                                            .font(.system(size: 16))
                                            .multilineTextAlignment(.center)
                                    } else if(!self.onCamera) {
                                        Text("카메라가 꺼져있습니다.")
                                            .foregroundColor(.white)
                                            .font(.system(size: 16))
                                            .multilineTextAlignment(.center)
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
                                Spacer()

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
                                .padding(.bottom, 20)
                            }
                        }
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: geometry.size.height / 1.7)
                    .background(Color.black)
                    .cornerRadius(8)
                    .shadow(radius: 2)

                    if (!self.useCamera || !self.onCamera) {
                        VStack {
                            Text("카메라가 켜지면 해당 기능이 활성화됩니다.")
                                .foregroundColor(.white)
                                .font(.system(size: 16))
                        }
                        .frame(maxWidth: .infinity, maxHeight: geometry.size.height / 6)
                        .background(Color(red: 0.8509803921568627, green: 0.8509803921568627, blue: 0.8509803921568627))
                        .cornerRadius(8)
                        .shadow(radius: 2)
                    } else {
                        ChipsTranslationResultView(
                            items: $translationResultList
                        )
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: 150)
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 2)
                    }
                }
                .padding(10)
                .background(.white)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("TranslationResult"))) { notification in
            if let translatedWord = notification.userInfo?["translatedWord"] as? String {
                // 같은 단어 필터링
                if self.translationResultList.last != translatedWord {
                    self.translationResultList.append(translatedWord)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
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
