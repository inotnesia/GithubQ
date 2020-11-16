//
//  NibLoadable.swift
//  MovieQ
//
//  Created by Tony Hadisiswanto on 05/07/20.
//  Copyright © 2020 inotnesia. All rights reserved.
//

import UIKit

protocol NibLoadableView: AnyObject {
    var nibName: String { get }
    var view: UIView? { get set }
}

extension NibLoadableView where Self: UIView {
    
    var nibName: String { return String(describing: self.classForCoder) }
    
    func loadNib() {
        guard view == nil else { return }
        view = UINib(nibName: nibName, bundle: nil)
            .instantiate(withOwner: self, options: nil).first as? UIView
        view?.bounds = bounds
        view?.translatesAutoresizingMaskIntoConstraints = false
        view?.constrainEdges(to: self)
    }
}
