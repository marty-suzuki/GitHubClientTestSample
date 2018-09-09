//
//  RepositorySearchViewControllerTestCase.swift
//  GitHubClientTestSampleUITests
//
//  Created by marty-suzuki on 2018/09/09.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

@testable import GitHubClientTestSample
import XCTest
import KIF

final class RepositorySearchViewControllerTestCase: XCTestCase {
    
    override func setUp() {
        super.setUp()

        helper.currentNavigationController.setViewControllers([], animated: false)
    }

    func testExample() {
        

        helper.showRepositorySearch()
    }
}
