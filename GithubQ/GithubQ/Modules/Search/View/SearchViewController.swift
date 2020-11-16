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
import RxCocoa
import RxSwift

// MARK: Protocols
protocol SearchPresenterViewProtocol: class {
    // Search Presenter to View Protocol
    func set(title: String?)
    func performUpdates(animated: Bool)
}

// MARK: -

/// The View Controller for the Search module
class SearchViewController: UIViewController {
    
    // MARK: - Constants
    let presenter: SearchViewPresenterProtocol
    private let _disposeBag = DisposeBag()
    
    // MARK: Variables
    private let _searchBlockDelay: TimeInterval = 0.5
    private var _page = 1
    private var _obsUserResponse: BehaviorRelay<UserResponse?>?
    private var _obsSortOption: BehaviorRelay<[SortItem]>?
    
    // MARK: Outlets
    var searchBar = UISearchBar(frame: .zero)
    var tableView = UITableView(frame: .zero, style: .plain)
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    lazy var infoLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 32, height: 40))
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.center = view.center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
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
        
        _obsUserResponse = presenter.getObsUserResponse()
        _obsSortOption = presenter.getObsSortOption()
        
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
            make.left.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.bottom.equalTo(tableView.snp.top)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-8)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(searchBar.snp.bottom)
            make.left.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.right.equalTo(view.safeAreaLayoutGuide)
        }
        
        view.addSubview(activityIndicator)
        view.addSubview(infoLabel)
        
        view.setNeedsUpdateConstraints()
        
        _setupSearchBar()
        _setupTableView()
        _setupActivityIndicator()
        _setupInfoLabel()
        _setupSortButton()
    }
    
    private func _setupSearchBar() {
        searchBar.searchBarStyle = .minimal
        searchBar.sizeToFit()
        searchBar.delegate = self
    }
    
    private func _setupTableView() {
        tableView.backgroundColor = .white
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.keyboardDismissMode = .onDrag
        tableView.estimatedRowHeight = 46
        tableView.register(UINib(nibName: "ImageTitleTableViewCell", bundle: nil), forCellReuseIdentifier: "ImageTitleTableViewCell")
        tableView.register(UINib(nibName: "TitleHeaderFooterView", bundle: nil), forHeaderFooterViewReuseIdentifier: "TitleHeaderFooterView")
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
    }
    
    private func _setupActivityIndicator() {
        presenter.getFetchingState().drive(activityIndicator.rx.isAnimating).disposed(by: _disposeBag)
    }
    
    private func _setupInfoLabel() {
        presenter.getErrorInfo().drive(onNext: {[unowned self] (error) in
            self.infoLabel.isHidden = !self.presenter.getErrorState()
            self.infoLabel.text = error
        }).disposed(by: _disposeBag)
    }
    
    private func _setupSortButton() {
        let button = UIBarButtonItem(image: UIImage(named: "filter"), style: .plain, target: self, action: #selector(_sortButtonTapped(sender:)))
        navigationItem.setRightBarButton(button, animated: true)
    }
    
    private func _isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row + 1 >= _obsUserResponse?.value?.items.count ?? 0
    }
    
    // MARK: Outlet Action
    @objc private func _sortButtonTapped(sender: UIBarButtonItem) {
        let categoryView = CategoryView(frame: UIScreen.main.bounds)
        if let option = _obsSortOption {
            categoryView.setupView(option)
        }
        
        categoryView.delegate = self
        categoryView.show(animated: true, alpha: 0.66)
    }
}

extension SearchViewController: SearchPresenterViewProtocol {
    
    // MARK: - Search Presenter to View Protocol
    func set(title: String?) {
        self.title = title
    }
    
    func performUpdates(animated: Bool) {
        tableView.reloadData()
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.setNewKeyword(_:)), object: searchBar)
        self.perform(#selector(self.setNewKeyword(_:)), with: searchBar, afterDelay: _searchBlockDelay)
    }
    
    @objc func setNewKeyword(_ searchBar: UISearchBar) {
        _page = 1
        presenter.search(keyword: searchBar.text ?? "", page: _page)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _obsUserResponse?.value?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ImageTitleTableViewCell.self)) as? ImageTitleTableViewCell else { return UITableViewCell() }
        if !_isLoadingCell(for: indexPath) {
            let user = _obsUserResponse?.value?.items[indexPath.row]
            cell.setupView(imageUrl: user?.avatarUrl, text: user?.login)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return searchBar.text?.isEmpty ?? true ? 0 : 22
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TitleHeaderFooterView") as? TitleHeaderFooterView else { return nil }
        headerView.titleLabel.text = searchBar.text?.isEmpty ?? true ? "" : "Total results \(_obsUserResponse?.value?.totalCount ?? 0)"
        return headerView
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: _isLoadingCell) && !activityIndicator.isAnimating {
            _page += 1
            presenter.search(keyword: searchBar.text ?? "", page: _page)
        }
    }
}

extension SearchViewController: CategoryViewProtocol {
    
    // MARK: - CategoryViewProtocol
    func didSelectCategory(index: Int) {
        presenter.setSort(index: index)
    }
}
