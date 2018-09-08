//
//  GitHub.ItemsResponse.swift
//  GitHubClientTestSample
//
//  Created by 鈴木大貴 on 2018/09/06.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import Foundation

extension GitHub {
    struct ItemsResponse<Item: Decodable>: Decodable {
        let totalCount: Int
        let incompleteResults: Bool
        let items: [Item]
    }
}

extension GitHub.ItemsResponse {
    private enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}
