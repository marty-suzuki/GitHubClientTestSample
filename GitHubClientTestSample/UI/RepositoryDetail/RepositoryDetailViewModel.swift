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

    private let disposeBag = DisposeBag()

    init(estimatedProgress: Observable<Double>) {
        self.progressWithAnimation = Observable.merge(estimatedProgress.filter { $0 == 1 }.map { _ in (0, false) },
                                                      estimatedProgress.map { ($0, true) })
            .map { (Float($0), $1) }
    }
}
