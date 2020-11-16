//
//  CategoryView.swift
//  MovieQ
//
//  Created by Tony Hadisiswanto on 05/07/20.
//  Copyright © 2020 inotnesia. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

// MARK: - Protocols
protocol CategoryViewProtocol: AnyObject {
    func didSelectCategory(index: Int)
}

class CategoryView: UIView, NibLoadableView, Modal {
    // MARK: - Outlets
    var view: UIView?
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var smallBgView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables
    weak var delegate: CategoryViewProtocol?
    var obsCategories: BehaviorRelay<[SortItem]>?
    
    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Functions
    func setupView(_ categories: BehaviorRelay<[SortItem]>) {
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTappedOnBackgroundView)))
        self.obsCategories = categories
        setupTableView()
    }
    
    func setupTableView() {
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = 44
        tableView.backgroundColor = .white
        tableView.register(UINib(nibName: String(describing: CategoryTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: CategoryTableViewCell.self))
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc func didTappedOnBackgroundView() {
        handleSmallBgViewAndDismiss()
    }
    
    private func handleSmallBgViewAndDismiss() {
        UIView.animate(withDuration: 0.33, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 10, options: UIView.AnimationOptions(rawValue: 0), animations: {
            self.smallBgView.center = CGPoint(x: self.center.x, y: self.frame.height + self.smallBgView.frame.height/2)
        }, completion: { _ in
            self.removeFromSuperview()
        })
        dismiss(animated: true)
    }
}

extension CategoryView: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return obsCategories?.value.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: CategoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: String(describing: CategoryTableViewCell.self)) as? CategoryTableViewCell else { return UITableViewCell() }
        if let category = obsCategories?.value[indexPath.row] {
            cell.setupView(category)
        }
        return cell
    }
}

extension CategoryView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if var categories = obsCategories?.value {
            for (index, category) in categories.enumerated() where category.isSelected {
                categories[index].isSelected = false
            }
            categories[indexPath.row].isSelected = true
            obsCategories?.accept(categories)
            tableView.reloadData()
            
            delegate?.didSelectCategory(index: indexPath.row)
            handleSmallBgViewAndDismiss()
        }
    }
}
