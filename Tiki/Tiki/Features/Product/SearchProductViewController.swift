//
//  SearchProductViewController.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 5/15/21.
//

import UIKit

class SearchProductViewController: BaseViewController {

    
    // MAKR: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = searchBar
        navigationItem.rightBarButtonItem = cartBarButtonItem
        self.searchBar.fontSizePlaceholder(text: TextManager.searchTitle2, size: FontSize.h2.rawValue)
    }
    
    
    
}
