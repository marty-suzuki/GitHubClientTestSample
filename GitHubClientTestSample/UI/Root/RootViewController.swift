//
//  RootViewController.swift
//  GitHubClientTestSample
//
//  Created by marty-suzuki on 2018/09/03.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

final class RootViewController: UIViewController {

    private lazy var currentNavigationController: UINavigationController = {
        let navigationController = UINavigationController(navigationBarClass: nil, toolbarClass: nil)
        addChildViewController(navigationController)
        navigationController.view.frame = view.bounds
        view.addSubview(navigationController.view)
        navigationController.didMove(toParentViewController: self)
        return navigationController
    }()

    // sourcery:begin: ignoreProperty
    private lazy var viewModel = RootViewModel(viewTypes: { [weak nc = currentNavigationController] in
        nc?.viewControllers.map { $0.viewType } ?? []
    })

    private let disposeBag = DisposeBag()
    // sourcery:end

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.showRepositorySearch
            .bind(to: Binder(currentNavigationController) { nc, transition in
                switch transition {
                case let .pop(toRoot):
                    if toRoot {
                        nc.popToRootViewController(animated: true)
                    } else {
                        nc.popViewController(animated: true)
                    }
                case .push:
                    nc.pushViewController(RepositorySearchViewController(), animated: true)
                }
            })
            .disposed(by: disposeBag)

        viewModel.showRepositoryDetail
            .bind(to: Binder(currentNavigationController) { nc, transition in
                switch transition {
                case let .pop(toRoot):
                    if toRoot {
                        nc.popToRootViewController(animated: true)
                    } else {
                        nc.popViewController(animated: true)
                    }
                case let .push(data):
                    let vc = RepositoryDetailViewController(data)
                    nc.pushViewController(vc, animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
}
