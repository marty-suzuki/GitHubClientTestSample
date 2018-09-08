//
//  Environment.swift
//  GitHubClientTestSample
//
//  Created by marty-suzuki on 2018/09/06.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import Foundation

final class Environment {
    static let shared = Environment()

    let routeActionCreator: RouteActionCreator
    let routeDispatcher: RouteActionCreator
    let routeStore: RouteStore

    let repositoryActionCreator: RepositoryActionCreator
    let repositoryDispatcher: RepositoryDispatcher
    let repositoryStore: RepositoryStore

    init(routeActionCreator: RouteActionCreator = .shared,
         routeDispatcher: RouteActionCreator = .shared,
         routeStore: RouteStore = .shared,
         repositoryActionCreator: RepositoryActionCreator = .shared,
         repositoryDispatcher:  RepositoryDispatcher = .shared,
         repositoryStore: RepositoryStore = .shared) {

        self.routeActionCreator = routeActionCreator
        self.routeDispatcher = routeDispatcher
        self.routeStore = routeStore
        self.repositoryActionCreator = repositoryActionCreator
        self.repositoryDispatcher = repositoryDispatcher
        self.repositoryStore = repositoryStore
    }
}
