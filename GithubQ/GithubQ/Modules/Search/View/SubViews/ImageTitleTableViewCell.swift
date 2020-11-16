//
//  ImageTitleTableViewCell.swift
//  GithubQ
//
//  Created by Tony Hadisiswanto on 16/11/20.
//  Copyright © 2020 inotnesia. All rights reserved.
//

import UIKit
import Kingfisher

class ImageTitleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func setupView(imageUrl: String?, text: String?) {
        titleLabel.text = text
        if let imageUrlString = imageUrl, !imageUrlString.isEmpty, let url = URL(string: imageUrlString) {
            avatarImageView.kf.setImage(with: url, placeholder: UIImage(named: "avatar"), options: [.transition(.fade(0.2))], progressBlock: nil) { (result) in
                switch result {
                case .success(let value):
                    self.avatarImageView.image = value.image
                case .failure( _):
                    self.avatarImageView.image = UIImage(named: "avatar")
                }
            }
        }
    }
}
