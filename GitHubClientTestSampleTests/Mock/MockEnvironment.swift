//
//  MockEnvironment.swift
//  GitHubClientTestSampleTests
//
//  Created by marty-suzuki on 2018/09/09.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

@testable import GitHubClientTestSample

extension Environment {
    static func mock(flux: Flux = .mock()) -> Environment {
        let trackingModel = TrackingModel(flux: flux)
        return Environment(flux: flux, trackingModel: trackingModel)
    }
}

extension Environment.Flux {
    static func mock(session: MockGitHubSession = .init(),
                     userDefaults: MockUserDefaults = .init(),
                     tracker: MockTracker = .init()) -> Environment.Flux {

        let routeDispatcher = RouteDispatcher()
        let routeActionCreator = RouteActionCreator(dispatcher: routeDispatcher)
        let routeStore = RouteStore(dispatcher: routeDispatcher)

        let repositoryDispatcher = RepositoryDispatcher()
        let repositoryActionCreator = RepositoryActionCreator(dispatcher: repositoryDispatcher,
                                                              session: session)
        let repositoryStore = RepositoryStore(dispatcher: repositoryDispatcher)

        let deviceDispatcher = DeviceDispatcher()
        let deviceActionCreator =  DeviceActionCreator(dispatcher: deviceDispatcher)
        let deviceStore = DeviceStore(dispatcher: deviceDispatcher,
                                      userDefaultsManager: UserDefaultsManager(userDefaults: userDefaults))

        let trackingDispatcher = TrackingDispatcher()
        let trackingActionCreator = TrackingActionCreator(dispatcher: trackingDispatcher, tracker: tracker)
        let trackingStore = TrackingStore(dispatcher: trackingDispatcher)

        return Environment.Flux(routeActionCreator: routeActionCreator,
                                routeDispatcher: routeDispatcher,
                                routeStore: routeStore,
                                repositoryActionCreator: repositoryActionCreator,
                                repositoryDispatcher: repositoryDispatcher,
                                repositoryStore: repositoryStore,
                                deviceActionCreator: deviceActionCreator,
                                deviceDispatcher: deviceDispatcher,
                                deviceStore: deviceStore,
                                trackingActionCreator: trackingActionCreator,
                                trackingDispatcher: trackingDispatcher,
                                trackingStore: trackingStore)

    }
}
