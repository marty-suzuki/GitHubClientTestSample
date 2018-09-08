//
//  RepositoryDetailViewModel.swift
//  GitHubClientTestSample
//
//  Created by marty-suzuki on 2018/09/06.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import RxCocoa
import RxSwift

final class RepositoryDetailViewModel {

    let progressWithAnimation: Observable<(Float, Bool)>
    let htmlURL: Observable<URL>

    private let disposeBag = DisposeBag()

    init(data: RouteCommand.RepositoryData,
         viewDidAppear: Observable<Bool>,
         estimatedProgress: Observable<Double>,
         environment: Environment = .shared) {

        let trackingModel = environment.trackingModel

        let _htmlURL = BehaviorRelay<URL?>(value: nil)
        self.htmlURL = _htmlURL.asObservable()
            .flatMap { $0.map(Observable.just) ?? .empty() }

        self.progressWithAnimation = Observable.merge(estimatedProgress.filter { $0 == 1 }.map { _ in (0, false) },
                                                      estimatedProgress.map { ($0, true) })
            .map { (Float($0), $1) }

        viewDidAppear
            .withLatestFrom(htmlURL)
            .map { TrackingEvent.pageView(.reposigoryDetail($0)) }
            .subscribe(onNext: {
                trackingModel.sendTrackingEvent($0)
            })
            .disposed(by: disposeBag)

        switch data {
        case .id:
            break
        case let .object(value):
            _htmlURL.accept(value.htmlURL)
        }
    }
}
