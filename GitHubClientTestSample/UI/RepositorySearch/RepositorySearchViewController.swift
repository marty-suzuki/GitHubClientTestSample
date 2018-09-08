//
//  RepositorySearchViewController.swift
//  GitHubClientTestSample
//
//  Created by marty-suzuki on 2018/09/03.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

final class RepositorySearchViewController: UIViewController {

    let viewType: ViewType = .repositorySearch

    @IBOutlet private weak var tableView: UITableView!

    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.showsCancelButton = true
        return searchBar
    }()

    // sourcery:begin: ignoreProperty
    private let selectedIndexPath = PublishRelay<IndexPath>()
    private let isBottom = PublishRelay<Bool>()

    private lazy var viewModel: RepositorySearchViewModel = {
        return .init(viewDidAppear: self.extension.viewDidAppear,
                     searchText: searchBar.rx.text.asObservable(),
                     searchButtonClicked: searchBar.rx.searchButtonClicked.asObservable(),
                     cancelButtonClicked: searchBar.rx.cancelButtonClicked.asObservable(),
                     selectedIndexPath: selectedIndexPath.asObservable(),
                     isBottom: isBottom.asObservable())
    }()

    private lazy var dataSource: RepositorySearchViewDataSource = {
        return .init(repositories: viewModel.repositories,
                     nextPage: viewModel.nextPage,
                     selectedIndexPath: { [weak self] in self?.selectedIndexPath.accept($0) },
                     isBottom: { [weak self] in self?.isBottom.accept($0) })
    }()

    private let disposeBag = DisposeBag()
    // sourcery:end

    init() {
        super.init(nibName: "RepositorySearchViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.titleView = searchBar

        dataSource.setup(tableView: tableView)

        viewModel.resignFirstResponder
            .bind(to: Binder(searchBar) { bar, _ in
                bar.resignFirstResponder()
            })
            .disposed(by: disposeBag)

        viewModel.reloadData
            .bind(to: Binder(tableView) { tableView, _ in
                tableView.reloadData()
            })
            .disposed(by: disposeBag)

        viewModel.deselectIndexPath
            .bind(to: Binder(tableView) { tableView, indexPath in
                tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
