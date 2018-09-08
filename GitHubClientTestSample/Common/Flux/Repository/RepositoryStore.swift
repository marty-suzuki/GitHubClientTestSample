//
//  RepositoryStore.swift
//  GitHubClientTestSample
//
//  Created by marty-suzuki on 2018/09/03.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import RxCocoa
import RxSwift

final class RepositoryStore {
    static let shared = RepositoryStore()

    let repositories: ReadOnlyRelay<[GitHub.Repository]>
    let pagination: ReadOnlyRelay<GitHub.Pagination?>
    let isFetching: ReadOnlyRelay<Bool>
    let nextPage: ReadOnlyRelay<Int?>

    let error: Observable<Error>

    private let disposeBag = DisposeBag()

    init(dispatcher: RepositoryDispatcher = .shared) {
        let _repositories = BehaviorRelay<[GitHub.Repository]>(value: [])
        self.repositories = ReadOnlyRelay(_repositories)

        let _pagination = BehaviorRelay<GitHub.Pagination?>(value: nil)
        self.pagination = ReadOnlyRelay(_pagination)

        let _isFetching = BehaviorRelay<Bool>(value: false)
        self.isFetching = ReadOnlyRelay(_isFetching)

        let _nextPage = BehaviorRelay<Int?>(value: nil)
        self.nextPage = ReadOnlyRelay(_nextPage)

        self.error = dispatcher.error.asObservable()

        dispatcher.repositoriesAndPagination
            .withLatestFrom(_repositories) { $1 + $0.0 }
            .bind(to: _repositories)
            .disposed(by: disposeBag)

        dispatcher.repositoriesAndPagination
            .map { $1 }
            .bind(to: _pagination)
            .disposed(by: disposeBag)

        dispatcher.isFetching
            .bind(to: _isFetching)
            .disposed(by: disposeBag)

        _pagination
            .map { $0?.next }
            .bind(to: _nextPage)
            .disposed(by: disposeBag)

        dispatcher.clearAll
            .map { _ in [] }
            .bind(to: _repositories)
            .disposed(by: disposeBag)

        dispatcher.clearAll
            .map { _ in nil }
            .bind(to: _pagination)
            .disposed(by: disposeBag)
    }
}
