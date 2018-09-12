//
//  MockUserDefaults.swift
//  GitHubClientTestSampleTests
//
//  Created by marty-suzuki on 2018/09/09.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

@testable import GitHubClientTestSample

final class MockUserDefaults: UserDefaultsType {
    private var values: [String: Any] = [:]

    func value(forKey key: String) -> Any? {
        return values[key]
    }

    func set(_ value: Any?, forKey defaultName: String) {
        guard let value = value else {
            return
        }
        values[defaultName] = value
    }

    func removeObject(forKey defaultName: String) {
        values.removeValue(forKey: defaultName)
    }
}
