//
//  RepositoryDetailViewControllerTestCase.swift
//  GitHubClientTestSampleUITests
//
//  Created by marty-suzuki on 2018/09/09.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

@testable import GitHubClientTestSample
import XCTest
import KIF
import RxSwift
import WebKit

final class RepositoryDetailViewControllerTestCase: XCTestCase {
    
    override func setUp() {
        super.setUp()
        helper.currentNavigationController.setViewControllers([], animated: false)
    }

    func testTrackingEvent_pageView_repositoryDetail() {
        let repository = helper.repositoryMock()
        
        let expect = expectation(description: "wait TrackingEvent.pageView(.repositoryDetail)")
        let disposable = TrackingDispatcher.shared.trackingContainer
            .flatMap { trackingContainer -> Observable<URL> in
                if case let .pageView(.repositoryDetail(url)) = trackingContainer.event {
                    return .just(url)
                }
                return .empty()
            }
            .subscribe(onNext: { url in
                XCTAssertEqual(url, repository.url)
                expect.fulfill()
            })

        RouteActionCreator.shared.setRouteCommand(.repositoryDetail(.object(repository)))

        wait(for: [expect], timeout: 5)
        disposable.dispose()
    }
}
