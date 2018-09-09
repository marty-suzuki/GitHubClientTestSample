//
//  TrackingStore.swift
//  GitHubClientTestSample
//
//  Created by marty-suzuki on 2018/09/09.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import RxSwift

final class TrackingStore {
    static let shared = TrackingStore()

    private let sheduler = ConcurrentDispatchQueueScheduler(qos: .default)
    private let disposeBag = DisposeBag()

    init(dispatcher: TrackingDispatcher = .shared)  {
        #if DEBUG
        dispatcher.trackingContainer
            .observeOn(sheduler)
            .subscribe(onNext: {
                EncodableLogger.print($0)
            })
            .disposed(by: disposeBag)
        #endif
    }
}
