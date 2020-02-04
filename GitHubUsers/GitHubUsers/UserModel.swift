//
//  UsersModel.swift
//  GitHubUsers
//
//  Created by Arsenkin Bogdan on 02.02.2020.
//  Copyright © 2020 Arsenkin Bogdan. All rights reserved.
//

import Foundation

class UserModel: Codable {
    var login = String()
    var avatar_url = String()
    var id = Int()
    var url = String()
}

class UserInformation: Codable {
    var login = String()
    var html_url = String()
    var avatar_url = String()
    var name : String?
    var company : String?
    var location : String?
    var public_repos = Int()
    var followers = Int()
    var following = Int()
    var bio : String?
}

class SearchItems: Codable {
    var items = [UserModel]()
}
