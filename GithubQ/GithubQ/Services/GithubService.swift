//
//  GithubService.swift
//  GithubQ
//
//  Created by Tony Hadisiswanto on 16/11/20.
//  Copyright © 2020 inotnesia. All rights reserved.
//

import Foundation

class GithubService: GithubServiceProtocol {
    static let shared = GithubService()
    private init() {}
    let baseAPIURL = "https://api.github.com"
    private let _urlSession = URLSession.shared
    
    private let _jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }()
    
    func fetchUsers(params: [String: String]?, successHandler: @escaping (_ response: UserResponse) -> Void, errorHandler: @escaping (_ error: Error) -> Void) {
        guard var urlComponents = URLComponents(string: "\(baseAPIURL)/search/users") else {
            errorHandler(GithubError.invalidEndpoint)
            return
        }
        
        var queryItems: [URLQueryItem] = []
        if let params = params {
            queryItems.append(contentsOf: params.map { URLQueryItem(name: $0.key, value: $0.value) })
        }
        urlComponents.queryItems = queryItems
        
        guard let endpoint = urlComponents.url else {
            errorHandler(GithubError.invalidEndpoint)
            return
        }
        
        _urlSession.dataTask(with: endpoint) { (data, response, error) in
            if error != nil {
                self._handleError(errorHandler: errorHandler, error: GithubError.apiError)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                self._handleError(errorHandler: errorHandler, error: GithubError.invalidResponse)
                return
            }
            
            guard let data = data else {
                self._handleError(errorHandler: errorHandler, error: GithubError.noData)
                return
            }
            
            do {
                let userResponse = try self._jsonDecoder.decode(UserResponse.self, from: data)
                DispatchQueue.main.async {
                    successHandler(userResponse)
                }
            } catch {
                self._handleError(errorHandler: errorHandler, error: GithubError.serializationError)
            }
        }.resume()
    }
    
    private func _handleError(errorHandler: @escaping(_ error: Error) -> Void, error: Error) {
        DispatchQueue.main.async {
            errorHandler(error)
        }
    }
}
