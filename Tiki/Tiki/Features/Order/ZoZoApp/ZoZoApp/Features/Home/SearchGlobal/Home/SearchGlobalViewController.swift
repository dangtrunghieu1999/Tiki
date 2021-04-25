//
//  SearchGlobalViewController.swift
//  ZoZoApp
//
//  Created by LAP12852 on 8/30/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class SearchGlobalViewController: HeaderedCAPSPageMenuViewController {

    // MARK: - Variables
    
    private lazy var viewControllerFrame = CGRect(x: 0,
                                                  y: 0,
                                                  width: view.bounds.width,
                                                  height: view.bounds.height)
    
    private lazy var parameters: [CAPSPageMenuOption] = [
        .centerMenuItems(true),
        .scrollMenuBackgroundColor(UIColor.scrollMenu),
        .selectionIndicatorColor(UIColor.clear),
        .selectedMenuItemLabelColor(UIColor.bodyText),
        .menuItemFont(UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .medium)),
        .menuHeight(42)
    ]
    
    // MARK: - UI Elements
    
    fileprivate var subPageControllers: [UIViewController] = []
    
    fileprivate lazy var searchResultUserVC         = SearchResultUserViewController(with: .user)
    fileprivate lazy var searchResultUserPostVC     = SearchResultUserPostViewController()
    fileprivate lazy var searchShopVC               = SearchResultUserViewController(with: .shop)
    fileprivate lazy var searchProductVC            = ProductListViewController(type: .searchResult)
    
    // MARK: - LifeCycles
    
    override func viewDidLoad() {
        headerHeight = 0;
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = cartBarButtonItem
        setDefaultNavigationBar()
        addSearchChildViewController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
    }
  
    // MARK: - Public Methods
    
    // MARK: - UI Actions

    override func touchUpInBackButton() {
        searchBar.endEditing(true)
        navigationController?.popViewController(animated: false)
    }
    
    // MARK: - Helper Methods
    
    // MARK: - Layout
    
    private func addSearchChildViewController() {
        searchResultUserVC.title = TextManager.user
        searchResultUserVC.view.frame = viewControllerFrame
        subPageControllers.append(searchResultUserVC)
        searchResultUserVC.scrollDelegateFunc = { [weak self] in self?.pleaseScroll($0) }
        
        searchResultUserPostVC.title = TextManager.userPost
        searchResultUserPostVC.view.frame = viewControllerFrame
        subPageControllers.append(searchResultUserPostVC)
        searchResultUserPostVC.scrollDelegateFunc = { [weak self] in self?.pleaseScroll($0) }
        
        searchShopVC.title = TextManager.stall
        searchShopVC.view.frame = viewControllerFrame
        subPageControllers.append(searchShopVC)
        searchShopVC.scrollDelegateFunc = { [weak self] in self?.pleaseScroll($0) }
        
        searchProductVC.title = TextManager.product
        searchProductVC.view.frame = viewControllerFrame
        subPageControllers.append(searchProductVC)
        searchProductVC.scrollDelegateFunc = { [weak self] in self?.pleaseScroll($0) }
        
        addPageMenu(menu: CAPSPageMenu(viewControllers: subPageControllers,
                                       frame: CGRect(x: 0,
                                                     y: 0,
                                                     width: pageMenuContainer.frame.width,
                                                     height: pageMenuContainer.frame.height),
                                       pageMenuOptions: parameters))
    }
    
}
