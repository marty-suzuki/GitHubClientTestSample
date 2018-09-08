//
//  RouteDispatcher.swift
//  GitHubClientTestSample
//
//  Created by marty-suzuki on 2018/09/03.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import RxCocoa

final class RouteDispatcher {
    static let shared = RouteDispatcher()

    let routeCommand = PublishRelay<RouteCommand>()
}
