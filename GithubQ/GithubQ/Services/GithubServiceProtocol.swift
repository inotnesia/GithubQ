//
//  GithubServiceProtocol.swift
//  GithubQ
//
//  Created by Tony Hadisiswanto on 16/11/20.
//  Copyright © 2020 inotnesia. All rights reserved.
//

import Foundation

protocol GithubServiceProtocol {
    func fetchUsers(params: [String: String]?, successHandler: @escaping (_ response: UserResponse) -> Void, errorHandler: @escaping (_ error: Error) -> Void)
}

enum GithubError: Error {
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case serializationError
}
