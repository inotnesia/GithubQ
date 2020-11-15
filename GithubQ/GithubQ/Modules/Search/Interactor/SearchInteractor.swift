//
//  SearchInteractor.swift
//  Project: GithubQ
//
//  Module: Search
//
//  Created by Tony Hadisiswanto on 15/11/20.
//  Copyright © 2020 inotnesia. All rights reserved.
//

// MARK: Imports
import Foundation
import SwiftyVIPER

// MARK: Protocols
protocol SearchPresenterInteractorProtocol {
    // Search Presenter to Interactor Protocol
    func requestTitle()
}

// MARK: -

/// The Interactor for the Search module
final class SearchInteractor {
    
    // MARK: - Variables
    weak var presenter: SearchInteractorPresenterProtocol?
}

extension SearchInteractor: SearchPresenterInteractorProtocol {
    
    // MARK: - Search Presenter to Interactor Protocol
    func requestTitle() {
        presenter?.set(title: "Github User CTCD")
    }
}
