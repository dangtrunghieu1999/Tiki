//
//  SameProductCollectionViewCell.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 4/15/21.
//

import UIKit

class ProductSameProductCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Variables
    
    fileprivate lazy var products: [Product] = []
    
    // MARK: - UI Elements

    private lazy var sameProductcollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = Dimension.shared.normalMargin
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.registerReusableCell(ProductCollectionViewCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0,
                                                   left: Dimension.shared.normalMargin,
                                                   bottom: 0,
                                                   right: Dimension.shared.normalMargin)
        return collectionView
    }()
    
    
    // MARK: - View LifeCycles
    
    override func initialize() {
        super.initialize()
        layoutSameProductCollectionView()
    }
    
    // MARK: - Helper Method
    
    func configDataCell(_ products: [Product]) {
        self.products = products
        self.sameProductcollectionView.reloadData()
    }
    
    // MARK: - GET API
    
    
    // MARK: - Layout
    
    private func layoutSameProductCollectionView() {
        addSubview(sameProductcollectionView)
        sameProductcollectionView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-Dimension.shared.mediumMargin)
        }
    }
}

extension ProductSameProductCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 3 * Dimension.shared.normalMargin) / 3
        return CGSize(width: width, height: 220)
    }
}

extension ProductSameProductCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ProductCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.backgroundColor = UIColor.white
        cell.colorCoverView = UIColor.white
        cell.fontSize = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        cell.configDataProductRecommend(product: products, at: indexPath.row)
        
        return cell
    }
}


