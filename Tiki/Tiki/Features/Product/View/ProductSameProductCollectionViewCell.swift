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
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.sameProudct.capitalized
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .semibold)
        label.textAlignment = .left
        return label
    }()

    private lazy var sameProductcollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = Dimension.shared.normalMargin
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.registerReusableCell(ProductRecommendCollectionViewCell.self)
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
        layoutTitleLabel()
        layoutSameProductCollectionView()
    }
    
    // MARK: - Helper Method
    
    func configDataCell(_ products: [Product]) {
        self.products = products
        self.sameProductcollectionView.reloadData()
    }
    
    // MARK: - GET API
    
    
    // MARK: - Layout
    
    private func layoutTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Dimension.shared.normalMargin)
            make.top.equalToSuperview().offset(Dimension.shared.normalMargin )
        }
    }
    
    private func layoutSameProductCollectionView() {
        addSubview(sameProductcollectionView)
        sameProductcollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(Dimension.shared.largeMargin)
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
        return CGSize(width: width, height: 230)
    }
}

extension ProductSameProductCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ProductRecommendCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.backgroundColor = UIColor.white
        cell.colorCoverView = UIColor.white
        cell.fontSize = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        cell.configDataProductRecommend(product: products, at: indexPath.row)
        
        return cell
    }
}


