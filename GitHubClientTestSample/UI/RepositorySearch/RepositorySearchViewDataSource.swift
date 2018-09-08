//
//  RepositorySearchViewDataSource.swift
//  GitHubClientTestSample
//
//  Created by marty-suzuki on 2018/09/06.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import Foundation
import UIKit

final class RepositorySearchViewDataSource: NSObject {
    private let repositories: ReadOnlyRelay<[GitHub.Repository]>
    private let nextPage: ReadOnlyRelay<Int?>

    private let _selectedIndexPath: (IndexPath) -> ()
    private let _isBottom: (Bool) -> ()

    init(repositories: ReadOnlyRelay<[GitHub.Repository]>,
         nextPage: ReadOnlyRelay<Int?>,
         selectedIndexPath: @escaping (IndexPath) -> (),
         isBottom: @escaping (Bool) -> ()) {
        self.repositories = repositories
        self.nextPage = nextPage
        self._selectedIndexPath = selectedIndexPath
        self._isBottom = isBottom
    }

    func setup(tableView: UITableView) {
        tableView.extension.register(GitHubRepositoryCell.self)
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension RepositorySearchViewDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let repository = repositories.value[indexPath.row]
        return tableView.extension.dequeueReusableCell(for: indexPath) { (cell: GitHubRepositoryCell) in
            cell.configure(with: repository)
        }
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if nextPage.value == nil {
            return nil
        } else {
            return LoadingView()
        }
    }
}

extension RepositorySearchViewDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _selectedIndexPath(indexPath)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.contentSize.height
        let isBottom = height - (scrollView.contentOffset.y + scrollView.bounds.size.height) <= 0
        let isContentSizeNonZero = height > 0
        _isBottom(isBottom && isContentSizeNonZero)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if nextPage.value == nil {
            return CGFloat.leastNonzeroMagnitude
        } else {
            return 44
        }
    }

    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        if let loadingView = view as? LoadingView {
            loadingView.startAnimating()
        }
    }

    func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
        if let loadingView = view as? LoadingView {
            loadingView.stopAnimating()
        }
    }
}
