//
//  SearchPresenter.swift
//  Project: GithubQ
//
//  Module: Search
//
//  Created by Tony Hadisiswanto on 15/11/20.
//  Copyright © 2020 inotnesia. All rights reserved.
//

// MARK: Imports
import UIKit
import SwiftyVIPER

// MARK: Protocols
protocol SearchViewPresenterProtocol: ViewPresenterProtocol {
    // Search View to Presenter Protocol
    
}

protocol SearchInteractorPresenterProtocol: class {
    // Search Interactor to Presenter Protocol
    func set(title: String?)
}

// MARK: -

/// The Presenter for the Search module
final class SearchPresenter {
    
    // MARK: - Constants
    let router: SearchPresenterRouterProtocol
    let interactor: SearchPresenterInteractorProtocol
    
    // MARK: Variables
    weak var view: SearchPresenterViewProtocol?
    
    // MARK: Inits
    init(router: SearchPresenterRouterProtocol, interactor: SearchPresenterInteractorProtocol) {
        self.router = router
        self.interactor = interactor
    }
    
    func viewLoaded() {
        interactor.requestTitle()
    }
}

extension SearchPresenter: SearchInteractorPresenterProtocol {
    
    // MARK: - Search Interactor to Presenter Protocol
    func set(title: String?) {
        view?.set(title: title)
    }
}

extension SearchPresenter: SearchViewPresenterProtocol {
    
    // MARK: - Search View to Presenter Protocol
}
