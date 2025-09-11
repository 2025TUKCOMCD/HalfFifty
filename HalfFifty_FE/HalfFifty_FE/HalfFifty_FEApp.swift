//
//  HalfFifty_FEApp.swift
//  HalfFifty_FE
//
//  Created by 김민지 on 1/6/25.
//

import SwiftUI
import UserNotifications

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}

@main
struct HalfFifty_FEApp: App {
    @StateObject private var fontSizeManager = FontSizeManager()
    @StateObject private var speechManager = SpeechRecognizerManager()
    @StateObject private var userVM = UserViewModel()

    let notificationDelegate = NotificationDelegate()

    init() {
        UNUserNotificationCenter.current().delegate = notificationDelegate
    }

    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .environmentObject(speechManager)
                    .environmentObject(userVM)
            }
            .environmentObject(fontSizeManager)
            .onAppear {
                requestNotificationPermission()
                speechManager.startRecording()
                speechManager.fetchKeywords()
            }
        }
    }

    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("알림 권한 허용됨")
            } else {
                print("알림 권한 거부됨")
            }

            if let error = error {
                print("알림 권한 요청 에러: \(error.localizedDescription)")
            }
        }
    }
}
