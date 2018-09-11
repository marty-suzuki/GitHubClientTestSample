// Generated using Sourcery 0.14.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


@testable import GitHubClientTestSample
import UIKit
import Foundation
import RxSwift
import WebKit

// MARK: - PrivatePropertyAccessible
protocol PrivatePropertyAccessible {
    associatedtype PrivatePropertiesCompatible
    var privateProperties: PrivateProperties<PrivatePropertiesCompatible> { get }
}

struct PrivateProperties<Base> {
    fileprivate let base: Base

    init(_ base: Base) {
        self.base = base
    }
}

extension PrivatePropertyAccessible where PrivatePropertiesCompatible == Self {
    var privateProperties: PrivateProperties<Self> {
        return PrivateProperties(self)
    }
}

extension PrivateProperties where Base: NSObject {
    func property<T>(forKey key: String) -> T {
        return Mirror(reflecting: base).children.first { $0.label == key }!.value as! T
    }
}

// MARK: - RepositoryDetailViewController
extension RepositoryDetailViewController: PrivatePropertyAccessible {}

extension PrivateProperties where Base == RepositoryDetailViewController {
    var webContainerView: UIView! {
        return property(forKey: "webContainerView")
    }
    var progressView: UIProgressView! {
        return property(forKey: "progressView")
    }
    var webView: WKWebView {
        return property(forKey: "webView")
    }
}
// MARK: - RepositorySearchViewController
extension RepositorySearchViewController: PrivatePropertyAccessible {}

extension PrivateProperties where Base == RepositorySearchViewController {
    var tableView: UITableView! {
        return property(forKey: "tableView")
    }
    var searchBar: UISearchBar {
        return property(forKey: "searchBar")
    }
}
// MARK: - RootViewController
extension RootViewController: PrivatePropertyAccessible {}

extension PrivateProperties where Base == RootViewController {
    var currentNavigationController: UINavigationController {
        return property(forKey: "currentNavigationController")
    }
}
