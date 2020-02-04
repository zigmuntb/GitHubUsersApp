//
//  UserInfoViewController.swift
//  GitHubUsers
//
//  Created by Arsenkin Bogdan on 02.02.2020.
//  Copyright © 2020 Arsenkin Bogdan. All rights reserved.
//

import UIKit

class UserInfoViewController: UIViewController {
    
    var userInfo = UserInformation()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var publicReposLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var gitHubButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    
    init(model: UserInformation) {
        super.init(nibName: nil, bundle: nil)
        
        userInfo = model
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        fill(with: userInfo)
    }
    
    @IBAction func gitHubButtonTapped(_ sender: UIButton) {
        guard let url = URL(string: userInfo.html_url) else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func doneBarButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupUI() {
        gitHubButton.layer.cornerRadius = 10
        contentView.layer.cornerRadius = 10
        imageView.layer.cornerRadius = 10
    }
    
    private func fill(with model: UserInformation) {
        ImageLoader.loadImage(with: .grayLarge, urlString: model.avatar_url, imageView: imageView, completion: nil)
        if let name = model.name {
            nameLabel.text = name
        } else {
            nameLabel.text = "No info"
        }
        if let location = model.location {
            locationLabel.text = location
        } else {
            locationLabel.text = "No info"
        }
        if let company = model.company {
            companyLabel.text = company
        } else {
            companyLabel.text = "No info"
        }
        if let bio = model.bio {
            bioLabel.text = bio
        } else {
            bioLabel.text = "No info"
        }
        loginLabel.text = model.login
        publicReposLabel.text = "Public repos: " + "\n" + String(model.public_repos)
        followersLabel.text = "Followers: " + "\n" + String(model.followers)
        followingLabel.text = "Following: " + "\n" + String(model.following)
    }
}
