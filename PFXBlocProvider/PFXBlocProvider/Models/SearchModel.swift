//
//  SearchModel.swift
//  PFXBlocProvider
//
//  Created by succorer on 2020/02/17.
//  Copyright © 2020 pfxstudio. All rights reserved.
//

import Foundation
import CoreData
import RxDataSources
import RxCoreData

public struct ItemModel : Codable {

    var login = ""
    var unique_id = 0
    var node_id = ""
    var avatar_url = ""
    var gravatar_id = ""
    var url = ""
    var html_url = ""
    var followers_url = "" // 좋아요
    var following_url = ""
    var gists_url = ""
    var starred_url = ""
    var subscriptions_url = ""
    var organizations_url = ""
    var repos_url = ""
    var events_url = ""
    var received_events_url = ""
    var type = ""
    var site_admin = false
    var score: Float = 0

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        if let login = try container.decodeIfPresent(String.self, forKey: .login) { self.login = login }
        if let unique_id = try container.decodeIfPresent(Int.self, forKey: .unique_id) { self.unique_id = unique_id }
        if let node_id = try container.decodeIfPresent(String.self, forKey: .node_id) { self.node_id = node_id }
        if let avatar_url = try container.decodeIfPresent(String.self, forKey: .avatar_url) { self.avatar_url = avatar_url }
        if let gravatar_id = try container.decodeIfPresent(String.self, forKey: .gravatar_id) { self.gravatar_id = gravatar_id }
        if let url = try container.decodeIfPresent(String.self, forKey: .url) { self.url = url }
        if let html_url = try container.decodeIfPresent(String.self, forKey: .html_url) { self.html_url = html_url }
        if let followers_url = try container.decodeIfPresent(String.self, forKey: .followers_url) { self.followers_url = followers_url }
        if let following_url = try container.decodeIfPresent(String.self, forKey: .following_url) { self.following_url = following_url }
        if let gists_url = try container.decodeIfPresent(String.self, forKey: .gists_url) { self.gists_url = gists_url }
        if let starred_url = try container.decodeIfPresent(String.self, forKey: .starred_url) { self.starred_url = starred_url }
        if let subscriptions_url = try container.decodeIfPresent(String.self, forKey: .subscriptions_url) { self.subscriptions_url = subscriptions_url }
        if let organizations_url = try container.decodeIfPresent(String.self, forKey: .organizations_url) { self.organizations_url = organizations_url }
        if let repos_url = try container.decodeIfPresent(String.self, forKey: .repos_url) { self.repos_url = repos_url }
        if let events_url = try container.decodeIfPresent(String.self, forKey: .events_url) { self.events_url = events_url }
        if let received_events_url = try container.decodeIfPresent(String.self, forKey: .received_events_url) { self.received_events_url = received_events_url }
        if let type = try container.decodeIfPresent(String.self, forKey: .type) { self.type = type }
        if let site_admin = try container.decodeIfPresent(Bool.self, forKey: .site_admin) { self.site_admin = site_admin }
        if let score = try container.decodeIfPresent(Float.self, forKey: .score) { self.score = score }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        try container.encode(login, forKey: .login)
        try container.encode(unique_id, forKey: .unique_id)
        try container.encode(node_id, forKey: .node_id)
        try container.encode(avatar_url, forKey: .avatar_url)
        try container.encode(gravatar_id, forKey: .gravatar_id)
        try container.encode(url, forKey: .url)
        try container.encode(html_url, forKey: .html_url)
        try container.encode(followers_url, forKey: .followers_url)
        try container.encode(following_url, forKey: .following_url)
        try container.encode(gists_url, forKey: .gists_url)
        try container.encode(starred_url, forKey: .starred_url)
        try container.encode(subscriptions_url, forKey: .subscriptions_url)
        try container.encode(organizations_url, forKey: .organizations_url)
        try container.encode(repos_url, forKey: .repos_url)
        try container.encode(events_url, forKey: .events_url)
        try container.encode(received_events_url, forKey: .received_events_url)
        try container.encode(type, forKey: .type)
        try container.encode(site_admin, forKey: .site_admin)
        try container.encode(score, forKey: .score)
    }

    enum Keys: String, CodingKey {
        case login = "login"
        case unique_id = "id"
        case node_id = "node_id"
        case avatar_url = "avatar_url"
        case gravatar_id = "gravatar_id"
        case url = "url"
        case html_url = "html_url"
        case followers_url = "followers_url"
        case following_url = "following_url"
        case gists_url = "gists_url"
        case starred_url = "starred_url"
        case subscriptions_url = "subscriptions_url"
        case organizations_url = "organizations_url"
        case repos_url = "repos_url"
        case events_url = "events_url"
        case received_events_url = "received_events_url"
        case type = "type"
        case site_admin = "site_admin"
        case score = "score"
    }
}

