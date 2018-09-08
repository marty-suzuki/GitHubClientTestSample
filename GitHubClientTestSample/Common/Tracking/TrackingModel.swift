//
//  TrackingModel.swift
//  GitHubClientTestSample
//
//  Created by marty-suzuki on 2018/09/08.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import Foundation

final class TrackingModel {
    static let shared = TrackingModel()

    private let tracker: TrackerType
    private let deviceStore: DeviceStore

    init(tracker: TrackerType = Tracker.shared,
         environment: Environment = .shared) {
        self.tracker = tracker
        self.deviceStore = environment.flux.deviceStore
    }

    func sendTrackingEvent(_ event: TrackingEvent) {
        let container = TrackingContainer(userID: deviceStore.deviceID.value,
                                          time: Date().timeIntervalSince1970,
                                          event: event)
        tracker.send(container)
    }
}
