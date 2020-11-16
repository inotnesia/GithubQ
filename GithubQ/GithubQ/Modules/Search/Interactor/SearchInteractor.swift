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
import RxCocoa
import RxSwift

// MARK: Protocols
protocol SearchPresenterInteractorProtocol {
    // Search Presenter to Interactor Protocol
    func requestTitle()
    func getObsUserResponse() -> BehaviorRelay<UserResponse?>
    func getFetchingState() -> Driver<Bool>
    func getErrorState() -> Bool
    func getErrorInfo() -> Driver<String?>
    func fetchUsers(keyword: String, page: Int)
}

// MARK: -

/// The Interactor for the Search module
final class SearchInteractor {
    
    // MARK: - Variables
    weak var presenter: SearchInteractorPresenterProtocol?
    
    private let _disposeBag = DisposeBag()
    private let _isFetching = BehaviorRelay<Bool>(value: false)
    private let _error = BehaviorRelay<String?>(value: nil)
    private var _obsUserResponse = BehaviorRelay<UserResponse?>(value: nil)
    
    var isFetching: Driver<Bool> {
        return _isFetching.asDriver()
    }
    
    var error: Driver<String?> {
        return _error.asDriver()
    }
    
    var hasError: Bool {
        return _error.value != nil
    }
    
    init() {
        setupObserver()
    }
    
    func setupObserver() {
        _ = _obsUserResponse.asObservable().subscribe({ (_) in
            self.presenter?.performUpdates(animated: true)
        }).disposed(by: _disposeBag)
    }
}

extension SearchInteractor: SearchPresenterInteractorProtocol {
    
    // MARK: - Search Presenter to Interactor Protocol
    func requestTitle() {
        presenter?.set(title: "Github User CTCD")
    }
    
    func getObsUserResponse() -> BehaviorRelay<UserResponse?> {
        return _obsUserResponse
    }
    
    func getFetchingState() -> Driver<Bool> {
        return isFetching
    }
    
    func getErrorState() -> Bool {
        return hasError
    }
    
    func getErrorInfo() -> Driver<String?> {
        return error
    }
    
    func fetchUsers(keyword: String, page: Int) {
        if !keyword.isEmpty {
            _isFetching.accept(true)
            _error.accept(nil)
            _obsUserResponse.accept(nil)
            
            let params = ["q": "\(keyword)+in:login", "page": "\(page)"]
            
            GithubService.shared.fetchUsers(params: params, successHandler: {[weak self] (response) in
                print(response)
                self?._isFetching.accept(false)
                self?._obsUserResponse.accept(response)
            }) { [weak self] (error) in
                self?._isFetching.accept(false)
                self?._error.accept(error.localizedDescription)
            }
        }
    }
}
