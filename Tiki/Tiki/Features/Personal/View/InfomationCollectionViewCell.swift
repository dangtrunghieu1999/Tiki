//
//  InfomationCollectionViewCell.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 3/18/21.
//

import UIKit

class InfomationCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Variables
    
    fileprivate lazy var arrayTitle: [String] = []
    fileprivate lazy var arrayImage: [UIImage?] = []
    
    // MARK: - UI Elements
    
    fileprivate lazy var infomationCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        collectionView.isScrollEnabled = false
        collectionView.registerReusableCell(ItemTextCollectionViewCell.self)
        return collectionView
    }()
    
    // MARK: - View LifeCycles
    
    override func initialize() {
        super.initialize()
        layoutInfomationCollectionView()
    }
    
    // MARK: - Helper Method
    
    func parseDataString(titles: [String],images: [UIImage?]) {
        self.arrayTitle = titles
        self.arrayImage = images
    }
    
    // MARK: - GET API
    
    // MARK: - Layout
    
    private func layoutInfomationCollectionView() {
        addSubview(infomationCollectionView)
        infomationCollectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension InfomationCollectionViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
}

// MARK: - UICollectionViewDelegate

extension InfomationCollectionViewCell: UICollectionViewDelegate {
    
}
 
// MARK: - UICollectionViewDataSource

extension InfomationCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayTitle.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ItemTextCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.configCell(arrayTitle[indexPath.row], arrayImage[indexPath.row])
        return cell
    }
}

