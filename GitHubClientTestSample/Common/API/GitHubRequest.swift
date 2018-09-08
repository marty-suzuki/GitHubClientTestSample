//
//  GitHubRequest.swift
//  GitHubClientTestSample
//
//  Created by 鈴木大貴 on 2018/09/06.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import Foundation

protocol GitHubRequest {
    associatedtype Response: Decodable
    var baseURL: URL { get }
    var method: HttpMethod { get }
    var path: String { get }
    var headerFields: [String: String] { get }
    var queryParameters: [String: String]? { get }
}

extension GitHubRequest {
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }

    var headerFields: [String: String] {
        return ["Accept": "application/json"]
    }

    var queryParameters: [String: String]? {
        return nil
    }
}

enum HttpMethod: String {
    case get = "GET"
}
