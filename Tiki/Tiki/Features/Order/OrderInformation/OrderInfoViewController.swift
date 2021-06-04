//
//  OrderInformationViewController.swift
//  ZoZoApp
//
//  Created by LAP12852 on 8/25/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

enum OrderSection: Int {
    case address      = 0
    case section1     = 1
    case transport    = 2
    case section2     = 3
    case payment      = 4
    case section3     = 5
    case orderInfo    = 6
    
    static func numberOfSections() -> Int {
        return 7
    }
}

class OrderInfoViewController: BaseViewController {
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor.separator
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = TextManager.confirmOrder
        layoutCollectionView()
    }
    
    private func registerCell() {
        self.collectionView.registerReusableCell(AddressCollectionViewCell.self)
        self.collectionView.registerReusableCell(FooterCollectionViewCell.self)
        self.collectionView.registerReusableCell(TransportCollectionViewCell.self)
        self.collectionView.registerReusableCell(PaymentCollectionViewCell.self)
        self
            .collectionView
            .registerReusableCell(OrderCollectionViewCell.self)
    }
    
    
    private func layoutCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            if #available(iOS 11, *) {
                make.top.equalTo(view.safeAreaLayoutGuide)
                make.bottom.equalTo(view.snp.bottomMargin)
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom)
                make.bottom.equalTo(bottomLayoutGuide.snp.top)
            }
        }
    }
}


