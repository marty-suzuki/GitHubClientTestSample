//
//  LoadingView.swift
//  GitHubClientTestSample
//
//  Created by marty-suzuki on 2018/09/08.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import UIKit

final class LoadingView: UIView {

    @IBOutlet private var _view: UIView! {
        didSet {
            _view.frame = bounds
            addSubview(_view)
            _view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
    }

    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!

    init() {
        super.init(frame: .zero)

        UINib(nibName: "LoadingView", bundle: nil)
            .instantiate(withOwner: self, options: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func startAnimating() {
        activityIndicatorView.startAnimating()
    }

    func stopAnimating() {
        activityIndicatorView.stopAnimating()
    }
}