public func == (lhs: ItemModel, rhs: ItemModel) -> Bool {
    return lhs.unique_id == rhs.unique_id
}

extension ItemModel : Equatable { }

extension ItemModel : IdentifiableType {
    public var identity: String { return "\(unique_id)" }
}

extension ItemModel : Persistable {
    public typealias T = NSManagedObject
    
    public static var entityName: String {
        return "Users"
    }
    
    public static var primaryAttributeName: String {
        return "unique_id"
    }
    
    public init(entity: T) {
        login = entity.value(forKey: "login") as! String
        unique_id = entity.value(forKey: "unique_id") as! Int
        node_id = entity.value(forKey: "node_id") as! String
        avatar_url = entity.value(forKey: "avatar_url") as! String
        gravatar_id = entity.value(forKey: "gravatar_id") as! String
        url = entity.value(forKey: "url") as! String
        html_url = entity.value(forKey: "html_url") as! String
        followers_url = entity.value(forKey: "followers_url") as! String
        following_url = entity.value(forKey: "following_url") as! String
        gists_url = entity.value(forKey: "gists_url") as! String
        starred_url = entity.value(forKey: "starred_url") as! String
        subscriptions_url = entity.value(forKey: "subscriptions_url") as! String
        organizations_url = entity.value(forKey: "organizations_url") as! String
        repos_url = entity.value(forKey: "repos_url") as! String
        events_url = entity.value(forKey: "events_url") as! String
        received_events_url = entity.value(forKey: "received_events_url") as! String
        type = entity.value(forKey: "type") as! String
        site_admin = entity.value(forKey: "site_admin") as! Bool
        score = entity.value(forKey: "score") as! Float
    }
    
    public func update(_ entity: T) {
        entity.setValue(login, forKey: "login")
        entity.setValue(unique_id, forKey: "unique_id")
        entity.setValue(node_id, forKey: "node_id")
        entity.setValue(avatar_url, forKey: "avatar_url")
        entity.setValue(gravatar_id, forKey: "gravatar_id")
        entity.setValue(url, forKey: "url")
        entity.setValue(html_url, forKey: "html_url")
        entity.setValue(followers_url, forKey: "followers_url")
        entity.setValue(following_url, forKey: "following_url")
        entity.setValue(gists_url, forKey: "gists_url")
        entity.setValue(starred_url, forKey: "starred_url")
        entity.setValue(subscriptions_url, forKey: "subscriptions_url")
        entity.setValue(organizations_url, forKey: "organizations_url")
        entity.setValue(repos_url, forKey: "repos_url")
        entity.setValue(events_url, forKey: "events_url")
        entity.setValue(received_events_url, forKey: "received_events_url")
        entity.setValue(type, forKey: "type")
        entity.setValue(site_admin, forKey: "site_admin")
        entity.setValue(score, forKey: "score")

        do {
            try entity.managedObjectContext?.save()
        } catch let e {
            print(e)
        }
    }
    
}

