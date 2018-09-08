//
//  MockTracker.swift
//  GitHubClientTestSampleTests
//
//  Created by marty-suzuki on 2018/09/09.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

@testable import GitHubClientTestSample
import RxCocoa
import RxSwift

final class MockTracker: TrackerType {
    let trackingContainer: Observable<TrackingContainer>
    private let _trackingContainer = PublishRelay<TrackingContainer>()

    init() {
        self.trackingContainer = _trackingContainer.asObservable()
    }

    func send(_ trackingContainer: TrackingContainer) {
        _trackingContainer.accept(trackingContainer)
    }
}
