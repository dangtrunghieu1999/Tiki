//
//  CategoryStcikerView.swift
//  ZoZoApp
//
//  Created by LAP12852 on 10/6/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

protocol CategoryStcikerViewDelegate: class {
    func didSelectCategory(at index: Int)
}

class CategoryStcikerView: BaseView {

    // MARK: - Variables
    
    weak var delegate: CategoryStcikerViewDelegate?
    
    fileprivate var selectedIndex = 0
    
    // MARK: - UI Elements
    
    fileprivate let topLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.separator
        return view
    }()
    
    fileprivate lazy var listStickerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        let width = ScreenSize.SCREEN_WIDTH / 7 - 6
        layout.itemSize = CGSize(width: width, height: width)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerReusableCell(StickerCollectionViewCell.self)
        return collectionView
    }()
    
    // MARK: - LifeCycles
    
    override func initialize() {
        layoutListStickerCollectionView()
        layoutTopLineView()
    }
    
    // MARK: - Public Methods
    
    func selectCategory(at index: Int) {
        selectedIndex = index
        listStickerCollectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .right, animated: true)
        listStickerCollectionView.reloadData()
    }
    
    // MARK: - UI Actions
    
    // MARK: - Helper Methods
    
    // MARK: - Layout
    
    private func layoutListStickerCollectionView() {
        addSubview(listStickerCollectionView)
        listStickerCollectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func layoutTopLineView() {
        addSubview(topLineView)
        topLineView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(1.0)
        }
    }

}

// MARK: - UICollectionViewDelegate

extension CategoryStcikerView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectCategory(at: indexPath.row)
    }
}

// MARK: - UICollectionViewDataSource

extension CategoryStcikerView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: StickerCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.updateState(isSelected: indexPath.row == selectedIndex)
        cell.stopAnimate()
        return cell
    }
}
