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
    
    // MARK: - UI Elements
    
    fileprivate lazy var personalCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.separator
        collectionView.registerReusableCell(ItemTextCollectionViewCell.self)
        return collectionView
    }()
    
    // MARK: - View LifeCycles
    
    override func initialize() {
        super.initialize()
    }
    
    // MARK: - Helper Method
    
    func parseDataString(data: [String]) {
        self.arrayTitle = data
    }
    
    // MARK: - GET API
    
    // MARK: - Layout
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension InfomationCollectionViewCell: UICollectionViewDelegateFlowLayout {
    
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
        return cell
    }
}

