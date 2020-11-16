//
//  Extension+UIView.swift
//  GithubQ
//
//  Created by Tony Hadisiswanto on 16/11/20.
//  Copyright © 2020 inotnesia. All rights reserved.
//

import UIKit
import SnapKit

extension UIView {
    
    public func constrainEdges(to parent: UIView) {
        if superview == nil { parent.addSubview(self) }
        self.snp.makeConstraints { (make) in
            make.top.equalTo(parent)
            make.left.equalTo(parent)
            make.bottom.equalTo(parent)
            make.right.equalTo(parent)
        }
    }
}
