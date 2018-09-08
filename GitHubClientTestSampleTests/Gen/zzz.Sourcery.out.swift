// Generated using Sourcery 0.13.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


@testable import GitHubClientTestSample
import UIKit
import Foundation
import RxSwift

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

// MARK: - RootViewController
extension RootViewController: PrivatePropertyAccessible {}

extension PrivateProperties where Base == RootViewController {
    var currentNavigationController: UINavigationController {
        return property(forKey: "currentNavigationController")
    }
}
