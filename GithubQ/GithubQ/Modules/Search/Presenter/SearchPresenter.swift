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
import RxCocoa

// MARK: Protocols
protocol SearchViewPresenterProtocol: ViewPresenterProtocol {
    // Search View to Presenter Protocol
    func getObsUserResponse() -> BehaviorRelay<UserResponse?>
    func getFetchingState() -> Driver<Bool>
    func getErrorState() -> Bool
    func getErrorInfo() -> Driver<String?>
    func search(keyword: String, page: Int)
}

protocol SearchInteractorPresenterProtocol: class {
    // Search Interactor to Presenter Protocol
    func set(title: String?)
    func performUpdates(animated: Bool)
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
    
    func performUpdates(animated: Bool) {
        view?.performUpdates(animated: animated)
    }
}

extension SearchPresenter: SearchViewPresenterProtocol {
    
    // MARK: - Search View to Presenter Protocol
    func getObsUserResponse() -> BehaviorRelay<UserResponse?> {
        return interactor.getObsUserResponse()
    }
    
    func getFetchingState() -> Driver<Bool> {
        return interactor.getFetchingState()
    }
    
    func getErrorState() -> Bool {
        return interactor.getErrorState()
    }
    
    func getErrorInfo() -> Driver<String?> {
        return interactor.getErrorInfo()
    }
    
    func search(keyword: String, page: Int) {
        interactor.fetchUsers(keyword: keyword, page: page)
    }
}
