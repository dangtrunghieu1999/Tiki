//
//  SearchResultUserPostViewController.swift
//  ZoZoApp
//
//  Created by LAP12852 on 8/30/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class SearchResultUserPostViewController: BaseViewController {

    // MARK: - UI Elements
    
    fileprivate lazy var resultPostCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.lightBackground
        collectionView.registerReusableCell(ResultUserPostCollectionViewCell.self)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutResultPostCollectionView()
    }
    
    private func layoutResultPostCollectionView() {
        view.addSubview(resultPostCollectionView)
        resultPostCollectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SearchResultUserPostViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100)
    }
}

// MARK: - UICollectionViewDataSource

extension SearchResultUserPostViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ResultUserPostCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        return cell
    }
}
