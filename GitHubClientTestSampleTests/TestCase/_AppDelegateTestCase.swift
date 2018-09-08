//
//  _AppDelegateTestCase.swift
//  GitHubClientTestSampleTests
//
//  Created by marty-suzuki on 2018/09/09.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

@testable import GitHubClientTestSample
import RxCocoa
import RxSwift
import XCTest


final class _AppDelegateTestCase: XCTestCase {

    private var dependency: Dependency!
    private var trackingContainer: BehaviorRelay<TrackingContainer?>!
    private var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()

        dependency = Dependency()
        trackingContainer = BehaviorRelay(value: nil)
        disposeBag = DisposeBag()

        dependency.tracker.trackingContainer
            .bind(to: trackingContainer)
            .disposed(by: disposeBag)
    }

    func test_TrackingEvent_background() {
        dependency.appDelegate.applicationDidEnterBackground(MockApplication())

        guard let value = trackingContainer.value else {
            XCTFail("trackingContainer.value is nil")
            return
        }

        guard case .background = value.event else {
            XCTFail("value.event must be TrackingEvent.background, but it is \(value.event)")
            return
        }
    }

    func test_TrackingEvent_launch() {
        dependency.appDelegate.applicationDidBecomeActive(MockApplication())

        guard let value = trackingContainer.value else {
            XCTFail("trackingContainer.value is nil")
            return
        }

        guard case .launch = value.event else {
            XCTFail("value.event must be TrackingEvent.launch, but it is \(value.event)")
            return
        }
    }
}

extension _AppDelegateTestCase {
    private struct Dependency {
        let tracker = MockTracker()
        let appDelegate: _AppDelegate

        init() {
            self.appDelegate = _AppDelegate(rootViewController: UIViewController(),
                                            environment: Environment.mock(tracker: tracker))
        }
    }
}

