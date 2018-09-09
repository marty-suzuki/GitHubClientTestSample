//
//  XCTestCase.helper.swift
//  GitHubClientTestSampleUITests
//
//  Created by marty-suzuki on 2018/09/09.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

@testable import GitHubClientTestSample
import XCTest
import RxSwift

extension XCTestCase: HelperCompatible {}

extension Helper where Base: XCTestCase {
    var rootViewController: RootViewController {
        return UIApplication.shared.delegate!.window!!.rootViewController as! RootViewController
    }

    var currentNavigationController: UINavigationController {
        return rootViewController.privateProperties.currentNavigationController
    }

    var viewControllerLifeCycleHandler: ViewControllerLifeCycleHandler {
        return ViewControllerLifeCycleHandler.shared
    }

    func waitViewController<T: UIViewController>(timeout seconds: Int, execute: (() -> ())? = nil) -> T {
        if let vc = currentNavigationController.topViewController as? T {
            return vc
        }

        var vc: T! = nil
        let expectation = base.expectation(description: "waut \(String(describing: T.self))")
        let disposeable = viewControllerLifeCycleHandler.viewDidAppearCalled
            .debug()
            .flatMap { ($0 as? T).map(Observable.just) ?? .empty() }
            .subscribe(onNext: {
                vc = $0
                expectation.fulfill()
            })

        execute?()

        base.wait(for: [expectation], timeout: TimeInterval(seconds))
        disposeable.dispose()

        return vc
    }

    func wait(timeout seconds: Int, description: String = "\(#function)-\(#line)") {
        let expectation = base.expectation(description: description)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(seconds)) {
            expectation.fulfill()
        }

        base.wait(for: [expectation], timeout: TimeInterval(seconds) + 1)
    }

    @discardableResult
    func showRepositorySearch() -> RepositorySearchViewController {
        return waitViewController(timeout: 1) {
            RouteActionCreator.shared.setRouteCommand(.repositorySearch)
        }
    }

    @discardableResult
    func showRepositoryDetail(repository repo: GitHub.Repository? = nil) -> RepositoryDetailViewController {
        let repository: GitHub.Repository
        if let repo = repo {
            repository = repo
        } else {
            repository = repositoryMock()
        }

        return waitViewController(timeout: 1) {
            RouteActionCreator.shared.setRouteCommand(.repositoryDetail(.object(repository)))
        }
    }

    func repositoryMock() -> GitHub.Repository {
        return GitHub.Repository(id: 1,
                                 nodeID: "nodeID",
                                 name: "URLEmbeddedView",
                                 fullName: "marty-suzuki/URLEmbeddedView",
                                 owner: userMock(),
                                 isPrivate: false,
                                 htmlURL: URL(string: "https://github.com/marty-suzuki/URLEmbeddedView")!,
                                 description: "URLEmbeddedView automatically caches the object that is confirmed the Open Graph Protocol.",
                                 isFork: false,
                                 url: URL(string: "https://github.com/marty-suzuki/URLEmbeddedView")!,
                                 createdAt: "2016-03-06T03:45:39Z",
                                 updatedAt: "2018-08-28T04:50:22Z",
                                 pushedAt: "2018-07-18T10:04:10Z",
                                 homepage: nil,
                                 size: 1,
                                 stargazersCount: 479,
                                 watchersCount: 479,
                                 language: "Swift",
                                 forksCount: 52,
                                 openIssuesCount: 0,
                                 defaultBranch: "master")
    }

    func userMock() -> GitHub.User {
        return GitHub.User(login: "marty-suzuki",
                           id: 1,
                           nodeID: "nodeID",
                           avatarURL: URL(string: "https://avatars1.githubusercontent.com")!,
                           gravatarID: "",
                           url: URL(string: "https://github.com/marty-suzuki")!,
                           receivedEventsURL: URL(string: "https://github.com/marty-suzuki")!,
                           type: "User")
    }

    func paginationMock() -> GitHub.Pagination {
        return GitHub.Pagination(next: nil, last: nil, first: nil, prev: nil)
    }
}
