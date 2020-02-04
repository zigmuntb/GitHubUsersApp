//
//  UserCollectionViewCell.swift
//  GitHubUsers
//
//  Created by Arsenkin Bogdan on 02.02.2020.
//  Copyright © 2020 Arsenkin Bogdan. All rights reserved.
//

import UIKit

class UserCollectionViewCell: UICollectionViewCell, ClassNaming {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
    }

    func fill(with model: UserModel) {
        nameLabel.text = model.login
        ImageLoader.loadImage(with: .grayLarge, urlString: model.avatar_url, imageView: imageView, completion: nil)
    }
    
    private func setupUI() {
        imageView.image = UIImage()
        nameLabel.text = String()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        setupUI()
    }
}
