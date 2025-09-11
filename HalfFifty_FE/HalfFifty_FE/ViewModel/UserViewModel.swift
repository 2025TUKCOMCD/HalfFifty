//
//  UserViewModel.swift
//  HalfFifty_FE
//
//  Created by 김민지 on 2/5/25.
//

import SwiftUI

struct LoginResponse: Codable {
    let success: Bool
    let message: String
    let userId: String?
}

class UserViewModel: ObservableObject {
    @Published var userId: String = ""
    @Published var nickname: String = ""
    @Published var phoneNumber: String = ""
    @Published var createdAt: String = ""
    @Published var updateMessage: String = ""
    @Published var loginMessage: String = ""

    private let baseURL = "http://3.34.3.103/"
    
    var baseUrl: String { baseURL }

    func login(appleId: String, password: String, completion: @escaping (Bool) -> Void) {
        var components = URLComponents(string: "\(baseURL)user/login")
        components?.queryItems = [
            URLQueryItem(name: "appleId", value: appleId),
            URLQueryItem(name: "password", value: password)
        ]

        guard let url = components?.url else {
            DispatchQueue.main.async {
                self.loginMessage = "요청 URL 생성 실패"
                completion(false)
            }
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.loginMessage = "네트워크 에러: \(error.localizedDescription)"
                    completion(false)
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    self.loginMessage = "응답 데이터가 없습니다."
                    completion(false)
                }
                return
            }

            do {
                let decoded = try JSONDecoder().decode(LoginResponse.self, from: data)
                DispatchQueue.main.async {
                    self.loginMessage = decoded.message
                    if decoded.success, let id = decoded.userId {
                        self.userId = id
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.loginMessage = "디코딩 에러: \(error.localizedDescription)"
                    completion(false)
                }
            }
        }.resume()
    }
    
    struct UserInfo: Codable {
        let userId: String
        let nickname: String
        let phoneNumber: String
        let createdAt: String
    }

    struct UserResponse: Codable {
        let success: Bool
        let message: String?
        let userInfo: UserInfo?
    }

    func fetchUser(userId: String) {
        guard let url = URL(string: "\(baseURL)user/\(userId)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("fetchUser 네트워크 에러: \(error.localizedDescription)")
                return
            }
            if let http = response as? HTTPURLResponse {
                print("fetchUser HTTP \(http.statusCode)")
            }
            guard let data = data else {
                print("fetchUser 응답 데이터 없음")
                return
            }
            do {
                let decoded = try JSONDecoder().decode(UserResponse.self, from: data)
                DispatchQueue.main.async {
                    if decoded.success, let info = decoded.userInfo {
                        self.userId = info.userId
                        self.nickname = info.nickname
                        self.phoneNumber = info.phoneNumber
                        self.createdAt = self.formatDate(info.createdAt)
                    } else {
                        self.updateMessage = "사용자 조회 실패: \(decoded.message ?? "알 수 없는 오류")"
                        print("fetchUser 실패: \(decoded.message ?? "no message")")
                    }
                }
            } catch {
                let raw = String(data: data, encoding: .utf8) ?? ""
                print("fetchUser 디코딩 실패: \(error)\nRAW=\(raw)")
            }
        }.resume()
    }
    
//    닉네임 업데이트 (PUT 요청)
        func updateNickname(userId: String, newNickname: String) {
            guard let url = URL(string: "\(baseURL)user") else { return }
            
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let requestBody: [String: Any] = [
                "userId": userId,
                "nickname": newNickname
            ]

            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
            } catch {
                print("JSON 변환 에러: \(error.localizedDescription)")
                return
            }

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("네트워크 에러 발생: \(error.localizedDescription)")
                    return
                }

                guard let data = data else { return }

                do {
                    let decodedResponse = try JSONDecoder().decode(NicknameUpdateResponse.self, from: data)
                    DispatchQueue.main.async {
                        if decodedResponse.success {
                            self.nickname = newNickname // 성공하면 닉네임 업데이트
                            self.updateMessage = decodedResponse.message
                        } else {
                            self.updateMessage = "닉네임 변경 실패: \(decodedResponse.message)"
                        }
                    }
                } catch {
                    print("JSON 디코딩 에러: \(error.localizedDescription)")
                }
            }.resume()
        }
    
    /// 서버 날짜 문자열을 "yyyy.MM.dd" 로 변환
    private func formatDate(_ dateString: String) -> String {
        // 출력 포맷터 (KST 표시)
        let output = DateFormatter()
        output.dateFormat = "yyyy.MM.dd"
        output.locale = Locale(identifier: "ko_KR")
        output.timeZone = TimeZone(identifier: "Asia/Seoul") ?? .current

        let iso = ISO8601DateFormatter()
        iso.formatOptions = [.withInternetDateTime, .withFractionalSeconds] // 소수점 포함 허용
        if let d = iso.date(from: dateString) {
            return output.string(from: d)
        }
        
        let input = DateFormatter()
        input.locale = Locale(identifier: "en_US_POSIX")
        input.timeZone = TimeZone(secondsFromGMT: 0)

        let candidates = [
            "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSSS", // 나노초(최대 9자리)
            "yyyy-MM-dd'T'HH:mm:ss.SSSSSS",    // 마이크로초(6자리)
            "yyyy-MM-dd'T'HH:mm:ss.SSS",       // 밀리초(3자리)
            "yyyy-MM-dd'T'HH:mm:ss"            // 소수점 없음
        ]

        for fmt in candidates {
            input.dateFormat = fmt
            if let d = input.date(from: dateString) {
                return output.string(from: d)
            }
        }

        // 3) 최후: 소수점 이하 잘라내고 재시도 (예외 문자열 대비)
        if let dot = dateString.firstIndex(of: "."),
           let tEnd = dateString.firstIndex(of: "T") {
            // "yyyy-MM-ddTHH:mm:ss"까지만 남김
            let base = String(dateString[..<dot])
            // 혹시 초 뒤에 다른 문자가 붙어 있으면 정리
            let secEnd = base.index(tEnd, offsetBy: 9, limitedBy: base.endIndex) ?? base.endIndex
            let trimmed = String(base[..<secEnd])
            input.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            if let d = input.date(from: trimmed) {
                return output.string(from: d)
            }
        }

        return "날짜 변환 오류"
    }

}
