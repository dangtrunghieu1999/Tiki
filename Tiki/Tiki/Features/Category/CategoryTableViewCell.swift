//
//  CategoryTableViewCell.swift
//  Tiki
//
//  Created by Bee_MacPro on 28/05/2021.
//

import UIKit

class CategoryTableViewCell: BaseTableViewCell {

    
    let data: [UIImage?] = [UIImage(named: "c1"), UIImage(named: "c2"), UIImage(named: "c3"), UIImage(named: "c4"), UIImage(named: "c5")]
    
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
        collectionView.registerReusableCell(CategoryCollectionViewCell.self)
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

extension CategoryTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ScreenSize.SCREEN_WIDTH / 4
        return CGSize(width: width, height: 120)
    }
}

extension CategoryTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CategoryCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.configCell(data[indexPath.row])
        return cell
    }

}
