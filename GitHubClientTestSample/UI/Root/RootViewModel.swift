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

    enum Transition<T> {
        case push(T)
        case pop(toRoot: Bool)
    }

    let showRepositorySearch: Observable<Transition<Void>>
    let showRepositoryDetail: Observable<Transition<RouteCommand.RepositoryData>>

    private let disposeBag = DisposeBag()

    init(viewTypes: @escaping () -> [ViewType],
         environment: Environment = .shared) {
        let routeStore = environment.routeStore
        
        let _routeCommand = BehaviorRelay<RouteCommand>(value: .repositorySearch)

        self.showRepositorySearch = _routeCommand
            .flatMap { command -> Observable<Transition<Void>> in
                switch command {
                case .repositorySearch:
                    let types = viewTypes()
                    if types.first != .repositorySearch {
                        return .just(.push(()))
                    } else if types.count > 1 {
                        return .just(.pop(toRoot: true))
                    }
                case .repositoryDetail:
                    break
                }
                return .empty()
            }

        self.showRepositoryDetail = _routeCommand
            .flatMap { command -> Observable<Transition<RouteCommand.RepositoryData>> in
                switch command {
                case .repositorySearch:
                    break
                case let .repositoryDetail(data):
                    let types = viewTypes()
                    if types.last != .repositoryDetail {
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
