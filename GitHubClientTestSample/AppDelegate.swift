//
//  AppDelegate.swift
//  GitHubClientTestSample
//
//  Created by marty-suzuki on 2018/09/03.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import UIKit

// MARK: - AppDelegate

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? {
        get { return handler.window }
        set { fatalError("setter must not be called") }
    }

    private lazy var handler = _AppDelegate()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return handler.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        handler.applicationDidEnterBackground(application)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        handler.applicationDidBecomeActive(application)
    }
}

// MARK: - _AppDelegate

final class _AppDelegate {

    private(set) lazy var window: UIWindow = {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        return window
    }()

    private(set) lazy var rootViewController: UIViewController = RootViewController()
    private let trackingModel: TrackingModel

    init(rootViewController: UIViewController? = nil,
         environment: Environment = .shared) {
        self.trackingModel = environment.trackingModel

        if let rootViewController = rootViewController {
            self.rootViewController = rootViewController
        }
    }

    func application(_ application: ApplicationType, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        _ = window
        return true
    }

    func applicationDidEnterBackground(_ application: ApplicationType) {
        trackingModel.sendTrackingEvent(.background)
    }

    func applicationDidBecomeActive(_ application: ApplicationType) {
        trackingModel.sendTrackingEvent(.launch)
    }
}

// MARK: - ApplicationType

protocol ApplicationType: class {}

extension UIApplication: ApplicationType {}
