//
//  UserDefaultsManager.swift
//  GitHubClientTestSample
//
//  Created by marty-suzuki on 2018/09/08.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import Foundation

protocol UserDefaultsType: class {
    func value(forKey key: String) -> Any?
    func set(_ value: Any?, forKey defaultName: String)
    func removeObject(forKey defaultName: String)
}

extension UserDefaults: UserDefaultsType {}

final class UserDefaultsManager {

    static let shared = UserDefaultsManager()

    private let userDefaults: UserDefaultsType

    init(userDefaults: UserDefaultsType = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }

    subscript<T: OptionalType>(key: Key<T>) -> T {
        get {
            return (userDefaults.value(forKey: key.rawValue) as? T) ?? key.defaultValue
        }
        set {
            if let value = newValue.value {
                userDefaults.set(value, forKey: key.rawValue)
            } else {
                userDefaults.removeObject(forKey: key.rawValue)
            }
        }
    }

    subscript<T>(key: Key<T>) -> T {
        get {
            return (userDefaults.value(forKey: key.rawValue) as? T) ?? key.defaultValue
        }
        set {
            userDefaults.removeObject(forKey: key.rawValue)
        }
    }
}

extension UserDefaultsManager {

    final class Key<T>: UserDefaultsKeys {

        fileprivate let rawValue: String
        fileprivate let defaultValue: T

        init(key: String, defaultValue: T) {
            self.rawValue = key
            self.defaultValue = defaultValue
            super.init()
        }
    }
}

class UserDefaultsKeys {
    fileprivate init() {}
}

extension UserDefaultsKeys {
    static let deviceID = UserDefaultsManager.Key<String?>(key: "device-id", defaultValue: nil)
}