/*
 
 {
   "total_count": 7,
   "incomplete_results": false,
   "items": [
     {
       "login": "mojombo",
       "id": 1,
       "node_id": "MDQ6VXNlcjE=",
       "avatar_url": "https://avatars0.githubusercontent.com/u/1?v=4",
       "gravatar_id": "",
       "url": "https://api.github.com/users/mojombo",
       "html_url": "https://github.com/mojombo",
       "followers_url": "https://api.github.com/users/mojombo/followers",
       "following_url": "https://api.github.com/users/mojombo/following{/other_user}",
       "gists_url": "https://api.github.com/users/mojombo/gists{/gist_id}",
       "starred_url": "https://api.github.com/users/mojombo/starred{/owner}{/repo}",
       "subscriptions_url": "https://api.github.com/users/mojombo/subscriptions",
       "organizations_url": "https://api.github.com/users/mojombo/orgs",
       "repos_url": "https://api.github.com/users/mojombo/repos",
       "events_url": "https://api.github.com/users/mojombo/events{/privacy}",
       "received_events_url": "https://api.github.com/users/mojombo/received_events",
       "type": "User",
       "site_admin": false,
       "score": 97.5752
     },
     {
       "login": "tmcw",
       "id": 32314,
       "node_id": "MDQ6VXNlcjMyMzE0",
       "avatar_url": "https://avatars2.githubusercontent.com/u/32314?v=4",
       "gravatar_id": "",
       "url": "https://api.github.com/users/tmcw",
       "html_url": "https://github.com/tmcw",
       "followers_url": "https://api.github.com/users/tmcw/followers",
       "following_url": "https://api.github.com/users/tmcw/following{/other_user}",
       "gists_url": "https://api.github.com/users/tmcw/gists{/gist_id}",
       "starred_url": "https://api.github.com/users/tmcw/starred{/owner}{/repo}",
       "subscriptions_url": "https://api.github.com/users/tmcw/subscriptions",
       "organizations_url": "https://api.github.com/users/tmcw/orgs",
       "repos_url": "https://api.github.com/users/tmcw/repos",
       "events_url": "https://api.github.com/users/tmcw/events{/privacy}",
       "received_events_url": "https://api.github.com/users/tmcw/received_events",
       "type": "User",
       "site_admin": false,
       "score": 84.068565
     },
     {
       "login": "tomnomnom",
       "id": 58276,
       "node_id": "MDQ6VXNlcjU4Mjc2",
       "avatar_url": "https://avatars1.githubusercontent.com/u/58276?v=4",
       "gravatar_id": "",
       "url": "https://api.github.com/users/tomnomnom",
       "html_url": "https://github.com/tomnomnom",
       "followers_url": "https://api.github.com/users/tomnomnom/followers",
       "following_url": "https://api.github.com/users/tomnomnom/following{/other_user}",
       "gists_url": "https://api.github.com/users/tomnomnom/gists{/gist_id}",
       "starred_url": "https://api.github.com/users/tomnomnom/starred{/owner}{/repo}",
       "subscriptions_url": "https://api.github.com/users/tomnomnom/subscriptions",
       "organizations_url": "https://api.github.com/users/tomnomnom/orgs",
       "repos_url": "https://api.github.com/users/tomnomnom/repos",
       "events_url": "https://api.github.com/users/tomnomnom/events{/privacy}",
       "received_events_url": "https://api.github.com/users/tomnomnom/received_events",
       "type": "User",
       "site_admin": false,
       "score": 75.09965
     },
     {
       "login": "tommcfarlin",
       "id": 132166,
       "node_id": "MDQ6VXNlcjEzMjE2Ng==",
       "avatar_url": "https://avatars0.githubusercontent.com/u/132166?v=4",
       "gravatar_id": "",
       "url": "https://api.github.com/users/tommcfarlin",
       "html_url": "https://github.com/tommcfarlin",
       "followers_url": "https://api.github.com/users/tommcfarlin/followers",
       "following_url": "https://api.github.com/users/tommcfarlin/following{/other_user}",
       "gists_url": "https://api.github.com/users/tommcfarlin/gists{/gist_id}",
       "starred_url": "https://api.github.com/users/tommcfarlin/starred{/owner}{/repo}",
       "subscriptions_url": "https://api.github.com/users/tommcfarlin/subscriptions",
       "organizations_url": "https://api.github.com/users/tommcfarlin/orgs",
       "repos_url": "https://api.github.com/users/tommcfarlin/repos",
       "events_url": "https://api.github.com/users/tommcfarlin/events{/privacy}",
       "received_events_url": "https://api.github.com/users/tommcfarlin/received_events",
       "type": "User",
       "site_admin": false,
       "score": 73.803635
     },
     {
       "login": "tomdale",
       "id": 90888,
       "node_id": "MDQ6VXNlcjkwODg4",
       "avatar_url": "https://avatars2.githubusercontent.com/u/90888?v=4",
       "gravatar_id": "",
       "url": "https://api.github.com/users/tomdale",
       "html_url": "https://github.com/tomdale",
       "followers_url": "https://api.github.com/users/tomdale/followers",
       "following_url": "https://api.github.com/users/tomdale/following{/other_user}",
       "gists_url": "https://api.github.com/users/tomdale/gists{/gist_id}",
       "starred_url": "https://api.github.com/users/tomdale/starred{/owner}{/repo}",
       "subscriptions_url": "https://api.github.com/users/tomdale/subscriptions",
       "organizations_url": "https://api.github.com/users/tomdale/orgs",
       "repos_url": "https://api.github.com/users/tomdale/repos",
       "events_url": "https://api.github.com/users/tomdale/events{/privacy}",
       "received_events_url": "https://api.github.com/users/tomdale/received_events",
       "type": "User",
       "site_admin": false,
       "score": 73.47261
     },
     {
       "login": "tommy351",
       "id": 411425,
       "node_id": "MDQ6VXNlcjQxMTQyNQ==",
       "avatar_url": "https://avatars0.githubusercontent.com/u/411425?v=4",
       "gravatar_id": "",
       "url": "https://api.github.com/users/tommy351",
       "html_url": "https://github.com/tommy351",
       "followers_url": "https://api.github.com/users/tommy351/followers",
       "following_url": "https://api.github.com/users/tommy351/following{/other_user}",
       "gists_url": "https://api.github.com/users/tommy351/gists{/gist_id}",
       "starred_url": "https://api.github.com/users/tommy351/starred{/owner}{/repo}",
       "subscriptions_url": "https://api.github.com/users/tommy351/subscriptions",
       "organizations_url": "https://api.github.com/users/tommy351/orgs",
       "repos_url": "https://api.github.com/users/tommy351/repos",
       "events_url": "https://api.github.com/users/tommy351/events{/privacy}",
       "received_events_url": "https://api.github.com/users/tommy351/received_events",
       "type": "User",
       "site_admin": false,
       "score": 72.678246
     },
     {
       "login": "tomaka",
       "id": 1412254,
       "node_id": "MDQ6VXNlcjE0MTIyNTQ=",
       "avatar_url": "https://avatars1.githubusercontent.com/u/1412254?v=4",
       "gravatar_id": "",
       "url": "https://api.github.com/users/tomaka",
       "html_url": "https://github.com/tomaka",
       "followers_url": "https://api.github.com/users/tomaka/followers",
       "following_url": "https://api.github.com/users/tomaka/following{/other_user}",
       "gists_url": "https://api.github.com/users/tomaka/gists{/gist_id}",
       "starred_url": "https://api.github.com/users/tomaka/starred{/owner}{/repo}",
       "subscriptions_url": "https://api.github.com/users/tomaka/subscriptions",
       "organizations_url": "https://api.github.com/users/tomaka/orgs",
       "repos_url": "https://api.github.com/users/tomaka/repos",
       "events_url": "https://api.github.com/users/tomaka/events{/privacy}",
       "received_events_url": "https://api.github.com/users/tomaka/received_events",
       "type": "User",
       "site_admin": false,
       "score": 72.117775
     }
   ]
 }
 
 */

