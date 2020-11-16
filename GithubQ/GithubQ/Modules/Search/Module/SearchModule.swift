//
//  SearchModule.swift
//  Project: GithubQ
//
//  Module: Search
//
//  Created by Tony Hadisiswanto on 15/11/20.
//  Copyright © 2020 inotnesia. All rights reserved.
//

// MARK: Imports
import SwiftyVIPER
import UIKit

// MARK: -

/// Used to initialize the Search VIPER module
final class SearchModule: ModuleProtocol {
    
    // MARK: - Variables
    private(set) lazy var interactor: SearchInteractor = {
        SearchInteractor()
    }()
    
    private(set) lazy var router: SearchRouter = {
        SearchRouter()
    }()
    
    private(set) lazy var presenter: SearchPresenter = {
        SearchPresenter(router: self.router, interactor: self.interactor)
    }()
    
    private(set) lazy var view: SearchViewController = {
        SearchViewController(presenter: self.presenter)
    }()
    
    // MARK: - Module Protocol Variables
    var viewController: UIViewController {
        return view
    }
    
    // MARK: Inits
    init() {
        presenter.view = view
        router.viewController = view
        interactor.presenter = presenter
    }
}
