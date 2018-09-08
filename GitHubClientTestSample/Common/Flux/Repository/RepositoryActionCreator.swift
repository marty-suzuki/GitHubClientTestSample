//
//  RepositoryActionCreator.swift
//  GitHubClientTestSample
//
//  Created by marty-suzuki on 2018/09/03.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import RxCocoa
import RxSwift

final class RepositoryActionCreator {

    static let shared = RepositoryActionCreator()

    private let _searchRequest = PublishRelay<GitHub.SearchRepositoriesRequest>()
    private let _clearAll = PublishRelay<Void>()

    private let disposeBag = DisposeBag()

    init(dispatcher: RepositoryDispatcher = .shared,
         session: GitHubSessionType = GitHub.Session.shared) {

        _searchRequest
            .map { _ in true }
            .bind(to: dispatcher.isFetching)
            .disposed(by: disposeBag)

        let searchResult = _searchRequest
            .flatMap { [session] in session.send($0) }
            .share()

        searchResult
            .map { _ in false }
            .bind(to: dispatcher.isFetching)
            .disposed(by: disposeBag)

        searchResult
            .flatMap { $0.left.map { Observable.just(($0.items, $1)) } ?? .empty() }
            .bind(to: dispatcher.repositoriesAndPagination)
            .disposed(by: disposeBag)

        searchResult
            .flatMap { $0.right.map(Observable.just) ?? .empty() }
            .bind(to: dispatcher.error)
            .disposed(by: disposeBag)

        _clearAll
            .bind(to: dispatcher.clearAll)
            .disposed(by: disposeBag)
    }

    func searchRepositories(query: String, page: Int?, perPage: Int?) {
        let request = GitHub.SearchRepositoriesRequest(query: query,
                                                       sort: .updated,
                                                       order: .asc,
                                                       page: page,
                                                       perPage: perPage)
        _searchRequest.accept(request)
    }

    func clearAll() {
        _clearAll.accept(())
    }
}
