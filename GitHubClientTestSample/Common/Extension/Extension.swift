//
//  Extension.swift
//  GitHubClientTestSample
//
//  Created by marty-suzuki on 2018/09/03.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

protocol ExtensionCompatible {
    associatedtype ExtensionCompatibleType = Self
    var `extension`: Extension<ExtensionCompatibleType> { get }
}

extension ExtensionCompatible {
    var `extension`: Extension<Self> {
        return Extension(base: self)
    }
}

struct Extension<Base> {
    let base: Base
}
