//
//  RepositoryDispatcher.swift
//  GitHubClientTestSample
//
//  Created by marty-suzuki on 2018/09/03.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import RxCocoa

final class RepositoryDispatcher {
    static let shared = RepositoryDispatcher()

    let repositoriesAndPagination = PublishRelay<([GitHub.Repository], GitHub.Pagination)>()
    let error = PublishRelay<Error>()
    let isFetching = PublishRelay<Bool>()
    let clearAll = PublishRelay<Void>()
}
