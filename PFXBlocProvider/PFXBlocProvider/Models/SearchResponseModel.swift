//
//  SearchResponseModel.swift
//  PFXBlocProvider
//
//  Created by succorer on 2020/02/17.
//  Copyright © 2020 pfxstudio. All rights reserved.
//

import Foundation

public struct SearchResponseModel: Codable {
    var total_count: Int?
    var incomplete_results: Bool?
    var items: Array<SearchModel>?
    var message: String?
    var errors: Array<[String : String]>?
    var documentation_url: String?
    
    init(totalCount: Int) {
        
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        if let total_count = try container.decodeIfPresent(Int.self, forKey: .total_count) { self.total_count = total_count }
        if let incomplete_results = try container.decodeIfPresent(Bool.self, forKey: .incomplete_results) { self.incomplete_results = incomplete_results }
        if let items = try container.decodeIfPresent(Array<SearchModel>.self, forKey: .items) { self.items = items }
        if let message = try container.decodeIfPresent(String.self, forKey: .message) { self.message = message }
        if let errors = try container.decodeIfPresent(Array<[String : String]>.self, forKey: .errors) { self.errors = errors }
        if let documentation_url = try container.decodeIfPresent(String.self, forKey: .documentation_url) { self.documentation_url = documentation_url }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        try container.encode(total_count, forKey: .total_count)
        try container.encode(incomplete_results, forKey: .incomplete_results)
        try container.encode(items, forKey: .items)
        try container.encode(message, forKey: .message)
        try container.encode(errors, forKey: .errors)
        try container.encode(documentation_url, forKey: .documentation_url)
    }

    enum Keys: String, CodingKey {
        case total_count = "total_count"
        case incomplete_results = "incomplete_results"
        case items = "items"
        case message = "message"
        case errors = "errors"
        case documentation_url = "documentation_url"
    }
}
