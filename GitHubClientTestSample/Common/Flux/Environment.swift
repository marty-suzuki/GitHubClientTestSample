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

    let flux: Flux
    let trackingModel: TrackingModel

    init(flux: Flux = .init(),
         trackingModel: TrackingModel = .shared) {
        self.flux = flux
        self.trackingModel = trackingModel
    }
}

extension Environment {

    final class Flux {

        let routeActionCreator: RouteActionCreator
        let routeDispatcher: RouteDispatcher
        let routeStore: RouteStore

        let repositoryActionCreator: RepositoryActionCreator
        let repositoryDispatcher: RepositoryDispatcher
        let repositoryStore: RepositoryStore

        let deviceActionCreator: DeviceActionCreator
        let deviceDispatcher: DeviceDispatcher
        let deviceStore: DeviceStore

        init(routeActionCreator: RouteActionCreator = .shared,
             routeDispatcher: RouteDispatcher = .shared,
             routeStore: RouteStore = .shared,
             repositoryActionCreator: RepositoryActionCreator = .shared,
             repositoryDispatcher:  RepositoryDispatcher = .shared,
             repositoryStore: RepositoryStore = .shared,
             deviceActionCreator: DeviceActionCreator = .shared,
             deviceDispatcher: DeviceDispatcher = .shared,
             deviceStore: DeviceStore = .shared) {

            self.routeActionCreator = routeActionCreator
            self.routeDispatcher = routeDispatcher
            self.routeStore = routeStore
            self.repositoryActionCreator = repositoryActionCreator
            self.repositoryDispatcher = repositoryDispatcher
            self.repositoryStore = repositoryStore
            self.deviceActionCreator = deviceActionCreator
            self.deviceDispatcher = deviceDispatcher
            self.deviceStore = deviceStore
        }
    }
}
