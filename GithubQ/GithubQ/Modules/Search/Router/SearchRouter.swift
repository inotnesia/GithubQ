//
//  SearchRouter.swift
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
protocol SearchPresenterRouterProtocol: PresenterRouterProtocol {
    // Search Presenter to Router Protocol
    
}

// MARK: -

/// The Router for the Search module
final class SearchRouter: RouterProtocol {
    
    // MARK: - Variables
    weak var viewController: UIViewController?
}

extension SearchRouter: SearchPresenterRouterProtocol {
    
    // MARK: - Search Presenter to Router Protocol
}
