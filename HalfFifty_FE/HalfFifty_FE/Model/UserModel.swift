//
//  UserInfo.swift
//  HalfFifty_FE
//
//  Created by 김민지 on 2/5/25.
//

import Foundation

struct UserInfo: Codable {
    let userId: String
    let nickname: String
    let phoneNumber: String
    let createdAt: String
}

struct UserResponse: Codable {
    let success: Bool
    let message: String
    let userInfo: UserInfo?
}
