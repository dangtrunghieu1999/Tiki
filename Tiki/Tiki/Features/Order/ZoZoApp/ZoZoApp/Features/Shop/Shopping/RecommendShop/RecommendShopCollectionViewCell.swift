//
//  RecommendShopCollectionViewCell.swift
//  ZoZoApp
//
//  Created by LAP12852 on 9/1/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class RecommendShopCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Variables
    
    weak var delegate: ShoppingCollectionViewCellDelegate?
    fileprivate lazy var shops: [Shop]      = []
    
    // MARK: - UI Elements
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerReusableCell(RecommendShopViewCollectionViewCell.self)
        return collectionView
    }()
    
    // MARK: - LifeCycles
    
    override func initialize() {
        backgroundColor = UIColor.lightBackground
        layoutCollectionView()
    }
    
    // MARK: - Public Methods
    
    func setupData(_ shops: [Shop]) {
        self.shops = shops
        self.collectionView.reloadData()
    }
    
    // MARK: - Layout
    
    private func layoutCollectionView() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDelegate

extension RecommendShopCollectionViewCell: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let collectionViewOffset = self.collectionView.contentSize.width -
            self.collectionView.frame.size.width - 50
        if scrollView.contentOffset.x >= collectionViewOffset {
            delegate?.loadMoreProducts(.shopRecomend)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let shop = shops[safe: indexPath.row] else { return }
        AppRouter.pushToShopHome(shop.id ?? 0)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension RecommendShopCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: collectionView.frame.height)
    }
}

// MARK: - UICollectionViewDataSource

extension RecommendShopCollectionViewCell: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shops.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: RecommendShopViewCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        if let shop = shops[safe: indexPath.row] {
            cell.configCell(by: shop)
        }
        cell.stopShimmer()
        return cell
    }
}
