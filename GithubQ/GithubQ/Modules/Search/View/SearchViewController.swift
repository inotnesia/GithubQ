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
import SnapKit

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
    private let _searchBlockDelay: TimeInterval = 0.5
    
    // MARK: Outlets
    var searchBar = UISearchBar(frame: .zero)
    var tableView = UITableView(frame: .zero, style: .grouped)
    
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
        _setupView()
    }
    
    // MARK: - Custom Functions
    private func _setupView() {
        view.backgroundColor = .white
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        searchBar.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.bottom.equalTo(tableView.snp.top)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(searchBar.snp.bottom)
            make.left.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.right.equalTo(view.safeAreaLayoutGuide)
        }
        
        view.setNeedsUpdateConstraints()
        
        _setupSearchBar()
        _setupTableView()
    }
    
    private func _setupSearchBar() {
        searchBar.searchBarStyle = .minimal
        searchBar.sizeToFit()
    }
    
    private func _setupTableView() {
        tableView.backgroundColor = .yellow
    }
    
    // MARK: Outlet Action
}

extension SearchViewController: SearchPresenterViewProtocol {
    
    // MARK: - Search Presenter to View Protocol
    func set(title: String?) {
        self.title = title
    }
}
