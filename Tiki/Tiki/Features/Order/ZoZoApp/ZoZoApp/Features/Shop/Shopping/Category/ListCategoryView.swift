//
//  ListCategoryView.swift
//  ZoZoApp
//
//  Created by Dang Trung Hieu on 9/1/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class ListCategoryView: BaseShimmerView {
    
    fileprivate var categories: [Category] = []
    
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
        collectionView.isHidden = true
        collectionView.registerReusableCell(CategoryShopViewCollectionViewCell.self)
        return collectionView
    }()
    
    override func initialize() {
        super.initialize()
        backgroundColor = UIColor.white
        startShimmer()
        layoutCollectionView()
    }
    
    func setupData(_ categories: [Category]) {
        stopShimmer()
        collectionView.isHidden = false
        self.categories = categories
        self.collectionView.reloadData()
    }
    
    private func layoutCollectionView() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(Dimension.shared.mediumMargin)
            make.right.equalToSuperview().offset(-Dimension.shared.mediumMargin)
        }
    }
}

// MARK: - UICollectionViewDelegate

extension ListCategoryView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let category = categories[safe: indexPath.row] {
            AppRouter.pushToCategory(categoryId: category.id, categoryName: category.name)
        }
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension ListCategoryView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let category = categories[safe: indexPath.row] {
            let font = UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .medium)
            let estimateWidth = category.name.width(withConstrainedHeight: 50, font: font)
            return CGSize(width: estimateWidth + 20, height: collectionView.frame.height)
        } else {
            return .zero
        }
    }
}

// MARK: - UICollectionViewDataSource

extension ListCategoryView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CategoryShopViewCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        if let category = categories[safe: indexPath.row] {
            cell.configCell(by: category)
        }
        return cell
    }
}
