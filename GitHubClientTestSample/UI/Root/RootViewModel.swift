//
//  RootViewModel.swift
//  GitHubClientTestSample
//
//  Created by marty-suzuki on 2018/09/03.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import RxCocoa
import RxSwift

final class RootViewModel {

    enum Transition<T, U, V, W> {
        case set(T)
        case push(U)
        case pop(V)
        case popToRoot(W)
    }

    typealias RepoData = RouteCommand.RepositoryData
    typealias RepositorySearchTransition = Transition<Void, Never, Never, Void>
    typealias RepositoryDetailTransition = Transition<RepoData, RepoData, Never, Never>

    let showRepositorySearch: Observable<RepositorySearchTransition>
    let showRepositoryDetail: Observable<RepositoryDetailTransition>

    private let disposeBag = DisposeBag()

    init(viewTypes: @escaping () -> [ViewType],
         environment: Environment = .shared) {
        let routeStore = environment.flux.routeStore
        
        let _routeCommand = BehaviorRelay<RouteCommand>(value: .repositorySearch)

        self.showRepositorySearch = _routeCommand
            .flatMap { command -> Observable<RepositorySearchTransition> in
                switch command {
                case .repositorySearch:
                    let types = viewTypes()
                    if types.isEmpty {
                        return .just(.set(()))
                    } else if types.count > 1 {
                        return .just(.popToRoot(()))
                    }
                case .repositoryDetail:
                    break
                }
                return .empty()
            }

        self.showRepositoryDetail = _routeCommand
            .flatMap { command -> Observable<RepositoryDetailTransition> in
                switch command {
                case .repositorySearch:
                    break
                case let .repositoryDetail(data):
                    let types = viewTypes()
                    if types.isEmpty {
                        return .just(.set(data))
                    } else if types.last != .repositoryDetail {
                        return .just(.push(data))
                    }
                }
                return .empty()
            }

        routeStore.routeCommand
            .bind(to: _routeCommand)
            .disposed(by: disposeBag)
    }
}
