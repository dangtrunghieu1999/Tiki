//
//  ProductDetailSizeCollectionViewCell.swift
//  ZoZoApp
//
//  Created by MACOS on 7/21/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

protocol ProductDetailSizeCollectionViewCellDelegate: class {
    func didSelectSize(_ size: String)
    func didSelectColor(_ color: String)
}

public enum TagType {
    case size
    case color
}

class ProductDetailSizeCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Variables
    
    weak var delegate: ProductDetailSizeCollectionViewCellDelegate?
    
    /// Size or color
    fileprivate var datas: [String] = []
    
    private let layout = TagsStyleFlowLayout()
    fileprivate var tagType: TagType = .size
    fileprivate var selectedData: String?
    
    // MARK: - UI Elements
    
    fileprivate lazy var collectionView: UICollectionView = {
        layout.delegate = self
        layout.cellsPadding = ItemsPadding(horizontal: 15, vertical: 12)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerReusableCell(TagCollectionViewCell.self)
        return collectionView
    }()
    
    // MARK: - LifeCycles
    
    override func initialize() {
        layoutCollectionView()
    }
    
    // MARK: - Public Methods
    
    func configData(_ datas: [String], type: TagType, selectedData: String? = nil) {
        self.tagType = type
        self.datas = datas
        self.selectedData = selectedData
        self.collectionView.reloadData()
    }
    
    // MARK: - Layouts
    
    private func layoutCollectionView() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Dimension.shared.normalMargin)
            make.right.equalToSuperview().offset(-Dimension.shared.normalMargin)
            make.top.equalToSuperview()
            make.height.equalTo(0)
        }
    }
}

// MARK: - UICollectionViewDelegate

extension ProductDetailSizeCollectionViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let data = datas[safe: indexPath.row] else { return }
        if tagType == .size {
            delegate?.didSelectSize(data)
        } else if tagType == .color {
            delegate?.didSelectColor(data)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension ProductDetailSizeCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: TagCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.hideDeleteButton(true)
        let title = datas[safe: indexPath.row] ?? ""
        cell.setTitle(title)
        cell.isSelected = (title == selectedData)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension ProductDetailSizeCollectionViewCell: ContentDynamicLayoutDelegate {
    func onContentSizeChange() {
        let collectionViewHeight = layout.collectionViewContentSize.height
        
        if collectionView.frame.height < collectionViewHeight {
            collectionView.snp.updateConstraints { (make) in
                make.height.equalTo(collectionViewHeight)
            }
        }
    }
    
    func cellSize(indexPath: IndexPath) -> CGSize {
        guard let text = datas[safe: indexPath.row] else { return .zero }
        return TagCollectionViewCell.estmateCellSizeWhenHideDeleteButton(text: text)
    }
}
