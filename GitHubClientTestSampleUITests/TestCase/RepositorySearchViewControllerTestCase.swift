//
//  RepositorySearchViewControllerTestCase.swift
//  GitHubClientTestSampleUITests
//
//  Created by marty-suzuki on 2018/09/09.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

@testable import GitHubClientTestSample
import XCTest
import KIF
import RxSwift

final class RepositorySearchViewControllerTestCase: XCTestCase {
    
    override func setUp() {
        super.setUp()

        helper.currentNavigationController.setViewControllers([], animated: false)
    }

    func testTrackingEvent_pageView_repositorySearch() {
        let expect = expectation(description: "wait TrackingEvent.pageView(.repositorySearch)")
        let disposable = TrackingDispatcher.shared.trackingContainer
            .flatMap { trackingContainer -> Observable<Void> in
                if case .pageView(.repositorySearch) = trackingContainer.event {
                    return .just(())
                }
                return .empty()
            }
            .subscribe(onNext: {
                expect.fulfill()
            })

        RouteActionCreator.shared.setRouteCommand(.repositorySearch)

        wait(for: [expect], timeout: 5)
        disposable.dispose()
    }
}
