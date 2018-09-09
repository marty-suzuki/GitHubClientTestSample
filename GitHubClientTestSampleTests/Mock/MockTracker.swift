//
//  MockTracker.swift
//  GitHubClientTestSampleTests
//
//  Created by marty-suzuki on 2018/09/09.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

@testable import GitHubClientTestSample

final class MockTracker: TrackerType {

    init() {}
    
    func send(_ trackingContainer: TrackingContainer) {}
}
