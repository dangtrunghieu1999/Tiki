//
//  CollectionTagView.swift
//  ZoZoApp
//
//  Created by MACOS on 7/1/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

@objc protocol CollectionTagViewDelegate: class {
    @objc optional func didSelectDeleteTag(collectionTagView: CollectionTagView, at index: Int)
    @objc optional func didSelectTag(collectionTagView: CollectionTagView, value: String?)
}

class CollectionTagView: BaseView {
    
    // MARK: - Variables
    
    weak var delegate: CollectionTagViewDelegate?
    
    var hiddeDeleteButton = false {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var selectedValue: String? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private (set) var tags: [String] = []
    fileprivate let layout = TagsStyleFlowLayout()
    
    // MARK: - UI Elements
    
    fileprivate lazy var collectionView: UICollectionView = {
        layout.delegate = self
        layout.cellsPadding = ItemsPadding(horizontal: 15, vertical: 12)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerReusableCell(TagCollectionViewCell.self)
        return collectionView
    }()
    
    // MARK: - LifeCycles
   
    override func initialize() {
        layoutCollectionView()
    }
    
    // MARK: - Public methods
    
    func setTag(tags: [String]) {
        self.tags = tags
        collectionView.reloadData()
    }
    
    func addTag(tag: String) {
        self.tags.append(tag)
        collectionView.reloadData()
    }
    
    // MARK: - Layouts
    
    private func layoutCollectionView() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.height.equalTo(0)
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
}

// MARK: - UICollectionViewDelegate

extension CollectionTagView: ContentDynamicLayoutDelegate {
    func onContentSizeChange() {
        var collectionViewHeight = layout.collectionViewContentSize.height
        if tags.count == 0 {
            collectionViewHeight = 0
        }
        collectionView.snp.updateConstraints { (make) in
            make.height.equalTo(collectionViewHeight)
        }
    }
    
    func cellSize(indexPath: IndexPath) -> CGSize {
        guard let text = tags[safe: indexPath.row] else { return .zero }
        return TagCollectionViewCell.estimateCellSize(text: text)
    }
}

// MARK: - UICollectionViewDataSource

extension CollectionTagView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedValue = tags[indexPath.row]
        collectionView.reloadData()
        delegate?.didSelectTag?(collectionTagView: self, value: selectedValue)
    }
}

// MARK: - UICollectionViewDataSource

extension CollectionTagView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TagCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.setTitle(tags[safe: indexPath.row])
        cell.isSelected = (tags[safe: indexPath.row] == selectedValue)
        cell.indexPath = indexPath
        cell.delegate = self
        cell.hideDeleteButton(hiddeDeleteButton)
        return cell
    }
}

// MARK: - TagCollectionViewCellDelegate

extension CollectionTagView: TagCollectionViewCellDelegate {
    func didSelectButton(at index: Int) {
        delegate?.didSelectDeleteTag?(collectionTagView: self, at: index)
        if tags.count > index {
            tags.remove(at: index)
        }
        collectionView.reloadData()
    }
}
