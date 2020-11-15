//
//  SearchViewController.swift
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
protocol SearchPresenterViewProtocol: class {
    // Search Presenter to View Protocol
    func set(title: String?)
}

// MARK: -

/// The View Controller for the Search module
class SearchViewController: UIViewController {
    
    // MARK: - Constants
    let presenter: SearchViewPresenterProtocol
    
    // MARK: Variables
    
    // MARK: Outlets
    
    // MARK: Inits
    init(presenter: SearchViewPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewLoaded()
        
        view.backgroundColor = .white
    }
    
    // MARK: - Custom Functions
    
    // MARK: Outlet Action
}

extension SearchViewController: SearchPresenterViewProtocol {
    
    // MARK: - Search Presenter to View Protocol
    func set(title: String?) {
        self.title = title
    }
}
