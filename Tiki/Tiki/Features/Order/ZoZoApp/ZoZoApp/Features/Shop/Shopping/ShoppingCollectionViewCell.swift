//
//  ShoppingCollectionViewCell.swift
//  ZoZoApp
//
//  Created by Dang Trung Hieu on 8/29/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

protocol ShoppingCollectionViewCellDelegate: class {
    func loadMoreProducts(_ type: ShoppingViewController.ShoppingOptions)
}

class ShoppingCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Variables
    
    weak var delegate: ShoppingCollectionViewCellDelegate?
    var shoppingCellType: ShoppingViewController.ShoppingOptions = .popular
    
    fileprivate var isEarnMoneyLayout           = false
    fileprivate var products: [Product]         = []
    fileprivate var isFirstLoadAPI              = true
    
    // MARK: - UI Elements
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = BaseProductView.itemSpacing
        layout.minimumInteritemSpacing = BaseProductView.itemSpacing
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.lightBackground
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.registerReusableCell(ProductCollectionViewCell.self)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return collectionView
    }()
    
    fileprivate lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightSeparator
        return view
    }()
    
    // MARK: - View LifeCycles
    
    override func initialize() {
        super.initialize()
        backgroundColor = UIColor.lightBackground
        layoutCollectionView()
        layoutLineView()
    }
    
    // MARK: - Public methods
    
    func configData(_ products: [Product], isEarnMoneyLayout: Bool) {
        self.products = products
        self.isFirstLoadAPI = false
        self.isEarnMoneyLayout = isEarnMoneyLayout
        collectionView.reloadData()
    }
    
    private func layoutCollectionView() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalTo(-Dimension.shared.mediumMargin)
            make.left.right.equalToSuperview()
        }
    }
    
    private func layoutLineView() {
        addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
            make.width.equalToSuperview()
        }
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ShoppingCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isEarnMoneyLayout {
            return BaseProductView.earnMoneySize
        } else {
            return BaseProductView.guestUserSize
        }
    }
}

// MARK: - UICollectionViewDelegate

extension ShoppingCollectionViewCell: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let collectionViewOffset = self.collectionView.contentSize.width -
            self.collectionView.frame.size.width - 50
        if scrollView.contentOffset.x >= collectionViewOffset {
            delegate?.loadMoreProducts(shoppingCellType)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let products = products[safe: indexPath.row] {
            AppRouter.pushToProductDetail(products)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension ShoppingCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if products.isEmpty && isFirstLoadAPI {
            return 5
        } else {
            return products.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ProductCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        
        if let product = products[safe: indexPath.row] {
            cell.configData(product, isEarnMoneyLayout: isEarnMoneyLayout)
        }
        
        if !isFirstLoadAPI {
            cell.stopShimmer()
        }
        
        return cell
    }
}
