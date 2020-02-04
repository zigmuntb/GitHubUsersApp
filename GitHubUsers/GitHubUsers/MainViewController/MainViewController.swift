//
//  MainViewController.swift
//  GitHubUsers
//
//  Created by Arsenkin Bogdan on 02.02.2020.
//  Copyright © 2020 Arsenkin Bogdan. All rights reserved.
//

import UIKit

enum State {
    case users
    case search
}

class MainViewController: UIViewController {
    
    var requestUsers = NetworkManager<[UserModel]>()
    var requestUserInfo = NetworkManager<UserInformation>()
    var requestSearchResults = NetworkManager<SearchItems>()
    var users = [UserModel]()
    var searchResults = [UserModel]()
    var state: State = .users
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var usersCollectionView: UICollectionView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
        requestUsers(with: Constants.gitHubUrl)
    }
    
    private func initialSetup() {
        navigationController?.setNavigationBarHidden(true, animated: true)
        collectionViewSetup()
        searchBarSetup()
    }
    
    private func requestUsers(with stringUrl: String) {
        guard let url = URL(string: stringUrl) else { return }
        loadingViewAndSpinner(isHidden: false)
        requestUsers.requestData(with: url, fail: { (errorMessage) in
            self.loadingViewAndSpinner(isHidden: true)
            self.showErrorAlert(message: errorMessage)
        }, success: { (models) in
            self.loadingViewAndSpinner(isHidden: true)
            for item in models {
                self.users.append(item)
            }
            print(self.users.count)
            self.usersCollectionView.reloadData()
        })
    }
    
    private func requestUserInfo(with url: URL) {
        requestUserInfo.requestData(with: url, fail: { (errorMessage) in
            self.loadingViewAndSpinner(isHidden: true)
            self.showErrorAlert(message: errorMessage)
        }) { (model) in
            self.loadingViewAndSpinner(isHidden: true)
            self.present(UserInfoViewController(model: model), animated: true, completion: nil)
        }
    }
    
    private func requestSearchResults(with url: URL) {
        requestSearchResults.requestData(with: url, fail: { (errorMessage) in
            self.showErrorAlert(message: errorMessage)
        }) { (model) in
            self.searchResults.removeAll()
            for item in model.items {
                self.searchResults.append(item)
            }
            
            self.usersCollectionView.reloadData()
        }
    }
    
    private func loadingViewAndSpinner(isHidden: Bool) {
        loadingView.isHidden = isHidden
        spinner.isHidden = isHidden
    }
}

//MARK: - CollectionView
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private func collectionViewSetup() {
        usersCollectionView.delegate = self
        usersCollectionView.dataSource = self
        usersCollectionView.register(UINib(nibName: UserCollectionViewCell.classNaming, bundle: nil), forCellWithReuseIdentifier: UserCollectionViewCell.classNaming)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: usersCollectionView.bounds.width / 3 - 16, height: 140)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch state {
        case .users:
            return users.count
        case .search:
            return searchResults.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = usersCollectionView.dequeueReusableCell(withReuseIdentifier: UserCollectionViewCell.classNaming, for: indexPath) as? UserCollectionViewCell else { return UICollectionViewCell() }
        
        switch state {
        case .users:
            cell.fill(with: users[indexPath.row])
            
            if indexPath.row == users.count - 1 {
                requestUsers(with: Constants.gitHubUrl + "?since=\(users.last?.id ?? 0)")
            }
        case .search:
            cell.fill(with: searchResults[indexPath.row])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch state {
        case .users:
            guard let url = URL(string: users[indexPath.row].url) else { return }
            requestUserInfo(with: url)
        case .search:
            guard let url = URL(string: searchResults[indexPath.row].url) else { return }
            requestUserInfo(with: url)
        }
        
        loadingViewAndSpinner(isHidden: false)
        
    }
}

//MARK: - SearchBar
extension MainViewController: UISearchBarDelegate {
    
    private func searchBarSetup() {
        searchBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        requestSearchResults.cancel()
        
        if searchText == "" {
            state = .users
            usersCollectionView.reloadData()
        } else {
            state = .search
            guard let url = URL(string: Constants.searchUrl + searchText) else { return }
            requestSearchResults(with: url)
        }
    }
}
