//
//  CategoryTableViewCell.swift
//  MovieQ
//
//  Created by Tony Hadisiswanto on 05/07/20.
//  Copyright © 2020 inotnesia. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectedImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupView(_ category: SortItem) {
        titleLabel.text = category.title
        selectedImageView.image = #imageLiteral(resourceName: "ok").withRenderingMode(.alwaysTemplate)
        selectedImageView.tintColor = .gray
        selectedImageView.isHidden = !category.isSelected
    }
}
