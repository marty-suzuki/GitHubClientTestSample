//
//  AutoPrivatePropertyAccessible.swift
//  GitHubClientTestSampleTests
//
//  Created by marty-suzuki on 2018/09/03.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import UIKit
@testable import GitHubClientTestSample

protocol AutoPrivatePropertyAccessible {}

extension RootViewController: AutoPrivatePropertyAccessible {}
