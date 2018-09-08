//
//  RouteActionCreator.swift
//  GitHubClientTestSample
//
//  Created by marty-suzuki on 2018/09/03.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import Foundation

final class RouteActionCreator {
    static let shared = RouteActionCreator()

    private let dispatcher: RouteDispatcher

    init(dispatcher: RouteDispatcher = .shared) {
        self.dispatcher = dispatcher
    }

    func setRouteCommand(_ command: RouteCommand) {
        dispatcher.routeCommand.accept(command)
    }
}
