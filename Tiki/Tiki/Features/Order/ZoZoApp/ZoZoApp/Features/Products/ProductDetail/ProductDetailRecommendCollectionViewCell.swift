//
//  ProductDetailRecommendCollectionViewCell.swift
//  ZoZoApp
//
//  Created by MACOS on 7/20/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

protocol ProductDetailRecommendCollectionViewCellDelegate: class {
    func loadMoreSuggestProducts()
}

class ProductDetailRecommendCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Variables
    
    weak var delegate: ProductDetailRecommendCollectionViewCellDelegate?
    fileprivate lazy var products = [Product]()
    
    // MARK: - UI Elements
    
    fileprivate lazy var productsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = BaseProductView.itemSpacing
        layout.minimumInteritemSpacing = BaseProductView.itemSpacing
        layout.scrollDirection = .horizontal
        layout.itemSize = BaseProductView.guestUserSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.registerReusableCell(ProductCollectionViewCell.self)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return collectionView
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.emptyProducts.localized()
        label.textAlignment = .center
        label.textColor = UIColor.lightBodyText
        label.font = UIFont.systemFont(ofSize: FontSize.body.rawValue)
        label.numberOfLines = 1
        label.isHidden = true
        return label
    }()
    
    // MARK: - LifeCycles
    
    override func initialize() {
        backgroundColor = UIColor.lightBackground
        layoutProductsCollectionView()
        layoutEmptyLabel()
    }
    
    // MARK: - Public methods
    
    func configData(_ products: [Product]) {
        emptyLabel.isHidden = !products.isEmpty
        self.products = products
        productsCollectionView.reloadData()
    }
    
    // MARK: - Layouts
    
    private func layoutProductsCollectionView() {
        addSubview(productsCollectionView)
        productsCollectionView.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalToSuperview()
        }
    }
    
    private func layoutEmptyLabel() {
        addSubview(emptyLabel)
        emptyLabel.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
}

// MARK: - UICollectionViewDelegate

extension ProductDetailRecommendCollectionViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let product = products[safe: indexPath.row] {
            AppRouter.pushToProductDetail(product)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let collectionViewOffset = self.productsCollectionView.contentSize.width - self.productsCollectionView.frame.size.width - 50
        
        if scrollView.contentOffset.x >= collectionViewOffset {
            delegate?.loadMoreSuggestProducts()
        }
    }
}

// MARK: - UICollectionViewDataSource

extension ProductDetailRecommendCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: ProductCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        if let product = products[safe: indexPath.row] {
            cell.configData(product, isOwner: false)
            cell.stopShimmer()
        }
        return cell
    }
}
