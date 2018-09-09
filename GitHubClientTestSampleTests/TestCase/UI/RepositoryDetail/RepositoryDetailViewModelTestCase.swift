//
//  RepositoryDetailViewModelTestCase.swift
//  GitHubClientTestSampleTests
//
//  Created by marty-suzuki on 2018/09/09.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

@testable import GitHubClientTestSample
import RxCocoa
import RxSwift
import XCTest

final class RepositoryDetailViewModelTestCase: XCTestCase {
    
    func test_TrackingEvent_pageView() {
        let repository = GitHub.Repository.mock()
        let dependency = Dependency(data: .object(repository))

        let disposeBag = DisposeBag()
        let trackingContainer = BehaviorRelay<TrackingContainer?>(value: nil)

        dependency.trackingDispatcher.trackingContainer
            .bind(to: trackingContainer)
            .disposed(by: disposeBag)

        dependency.viewDidAppear.accept(true)

        guard let value = trackingContainer.value else {
            XCTFail("trackingContainer.value is nil")
            return
        }

        guard case let .pageView(.repositoryDetail(url)) = value.event else {
            XCTFail("value.event must be TrackingEvent.pageView(.repositoryDetail)), but it is \(value.event)")
            return
        }

        XCTAssertEqual(url, repository.url)
    }
}

extension RepositoryDetailViewModelTestCase {
    private struct Dependency {
        let viewDidAppear = PublishRelay<Bool>()
        let estimatedProgress = PublishRelay<Double>()
        let trackingDispatcher: TrackingDispatcher
        let viewModel: RepositoryDetailViewModel

        init(data: RouteCommand.RepositoryData) {
            let flux = Environment.Flux.mock()
            self.trackingDispatcher = flux.trackingDispatcher
            self.viewModel = RepositoryDetailViewModel(data: data,
                                                       viewDidAppear: viewDidAppear.asObservable(),
                                                       estimatedProgress: estimatedProgress.asObservable(),
                                                       environment: Environment.mock(flux: flux))
        }
    }
}
