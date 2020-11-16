//
//  TitleHeaderFooterView.swift
//  GithubQ
//
//  Created by Tony Hadisiswanto on 16/11/20.
//  Copyright © 2020 inotnesia. All rights reserved.
//

import UIKit

class TitleHeaderFooterView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textColor = .lightGray
    }

}
