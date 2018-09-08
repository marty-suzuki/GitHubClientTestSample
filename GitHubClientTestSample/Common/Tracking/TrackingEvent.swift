//
//  TrackingEvent.swift
//  GitHubClientTestSample
//
//  Created by marty-suzuki on 2018/09/08.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import Foundation

enum TrackingEvent {
    case launch
    case background
    case pageView(PageView)
    case search(Search)
}

extension TrackingEvent {
    enum PageView {
        case repositorySearch
        case reposigoryDetail(URL)
    }

    struct Search {
        let query: String
        let page: Int
    }
}

extension TrackingEvent: Encodable {
    private enum CodingKeys: String, CodingKey {
        case name
        case value
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .launch:
            try container.encode("launch", forKey: .name)
        case .background:
            try container.encode("background", forKey: .name)
        case let .pageView(value):
            try container.encode("page-view", forKey: .name)
            try container.encode(value, forKey: .value)
        case let .search(value):
            try container.encode("search", forKey: .name)
            try container.encode(value, forKey: .value)
        }
    }
}

extension TrackingEvent.Search: Encodable {
    private enum CodingKeys: String, CodingKey {
        case query
        case page
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(query, forKey: .query)
        try container.encode(page, forKey: .page)
    }
}

extension TrackingEvent.PageView: Encodable {
    private enum CodingKeys: String, CodingKey {
        case page
        case additional
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .repositorySearch:
            try container.encode("repository-search", forKey: .page)
        case let .reposigoryDetail(url):
            try container.encode("repository-detail", forKey: .page)
            try container.encode(url, forKey: .additional)
        }
    }
}
