//
//  Swizzle.swift
//  GitHubClientTestSampleUITests
//
//  Created by marty-suzuki on 2018/09/09.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import Foundation

func swizzle(_ clazz: AnyClass, from originalSelector: Selector, to swizzledSelector: Selector) {
    guard
        let originalMethod = class_getInstanceMethod(clazz, originalSelector),
        let swizzledMethod = class_getInstanceMethod(clazz, swizzledSelector)
    else {
        return
    }

    method_exchangeImplementations(originalMethod, swizzledMethod)
}
