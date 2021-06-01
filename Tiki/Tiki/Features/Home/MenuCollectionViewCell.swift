//
//  MenuCollectionViewCell.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 4/7/21.
//

import UIKit

class MenuCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Variables
    
    var menuModel: MenuFeedSectionModel?
    
    // MARK: - UI Elements

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
    
    // MARK: - View LifeCycles
    
    override func initialize() {
        super.initialize()
        layoutMenuCollectionView()
    }
    
    // MARK: - Layout
    
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

// MARK: - UICollectionViewDelegateFlowLayout

extension MenuCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 72) / 5
        return CGSize(width: width, height: 50)
    }
}

// MARK: - UICollectionViewDataSource

extension MenuCollectionViewCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return menuModel?.menuModel.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ImageTitleCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        let menu = menuModel?.menuModel[indexPath.row]
        cell.configCell(menu?.image, menu?.name)
        return cell
    }
}

// MARK: - HomeViewProtocol

extension MenuCollectionViewCell: HomeViewProtocol {
    func configDataMenu(menu: MenuFeedSectionModel?) {
        self.menuModel = menu
    }
}
