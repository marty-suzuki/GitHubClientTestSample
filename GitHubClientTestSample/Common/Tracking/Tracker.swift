//
//  Tracker.swift
//  GitHubClientTestSample
//
//  Created by marty-suzuki on 2018/09/08.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import Foundation

protocol TrackerType: class {
    func send(_ trackingContainer: TrackingContainer)
}

final class Tracker: TrackerType {

    static let shared = Tracker()

    func send(_ trackingContainer: TrackingContainer) {
        // do sending log
    }
}
