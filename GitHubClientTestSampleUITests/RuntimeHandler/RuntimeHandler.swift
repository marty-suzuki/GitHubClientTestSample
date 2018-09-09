//
//  RuntimeHandler.swift
//  GitHubClientTestSampleUITests
//
//  Created by marty-suzuki on 2018/09/09.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

extension RuntimeHandler {
    override open class func handleLoad() {
        _ = ViewControllerLifeCycleHandler.swizzleOnce
    }
}
