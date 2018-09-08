//
//  UITableView.extension.swift
//  GitHubClientTestSample
//
//  Created by marty-suzuki on 2018/09/08.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import UIKit

protocol ReusableView: class {
    static var identifiler: String { get }
    static var nib: UINib { get }
}

extension ReusableView {
    static var identifiler: String {
        return String(describing: self)
    }

    static var nib: UINib {
        return UINib(nibName: identifiler, bundle: nil)
    }
}

typealias ReusableCell = UITableViewCell & ReusableView

extension UITableView: ExtensionCompatible {}

extension Extension where Base: UITableView {
    func register<T: ReusableCell>(_ type: T.Type) {
        base.register(T.nib, forCellReuseIdentifier: T.identifiler)
    }

    func dequeueReusableCell<T: ReusableCell>(for indexPath: IndexPath, configure: (T) -> ()) -> UITableViewCell {
        let cell = base.dequeueReusableCell(withIdentifier: T.identifiler, for: indexPath)
        if let cell = cell as? T {
            configure(cell)
        }
        return cell
    }
}
