//
//  RepositoryDetailViewController.swift
//  GitHubClientTestSample
//
//  Created by marty-suzuki on 2018/09/03.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import UIKit
import WebKit
import RxCocoa
import RxSwift

final class RepositoryDetailViewController: UIViewController {

     let viewType: ViewType = .repositoryDetail

    @IBOutlet private weak var webContainerView: UIView! {
        didSet {
            webView.frame = webContainerView.bounds
            webContainerView.addSubview(webView)
            webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
    }
    @IBOutlet private weak var progressView: UIProgressView!

    private let webView = WKWebView(frame: .zero)

    private lazy var viewModel: RepositoryDetailViewModel = {
        return .init(estimatedProgress: webView.extension.estimatedProgress)
    }()

    private let disposeBag = DisposeBag()

    init(_ data: RouteCommand.RepositoryData) {
        super.init(nibName: "RepositoryDetailViewController", bundle: nil)

        switch data {
        case let .object(respository):
            webView.load(URLRequest(url: respository.htmlURL))
        case .id:
            break
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.progressWithAnimation
            .bind(to: Binder(progressView) { progressView, progressWithAnimation in
                progressView.setProgress(progressWithAnimation.0,
                                         animated: progressWithAnimation.1)
            })
            .disposed(by: disposeBag)
    }
}
