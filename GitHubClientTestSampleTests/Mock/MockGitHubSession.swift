//
//  MockGitHubSession.swift
//  GitHubClientTestSampleTests
//
//  Created by marty-suzuki on 2018/09/09.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

@testable import GitHubClientTestSample
import RxCocoa
import RxSwift

final class MockGitHubSession: GitHubSessionType {

    let response: (Either<(Decodable, GitHub.Pagination), Error>) -> ()
    private let _response = PublishRelay<Either<(Decodable, GitHub.Pagination), Error>>()

    init() {
        self.response = { [_response] either in
            _response.accept(either)
        }
    }

    func send<T: GitHubRequest>(_ request: T) -> Observable<Either<(T.Response, GitHub.Pagination), Error>> {
        return _response
            .flatMap { either -> Observable<Either<(T.Response, GitHub.Pagination), Error>> in
                switch either {
                case let .left(response, pagination):
                    guard let response = response as? T.Response else {
                        return .empty()
                    }
                    return .just(.left((response, pagination)))
                case let .right(error):
                    return .just(.right(error))
                }
            }
    }
}
