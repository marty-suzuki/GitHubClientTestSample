//
//  RouteStore.swift
//  GitHubClientTestSample
//
//  Created by marty-suzuki on 2018/09/03.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import RxSwift

final class RouteStore {
    static let shared = RouteStore()

    let routeCommand: Observable<RouteCommand>

    init(dispatcher: RouteDispatcher = .shared) {
        self.routeCommand = dispatcher.routeCommand.asObservable()
    }
}

enum RouteCommand {
    case repositorySearch
    case repositoryDetail(RepositoryData)
}

extension RouteCommand {
    enum RepositoryData {
        case id(String)
        case object(GitHub.Repository)
    }
}
