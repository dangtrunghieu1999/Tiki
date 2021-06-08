//
//  CategoryTableViewCell.swift
//  Tiki
//
//  Created by Bee_MacPro on 28/05/2021.
//

import UIKit

class CategoriesCollectionViewCell: BaseCollectionViewCell {

    var categories: [Categories] = []
    
    private let containerView: BaseView = {
        let view = BaseView()
        view.backgroundColor = UIColor.separator
        view.layer.cornerRadius = dimension.conerRadiusMedium
        return view
    }()
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.clear
        collectionView.registerReusableCell(ImageCollectionViewCell.self)
        collectionView.contentInset = UIEdgeInsets(top: 0,
                                                   left: dimension.largeMargin,
                                                   bottom: 0,
                                                   right: dimension.largeMargin)
        return collectionView
    }()
    
    override func initialize() {
        super.initialize()
        layoutContainerView()
        layoutCategoryCollectionView()
    }
    
    func configCell(categories: [Categories]) {
        self.categories = categories
        self.collectionView.reloadData()
    }
    
    private func layoutContainerView() {
        addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.left
                .right
                .equalToSuperview()
                .inset(dimension.normalMargin)
            make.top.bottom.equalToSuperview()
        }
    }
    private func layoutCategoryCollectionView() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

extension CategoriesCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (ScreenSize.SCREEN_WIDTH  - 4 * 3 ) / 4
        return CGSize(width: width, height: 120)
    }
}

extension CategoriesCollectionViewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
       
        return categories.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ImageCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.borderColorCell()
        
        if let category = categories[safe: indexPath.row]{
            cell.configCell(category.image)
        }
        
        return cell
    }
}
