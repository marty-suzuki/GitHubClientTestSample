//
//  DeviceActionCreator.swift
//  GitHubClientTestSample
//
//  Created by marty-suzuki on 2018/09/09.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

final class DeviceActionCreator {
    static let shared = DeviceActionCreator()

    init(dispatcher: DeviceDispatcher = .shared) {
    }
}
