//
//  EncodableLogger.swift
//  GitHubClientTestSample
//
//  Created by marty-suzuki on 2018/09/09.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import Foundation

enum EncodableLogger {

    private static let queue = DispatchQueue(label: "encodable-logger-queue", qos: .default, attributes: .concurrent)

    static func print<T: Encodable>(_ encodable: T) {
        queue.async {
            guard let noSortedData = try? JSONEncoder().encode(encodable) else {
                return
            }
            guard let dict = try? JSONSerialization.jsonObject(with: noSortedData, options: []) else {
                return
            }
            guard let sortedData = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted) else {
                return
            }
            guard let jsonString = String(data: sortedData, encoding: .utf8) else {
                return
            }
            DispatchQueue.main.async {
                Swift.print(jsonString)
            }
        }
    }
}
