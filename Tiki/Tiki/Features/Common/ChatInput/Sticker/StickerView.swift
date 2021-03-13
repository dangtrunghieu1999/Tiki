//
//  StickerView.swift
//  ZoZoApp
//
//  Created by LAP12852 on 10/1/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class StickerView: BaseView {
    
    weak var delegate: ListStickerCollectionViewCellDelegate?
    
    fileprivate lazy var categoryStickerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection          = .horizontal
        layout.minimumLineSpacing       = 0
        layout.minimumInteritemSpacing  = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = UIColor.tableBackground
        collectionView.delegate        = self
        collectionView.dataSource      = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.registerReusableCell(ListStickerCollectionViewCell.self)
        return collectionView
    }()
    
    fileprivate lazy var categoryStickerView: CategoryStcikerView = {
        let view = CategoryStcikerView()
        view.delegate = self
        return view
    }()
    
    override func initialize() {
        layoutCategoryStickerView()
        layoutCategoryStickerCollectionView()
    }
    
    private func layoutCategoryStickerView() {
        addSubview(categoryStickerView)
        categoryStickerView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
            if #available(iOS 11, * ) {
                make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalToSuperview()
            }
        }
    }
    
    private func layoutCategoryStickerCollectionView() {
        addSubview(categoryStickerCollectionView)
        categoryStickerCollectionView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(categoryStickerView.snp.top)
        }
    }
    
}

// MARK: - UICollectionViewDelegate

extension StickerView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

// MARK: - UICollectionViewDelegate

extension StickerView: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / categoryStickerCollectionView.frame.width)
        categoryStickerView.selectCategory(at: index)
    }
}

// MARK: - UICollectionViewDataSource

extension StickerView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ListStickerCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.delegate = delegate
        return cell
    }
}

// MARK: - CategoryStcikerViewDelegate

extension StickerView: CategoryStcikerViewDelegate {
    func didSelectCategory(at index: Int) {
        categoryStickerCollectionView.scrollToItem(at: IndexPath(item: 0, section: index),
                                                   at: .centeredHorizontally,
                                                   animated: true)
    }
}
