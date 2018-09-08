//
//  DeviceStore.swift
//  GitHubClientTestSample
//
//  Created by marty-suzuki on 2018/09/08.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import RxCocoa
import RxSwift

final class DeviceStore {
    static let shared = DeviceStore()

    let deviceID: ReadOnlyRelay<String>

    init(dispatcher: DeviceDispatcher = .shared,
         userDefaults: UserDefaultsManager = .shared) {

        let deviceID: String
        if let id = userDefaults[.deviceID] {
            deviceID = id
        } else {
            deviceID = UUID().uuidString
            userDefaults[.deviceID] = deviceID
        }
        let _deviceID = BehaviorRelay<String>(value: deviceID)
        self.deviceID = ReadOnlyRelay(_deviceID)
    }
}
