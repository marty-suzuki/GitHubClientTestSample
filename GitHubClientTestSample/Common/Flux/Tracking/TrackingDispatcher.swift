//
//  TrackingDispatcher.swift
//  GitHubClientTestSample
//
//  Created by marty-suzuki on 2018/09/09.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import RxCocoa

final class TrackingDispatcher {
    static let shared = TrackingDispatcher()

    let trackingContainer = PublishRelay<TrackingContainer>()
}
