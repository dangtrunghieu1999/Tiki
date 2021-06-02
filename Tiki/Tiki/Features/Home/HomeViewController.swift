//
//  HomeViewController.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 2/28/21.
//

import UIKit
import IGListKit
import SwiftyJSON

class HomeViewController: BaseViewController {
    
    // MARK: - Variables
    
    fileprivate var viewModel = HomeViewModel()
    
    // MARK: - UI Elements
    
    fileprivate lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.background
        refreshControl.addTarget(self, action: #selector(pullToRefresh),
                                 for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.lightBackground
        collectionView.frame = view.bounds
        collectionView.showsVerticalScrollIndicator = false
        collectionView.refreshControl = refreshControl
        return collectionView
    }()
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonNavBar()
        configNavigationBar()
        layoutCollectionView()
    }
    
    private func configNavigationBar() {
        let height = self.tabBarController?.tabBar.frame.height ?? 0
        self.collectionView.contentInset.bottom     = height
        self.tabBarController?.tabBar.isTranslucent = false
    }
    
    private func setButtonNavBar() {
        self.navigationItem.titleView      = searchBar
        navigationItem.rightBarButtonItems = [cartBarButtonItem,
                                              notifiBarButtonItem]
    }
    
    override func touchInSearchBar() {
        AppRouter.pushViewToSearchBar(viewController: self)
        searchBar.endEditing(true)
    }

    // MARK: - Helper Method
    
    @objc private func pullToRefresh() {
        
    }
}

// MARK: - UI Elements

extension HomeViewController{
    
    private func layoutCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            if #available(iOS 11, *) {
                make.top.equalTo(view.safeAreaInsets)
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom)
            }
            make.left.right.bottom.equalToSuperview()
        }
    }
    
}

