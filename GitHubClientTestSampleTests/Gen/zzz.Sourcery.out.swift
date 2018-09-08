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

protocol _OptionalType {
    associatedtype Wrapped
    var value: Wrapped? { get }
}

extension Optional: _OptionalType {
    var value: Wrapped? {
        return self
    }
}

extension PrivateProperties where Base: NSObject {
    func property<T>(forKey key: String) -> T {
        return base.value(forKey: key) as! T
    }

    func property<T: _OptionalType>(forKey key: String) -> T? {
        return base.value(forKey: key) as? T
    }
}

// MARK: - RootViewController
extension RootViewController: PrivatePropertyAccessible {}

extension PrivateProperties where Base == RootViewController {
    var currentNavigationController: UINavigationController {
        return property(forKey: "currentNavigationController")
    }
    var viewModel: <<unknown type, please add type attribution to variable 'var viewModel = RootViewModel(viewTypes: { [weak nc = currentNavigationController] in
        nc?.viewControllers.map { $0.viewType } ?? []
    })'>> {
        return property(forKey: "viewModel")
    }
    var disposeBag: DisposeBag {
        return property(forKey: "disposeBag")
    }
}
