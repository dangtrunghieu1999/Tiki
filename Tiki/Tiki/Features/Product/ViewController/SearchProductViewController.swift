//
//  SearchProductViewController.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 5/15/21.
//

import UIKit

class SearchProductViewController: BaseViewController {

    // MARK: - Define Variables
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    fileprivate lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    fileprivate lazy var passwordTitleLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    // MAKR: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = searchBar
        navigationItem.rightBarButtonItem = cartBarButtonItem
        self.searchBar.fontSizePlaceholder(text: TextManager.searchTitle2, size: FontSize.h2.rawValue)
    }
    
    
    
}
