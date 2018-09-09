//
//  Helper.swift
//  GitHubClientTestSampleUITests
//
//  Created by marty-suzuki on 2018/09/09.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

protocol HelperCompatible {
    associatedtype HelperCompatibleType = Self
    var helper: Helper<HelperCompatibleType> { get }
}

extension HelperCompatible {
    var helper: Helper<Self> {
        return Helper(base: self)
    }
}

struct Helper<Base> {
    let base: Base
}
