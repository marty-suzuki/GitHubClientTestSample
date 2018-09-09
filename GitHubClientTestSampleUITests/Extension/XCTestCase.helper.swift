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

    func wait(timeout seconds: Int, description: String = "\(#function)-\(#line)") {
        let expectation = base.expectation(description: description)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(seconds)) {
            expectation.fulfill()
        }

        base.wait(for: [expectation], timeout: TimeInterval(seconds) + 1)
    }

    func showRepositorySearch() {
        if currentNavigationController.topViewController is RepositorySearchViewController {
            return
        }

        let expectation = base.expectation(description: "wait RepositorySearchViewController")

        let disposeable = ViewControllerLifeCycleHandler.shared.viewDidAppearCalled
            .debug()
            .filter { $0 is RepositorySearchViewController  }
            .subscribe(onNext: { _ in
                expectation.fulfill()
            })

        RouteActionCreator.shared.setRouteCommand(.repositorySearch)

        base.wait(for: [expectation], timeout: 1)

        disposeable.dispose()
    }

    func showRepositoryDetail(repository: GitHub.Repository = .mock()) {
        if currentNavigationController.topViewController is RepositoryDetailViewController {
            return
        }

        let expectation = base.expectation(description: "wait RepositoryDetailViewController")

        let disposeable = ViewControllerLifeCycleHandler.shared.viewDidAppearCalled
            .filter { $0 is RepositoryDetailViewController  }
            .subscribe(onNext: { _ in
                expectation.fulfill()
            })

        RouteActionCreator.shared.setRouteCommand(.repositoryDetail(.object(repository)))

        base.wait(for: [expectation], timeout: 1)

        disposeable.dispose()
    }
}
