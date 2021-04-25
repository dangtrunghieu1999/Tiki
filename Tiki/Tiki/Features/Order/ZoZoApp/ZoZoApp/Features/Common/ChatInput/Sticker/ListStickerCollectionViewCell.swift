//
//  ListStickerCollectionViewCell.swift
//  ZoZoApp
//
//  Created by LAP12852 on 10/1/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

protocol ListStickerCollectionViewCellDelegate: class {
    func didSelectSticker(_ stickerModel: StickerModel)
}

class ListStickerCollectionViewCell: BaseCollectionViewCell {
    
    weak var delegate: ListStickerCollectionViewCellDelegate?
    
    fileprivate lazy var listStickerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        let width = (ScreenSize.SCREEN_WIDTH - 5 * 5) / 4
        layout.itemSize = CGSize(width: width, height: width)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerReusableCell(StickerCollectionViewCell.self)
        return collectionView
    }()
    
    override func initialize() {
        layoutListStickerCollectionView()
    }
    
    private func layoutListStickerCollectionView() {
        addSubview(listStickerCollectionView)
        listStickerCollectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
}

// MARK: - UICollectionViewDelegate

extension ListStickerCollectionViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectSticker(StickerModel())
    }
}

// MARK: - UICollectionViewDataSource

extension ListStickerCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: StickerCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.stopAnimate()
        return cell
    }
}
