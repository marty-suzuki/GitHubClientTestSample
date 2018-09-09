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

        RepositoryDispatcher.shared.clearAll.accept(())
        helper.currentNavigationController.setViewControllers([], animated: false)
    }

    func testTrackingEvent_pageView_repositoryDetail() {
        let pagination = helper.paginationMock()
        let repository = helper.repositoryMock()

        RepositoryDispatcher.shared.repositoriesAndPagination.accept(([repository], pagination))

        let vc = helper.showRepositorySearch()

        helper.wait(timeout: 1)

        let expect1: XCTestExpectation
        let disposable: Disposable
        do {
            expect1 = expectation(description: "wait TrackingEvent.pageView(.repositoryDetail)")
            disposable = TrackingDispatcher.shared.trackingContainer
                .flatMap { trackingContainer -> Observable<URL> in
                    if case let .pageView(.repositoryDetail(url)) = trackingContainer.event {
                        return .just(url)
                    }
                    return .empty()
                }
                .subscribe(onNext: { url in
                    XCTAssertEqual(url, repository.htmlURL)
                    expect1.fulfill()
                })
        }

        let expect2: XCTestExpectation
        let observation: NSKeyValueObservation
        do {
            let detailVC: RepositoryDetailViewController = helper.waitViewController(timeout: 1) {
                let tableView = vc.privateProperties.tableView!
                let cell = tableView.visibleCells.first!
                let rect = cell.convert(cell.bounds, to: vc.view)
                vc.view.tap(at: CGPoint(x: rect.midX, y: rect.midY))
            }

            expect2 = expectation(description: "wait webView loading")
            observation = detailVC.privateProperties.webView
                .observe(\.isLoading, options: .new) { _, changed in
                    if changed.newValue == false {
                        expect2.fulfill()
                    }
                }
        }

        wait(for: [expect1, expect2], timeout: 10)
        disposable.dispose()
        observation.invalidate()
    }
}
