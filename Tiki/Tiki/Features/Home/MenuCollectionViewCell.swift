//
//  MenuCollectionViewCell.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 4/7/21.
//

import UIKit


protocol MenuCollectionViewCellDelegate {
    func configData(menu: MenuModel)
}

class MenuCollectionViewCell: BaseCollectionViewCell {
    
    var menuModel: MenuModel?
    
    fileprivate lazy var menuCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 35
        layout.minimumInteritemSpacing = 18
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .white
        collectionView.registerReusableCell(ImageTitleCollectionViewCell.self)
        return collectionView
    }()
    
    override func initialize() {
        super.initialize()
        layoutMenuCollectionView()
    }
    
    private func layoutMenuCollectionView() {
        addSubview(menuCollectionView)
        menuCollectionView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Dimension.shared.mediumMargin)
            make.left.equalToSuperview().offset(Dimension.shared.normalMargin)
            make.right.equalToSuperview().offset(-Dimension.shared.normalMargin)
            make.bottom.equalToSuperview()
        }
    }
}

extension MenuCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 72) / 5
        return CGSize(width: width, height: 50)
    }
}

extension MenuCollectionViewCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return menuModel?.list.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ImageTitleCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.configCell(menuModel?.list[indexPath.row].image,
                        menuModel?.list[indexPath.row].title)
        return cell
    }
}

extension MenuCollectionViewCell: MenuCollectionViewCellDelegate {
    func configData(menu: MenuModel) {
        self.menuModel = menu
    }
}
