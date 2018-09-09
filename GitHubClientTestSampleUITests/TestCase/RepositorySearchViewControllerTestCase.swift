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

        RepositoryDispatcher.shared.clearAll.accept(())
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

        helper.showRepositorySearch()

        helper.wait(timeout: 1)

        wait(for: [expect], timeout: 5)
        disposable.dispose()
    }

    func testTrackingEvent_search() {
        let searchText = "swift"

        let vc = helper.showRepositorySearch()
        let searchBar = vc.privateProperties.searchBar

        helper.wait(timeout: 1)

        do {
            let expect1 = expectation(description: "wait TrackingEvent.search")
            let disposable1 = TrackingDispatcher.shared.trackingContainer
                .flatMap { trackingContainer -> Observable<TrackingEvent.Search> in
                    if case let .search(value) = trackingContainer.event {
                        return .just(value)
                    }
                    return .empty()
                }
                .subscribe(onNext: { search in
                    XCTAssertEqual(search.page, 1)
                    XCTAssertEqual(search.query, searchText)
                    expect1.fulfill()
                })

            let expect2 = expectation(description: "wait search results")
            let disposable2 = RepositoryStore.shared.repositories.asObservable()
                .filter { !$0.isEmpty }
                .subscribe(onNext: { _ in
                    expect2.fulfill()
                })

            searchBar.becomeFirstResponder()
            helper.wait(timeout: 1)

            searchBar.helper.inputText(searchText)
            helper.wait(timeout: 1)

            searchBar.delegate?.searchBarSearchButtonClicked?(searchBar)

            wait(for: [expect1, expect2], timeout: 10)
            disposable1.dispose()
            disposable2.dispose()
        }

        helper.wait(timeout: 2)

        do {
            let tableView = vc.privateProperties.tableView!

            let expect1 = expectation(description: "wait TrackingEvent.search")
            let disposable1 = TrackingDispatcher.shared.trackingContainer
                .flatMap { trackingContainer -> Observable<TrackingEvent.Search> in
                    if case let .search(value) = trackingContainer.event {
                        return .just(value)
                    }
                    return .empty()
                }
                .subscribe(onNext: { search in
                    XCTAssertEqual(search.page, 2)
                    XCTAssertEqual(search.query, searchText)
                    expect1.fulfill()
                })

            let expect2 = expectation(description: "wait search results")
            let disposable2 = RepositoryStore.shared.repositories.asObservable()
                .skip(1)
                .filter { !$0.isEmpty }
                .subscribe(onNext: { _ in
                    expect2.fulfill()
                })

            vc.view.drag(from: CGPoint(x: 0, y: tableView.frame.origin.y + 150),
                         to: CGPoint(x: 0, y: tableView.frame.origin.y + 50))

            wait(for: [expect1, expect2], timeout: 10)
            disposable1.dispose()
            disposable2.dispose()
        }

        helper.wait(timeout: 2)
    }
}
