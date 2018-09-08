//
//  WKWebView.extension.swift
//  GitHubClientTestSample
//
//  Created by marty-suzuki on 2018/09/06.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import RxSwift
import WebKit

extension WKWebView: ExtensionCompatible {}

extension Extension where Base: WKWebView {

    var estimatedProgress: Observable<Double> {
        return Observable<Double>.create { [base] observer in

            let observation = base.observe(\.estimatedProgress, options: .new) { _, change in
                guard let newValue = change.newValue else {
                    return
                }

                observer.onNext(newValue)
            }

            return Disposables.create {
                observation.invalidate()
            }
        }
    }
}
