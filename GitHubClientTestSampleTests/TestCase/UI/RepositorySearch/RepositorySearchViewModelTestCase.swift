//
//  RepositorySearchViewModelTestCase.swift
//  GitHubClientTestSampleTests
//
//  Created by marty-suzuki on 2018/09/09.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

@testable import GitHubClientTestSample
import RxCocoa
import RxSwift
import XCTest


final class RepositorySearchViewModelTestCase: XCTestCase {

    private var dependency: Dependency!
    private var trackingContainer: BehaviorRelay<TrackingContainer?>!
    private var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()

        dependency = Dependency()
        setupTrackingContainer()
    }

    private func setupTrackingContainer() {
        trackingContainer = BehaviorRelay(value: nil)
        disposeBag = DisposeBag()

        dependency.trackingDispatcher.trackingContainer
            .bind(to: trackingContainer)
            .disposed(by: disposeBag)
    }

    func test_TrackingEvent_pageView() {
        dependency.viewDidAppear.accept(true)

        guard let value = trackingContainer.value else {
            XCTFail("trackingContainer.value is nil")
            return
        }

        guard case .pageView(.repositorySearch) = value.event else {
            XCTFail("value.event must be TrackingEvent.pageView(.repositorySearch)), but it is \(value.event)")
            return
        }
    }

    func test_TrackingEvent_pageView_when_viewDidAppear_called_multiple_times() {
        let expectedCount = BehaviorRelay<Int>(value: 0)
        dependency.trackingDispatcher.trackingContainer
            .scan(0) { result, trackingContainer -> Int in
                guard case .pageView(.repositorySearch) = trackingContainer.event else {
                    XCTFail("trackingContainer.event must be TrackingEvent.pageView(.repositorySearch)), but it is \(trackingContainer.event)")
                    return result
                }
                return result + 1
            }
            .bind(to: expectedCount)
            .disposed(by: disposeBag)

        let callCount: Int = Int(arc4random() % 10) + 1

        (0..<callCount).forEach { _ in
            dependency.viewDidAppear.accept(true)
        }

        XCTAssertEqual(expectedCount.value, callCount)
    }

    func test_TrackingEvent_search_when_searchButtonClicked() {
        dependency.searchButtonClicked.accept(())
        XCTAssertNil(trackingContainer.value)

        let searchText = "search-text"
        dependency.searchText.accept(searchText)
        dependency.searchButtonClicked.accept(())

        guard let value = trackingContainer.value else {
            XCTFail("trackingContainer.value is nil")
            return
        }

        guard case let .search(search) = value.event else {
            XCTFail("value.event must be TrackingEvent.search, but it is \(value.event)")
            return
        }

        XCTAssertEqual(search.query, searchText)
        XCTAssertEqual(search.page, 1)
    }

    func test_TrackingEvent_search_when_isBottom_is_false_and_isFetching_is_true() {
        let searchText = "search-text"
        dependency.searchText.accept(searchText)
        dependency.searchButtonClicked.accept(())

        setupTrackingContainer()

        let pagination = GitHub.Pagination(next: 100, last: nil, first: nil, prev: nil)
        dependency.repositoryDispatcher.repositoriesAndPagination.accept(([], pagination))

        dependency.repositoryDispatcher.isFetching.accept(true)
        dependency.isBottom.accept(false)

        XCTAssertNil(trackingContainer.value)
    }

    func test_TrackingEvent_search_when_isBottom_is_true_and_isFetching_is_true() {
        let searchText = "search-text"
        dependency.searchText.accept(searchText)
        dependency.searchButtonClicked.accept(())

        setupTrackingContainer()

        let pagination = GitHub.Pagination(next: 100, last: nil, first: nil, prev: nil)
        dependency.repositoryDispatcher.repositoriesAndPagination.accept(([], pagination))

        dependency.repositoryDispatcher.isFetching.accept(true)
        dependency.isBottom.accept(true)

        XCTAssertNil(trackingContainer.value)
    }

    func test_TrackingEvent_search_when_isBottom_is_false_and_isFetching_is_false() {
        let searchText = "search-text"
        dependency.searchText.accept(searchText)
        dependency.searchButtonClicked.accept(())

        setupTrackingContainer()

        let pagination = GitHub.Pagination(next: 100, last: nil, first: nil, prev: nil)
        dependency.repositoryDispatcher.repositoriesAndPagination.accept(([], pagination))

        dependency.repositoryDispatcher.isFetching.accept(false)
        dependency.isBottom.accept(false)

        XCTAssertNil(trackingContainer.value)
    }

    func test_TrackingEvent_search_when_isBottom_is_true_and_isFetching_is_false() {
        let searchText = "search-text"
        dependency.searchText.accept(searchText)
        dependency.searchButtonClicked.accept(())

        setupTrackingContainer()

        let nextPage: Int = 100
        let pagination = GitHub.Pagination(next: nextPage, last: nil, first: nil, prev: nil)
        dependency.repositoryDispatcher.repositoriesAndPagination.accept(([], pagination))

        dependency.repositoryDispatcher.isFetching.accept(false)
        dependency.isBottom.accept(true)

        guard let value = trackingContainer.value else {
            XCTFail("trackingContainer.value is nil")
            return
        }

        guard case let .search(search) = value.event else {
            XCTFail("value.event must be TrackingEvent.search, but it is \(value.event)")
            return
        }

        XCTAssertEqual(search.query, searchText)
        XCTAssertEqual(search.page, nextPage)
    }
}

extension RepositorySearchViewModelTestCase {
    private struct Dependency {
        let viewDidAppear = PublishRelay<Bool>()
        let searchText = PublishRelay<String?>()
        let searchButtonClicked = PublishRelay<Void>()
        let cancelButtonClicked = PublishRelay<Void>()
        let selectedIndexPath = PublishRelay<IndexPath>()
        let isBottom = PublishRelay<Bool>()

        let repositoryDispatcher: RepositoryDispatcher
        let repositoryStore: RepositoryStore
        let trackingDispatcher: TrackingDispatcher

        let viewModel: RepositorySearchViewModel

        init() {
            let flux = Environment.Flux.mock()
            self.repositoryStore = flux.repositoryStore
            self.repositoryDispatcher = flux.repositoryDispatcher
            self.trackingDispatcher = flux.trackingDispatcher

            self.viewModel = RepositorySearchViewModel(viewDidAppear: viewDidAppear.asObservable(),
                                                       searchText: searchText.asObservable(),
                                                       searchButtonClicked: searchButtonClicked.asObservable(),
                                                       cancelButtonClicked: cancelButtonClicked.asObservable(),
                                                       selectedIndexPath: selectedIndexPath.asObservable(),
                                                       isBottom: isBottom.asObservable(),
                                                       environment: Environment.mock(flux: flux))
        }
    }
}
