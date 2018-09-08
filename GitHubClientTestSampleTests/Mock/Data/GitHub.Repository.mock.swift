//
//  GitHub.Repository.mock.swift
//  GitHubClientTestSampleTests
//
//  Created by marty-suzuki on 2018/09/09.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

@testable import GitHubClientTestSample
import Foundation

extension GitHub.Repository {
    static func mock() -> GitHub.Repository {
        return GitHub.Repository(id: 1,
                                 nodeID: "",
                                 name: "",
                                 fullName: "",
                                 owner: .mock(),
                                 isPrivate: false,
                                 htmlURL: URL(string: "https://github.com/")!,
                                 description: nil,
                                 isFork: false,
                                 url: URL(string: "https://github.com/")!,
                                 createdAt: "",
                                 updatedAt: "",
                                 pushedAt: nil,
                                 homepage: nil,
                                 size: 0,
                                 stargazersCount: 0,
                                 watchersCount: 0,
                                 language: nil,
                                 forksCount: 0,
                                 openIssuesCount: 0,
                                 defaultBranch: "")
    }
}
