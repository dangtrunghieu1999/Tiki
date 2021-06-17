//
//  OrderAllViewController.swift
//  Tiki
//
//  Created by Bee_MacPro on 18/05/2021.
//

import UIKit

class OrderAllViewController: BaseViewController {

    
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
        layout.minimumLineSpacing      = 6
        layout.minimumInteritemSpacing = 0
        let collectionView             = UICollectionView(frame: .zero,
                                                          collectionViewLayout: layout)
        collectionView.backgroundColor = .lightBackground
        collectionView.refreshControl  = refreshControl
        collectionView.frame           = view.bounds
//        collectionView.dataSource      = self
//        collectionView.delegate        = self
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @objc private func pullToRefresh() {
    }
    
}


