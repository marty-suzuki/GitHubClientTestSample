//
//  ViewControllerLifeCycleHandler.swift
//  GitHubClientTestSampleUITests
//
//  Created by marty-suzuki on 2018/09/09.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

final class ViewControllerLifeCycleHandler {
    static let shared = ViewControllerLifeCycleHandler()

    static let swizzleOnce: () = {
        swizzle(UIViewController.self,
                from: #selector(UIViewController.viewDidAppear(_:)),
                to: #selector(UIViewController._swizzled_viewDidAppear(_:)))
    }()

    let viewDidAppearCalled: Observable<UIViewController>
    fileprivate let _viewDidAppearCalled = PublishRelay<UIViewController>()

    private init() {
        self.viewDidAppearCalled = _viewDidAppearCalled.asObservable()
    }
}

extension UIViewController {
    @objc fileprivate func _swizzled_viewDidAppear(_ animated: Bool) {
        ViewControllerLifeCycleHandler.shared._viewDidAppearCalled.accept(self)
        _swizzled_viewDidAppear(animated)
    }
}
