//
//  UserViewModel.swift
//  HalfFifty_FE
//
//  Created by 김민지 on 2/5/25.
//

import SwiftUI

class UserViewModel: ObservableObject {
    @Published var nickname: String = ""
    @Published var phoneNumber: String = ""
    @Published var createdAt: String = ""
    
    private let baseURL = "http://54.180.92.32"

    func fetchUser(userId: String) {
        guard let url = URL(string: "\(baseURL)/user/\(userId)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("네트워크 에러 발생: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else { return }
            
            do {
                let decodedResponse = try JSONDecoder().decode(UserResponse.self, from: data)
                DispatchQueue.main.async {
                    if decodedResponse.success, let userInfo = decodedResponse.userInfo {
                        self.nickname = userInfo.nickname
                        self.phoneNumber = userInfo.phoneNumber
                        self.createdAt = self.formatDate(userInfo.createdAt) // 날짜 변환
                    }
                }
            } catch {
                print("JSON 디코딩 에러: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    ///  서버 날짜 형식 (`2025-01-24T22:03:02.567423`) → "YYYY.MM.DD" 변환
    private func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS" // 마이크로초 포함
        formatter.locale = Locale(identifier: "ko_KR") // 한국어 로케일
        formatter.timeZone = TimeZone(abbreviation: "UTC") // 서버가 UTC 기반이라면 설정
        
        if let date = formatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "yyyy.MM.dd" // 원하는 출력 형식
            outputFormatter.locale = Locale(identifier: "ko_KR")
            return outputFormatter.string(from: date)
        }

        return "날짜 변환 오류"
    }
}
