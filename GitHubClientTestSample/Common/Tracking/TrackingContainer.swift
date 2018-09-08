//
//  TrackingContainer.swift
//  GitHubClientTestSample
//
//  Created by marty-suzuki on 2018/09/08.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import Foundation

struct TrackingContainer {
    let userID: String
    let time: TimeInterval
    let event: TrackingEvent
}

extension TrackingContainer: Encodable {
    private enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case time
        case event
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(userID, forKey: .userID)
        try container.encode(time, forKey: .time)
        try container.encode(event, forKey: .event)
    }
}
