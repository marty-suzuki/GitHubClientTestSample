//
//  RepositorySearchViewModel.swift
//  GitHubClientTestSample
//
//  Created by marty-suzuki on 2018/09/06.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import RxCocoa
import RxSwift

final class RepositorySearchViewModel {
    let resignFirstResponder: Observable<Void>
    let reloadData: Observable<Void>
    let deselectIndexPath: Observable<IndexPath>

    let repositories: ReadOnlyRelay<[GitHub.Repository]>
    let nextPage: ReadOnlyRelay<Int?>

    private let disposeBag = DisposeBag()

    init(viewDidAppear: Observable<Bool>,
         searchText: Observable<String?>,
         searchButtonClicked: Observable<Void>,
         cancelButtonClicked: Observable<Void>,
         selectedIndexPath: Observable<IndexPath>,
         isBottom: Observable<Bool>,
         environment: Environment = .shared) {
        let repositoryActionCreator = environment.repositoryActionCreator
        let repositoryStore = environment.repositoryStore
        let routeActionCreator = environment.routeActionCreator

        self.repositories = repositoryStore.repositories
        self.nextPage = repositoryStore.nextPage

        self.reloadData = repositoryStore.repositories
            .asObservable().map { _ in }
        self.deselectIndexPath = viewDidAppear
            .withLatestFrom(selectedIndexPath)

        let _resignFirstResponder = PublishRelay<Void>()
        self.resignFirstResponder = _resignFirstResponder.asObservable()

        let loadMore = isBottom
            .distinctUntilChanged()
            .withLatestFrom(repositoryStore.isFetching.asObservable()) { ($0, $1) }
            .flatMap { isBottom, isFetching -> Observable<Void> in
                isBottom && !isFetching ? .just(()) : .empty()
            }
            .share()

        let searchTrigger = Observable.merge(searchButtonClicked, loadMore)
            .withLatestFrom(searchText)
            .flatMap { $0.map(Observable.just) ?? .empty() }
            .filter { !$0.isEmpty }
            .share()

        searchTrigger
            .distinctUntilChanged()
            .subscribe(onNext: { [repositoryActionCreator] _ in
                repositoryActionCreator.clearAll()
            })
            .disposed(by: disposeBag)

        Observable.merge(cancelButtonClicked,
                         searchTrigger.map { _ in })
            .bind(to: _resignFirstResponder)
            .disposed(by: disposeBag)

        searchTrigger
            .withLatestFrom(nextPage.asObservable()) { ($0, $1) }
            .subscribe(onNext: { [repositoryActionCreator] text, page in
                repositoryActionCreator.searchRepositories(query: text, page: page, perPage: 19)
            })
            .disposed(by: disposeBag)

        selectedIndexPath
            .debounce(0.3, scheduler: ConcurrentMainScheduler.instance)
            .withLatestFrom(repositories.asObservable()) { $1[$0.row] }
            .subscribe(onNext: { [routeActionCreator] repository in
                routeActionCreator.setRouteCommand(.repositoryDetail(.object(repository)))
            })
            .disposed(by: disposeBag)
    }
}
