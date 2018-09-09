//
//  UISearchBar.helper.swift
//  GitHubClientTestSampleUITests
//
//  Created by marty-suzuki on 2018/09/09.
//  Copyright © 2018年 marty-suzuki. All rights reserved.
//

import UIKit
import KIF

extension UISearchBar: HelperCompatible {}

extension Helper where Base: UISearchBar {
    func inputText(_ text: String) {
        KIFTypist.enterCharacter(text)
    }
}
