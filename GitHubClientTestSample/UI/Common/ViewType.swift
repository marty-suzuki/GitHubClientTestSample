//
//  ViewType.swift
//  GitHubClientTestSample
//
//  Created by marty-suzuki on 2018/09/03.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import UIKit

enum ViewType {
    case repositorySearch
    case repositoryDetail
    case unknown
}

protocol ViewTypeRepresentable {
    var viewType: ViewType { get }
}

extension ViewTypeRepresentable {
    var viewType: ViewType {
        return .unknown
    }
}

extension UIViewController: ViewTypeRepresentable {}
