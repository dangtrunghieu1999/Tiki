//
//  CategoryTableViewCell.swift
//  Tiki
//
//  Created by Bee_MacPro on 28/05/2021.
//

import UIKit

class CategoriesViewCell: BaseCollectionViewCell {

    private var categories: [Categories] = []
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.white
        collectionView.registerReusableCell(ImageCollectionViewCell.self)
        return collectionView
    }()
    
    override func initialize() {
        super.initialize()
        layoutCategoryCollectionView()
    }
    
    private func layoutCategoryCollectionView() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

extension CategoriesViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ScreenSize.SCREEN_WIDTH / 4
        return CGSize(width: width, height: 120)
    }
}

extension CategoriesViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        return categories[safe:section]?.subCategorys.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ImageCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        let section = indexPath.section
        let row     = indexPath.row
        
        if let category = categories[safe: section]?.subCategorys[safe: row] {
            cell.configCell(category.image)
        }
        
        return cell
    }

}
