//
//  Either.swift
//  GitHubClientTestSample
//
//  Created by marty-suzuki on 2018/09/06.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import Foundation

enum Either<L, R> {
    case left(L)
    case right(R)
}

extension Either {
    var left: L? {
        if case let .left(value) = self {
            return value
        }
        return nil
    }

    var right: R? {
        if case let .right(value) = self {
            return value
        }
        return nil
    }
}
