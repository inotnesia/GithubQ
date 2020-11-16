//
//  User.swift
//  GithubQ
//
//  Created by Tony Hadisiswanto on 16/11/20.
//  Copyright © 2020 inotnesia. All rights reserved.
//

import Foundation

struct UserResponse: Codable {
    let totalCount: Int
    let incompleteResults: Bool
    var items: [User]
}

struct User: Codable {
    let id: Int
    let login: String
    let avatarUrl: String
}
