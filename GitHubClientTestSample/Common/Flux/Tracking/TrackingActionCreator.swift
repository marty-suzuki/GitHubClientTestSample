//
//  TrackingActionCreator.swift
//  GitHubClientTestSample
//
//  Created by marty-suzuki on 2018/09/09.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import Foundation

final class TrackingActionCreator {
    static let shared = TrackingActionCreator()

    private let tracker: TrackerType
    private let dispatcher: TrackingDispatcher

    init(dispatcher: TrackingDispatcher = .shared,
         tracker: TrackerType = Tracker.shared) {
        self.dispatcher = dispatcher
        self.tracker = tracker
    }

    func send(_ trackingContainer: TrackingContainer) {
        tracker.send(trackingContainer)
        dispatcher.trackingContainer.accept(trackingContainer)
    }
}
