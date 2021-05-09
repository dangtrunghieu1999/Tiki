//
//  SearchResultUserViewController.swift
//  ZoZoApp
//
//  Created by LAP12852 on 8/30/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class SearchResultUserViewController: BaseViewController {
    
    // MARK: - Variables

    var searchGlobalType: SearchGlobalType = .user
    
    // MARK: - UI Elements
    
    fileprivate lazy var resultUserCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.lightBackground
        collectionView.registerReusableCell(ResultUserCollectionViewCell.self)
        return collectionView
    }()
    
    // MARK: - View LifeCycles
    
    init(with searchGlobalType: SearchGlobalType) {
        super.init(nibName: nil, bundle: nil)
        self.searchGlobalType = searchGlobalType
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutSearchResultCollectionView()
    }
    
    // MARK: - Setup layouts
    
    private func layoutSearchResultCollectionView() {
        view.addSubview(resultUserCollectionView)
        resultUserCollectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

}

// MARK: - UICollectionViewDelegateFlowLayout

extension SearchResultUserViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let estimateWidth = collectionView.frame.width
        return CGSize(width: estimateWidth, height: 100)
    }
}

// MARK: - UICollectionViewDataSource

extension SearchResultUserViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ResultUserCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        return cell
    }
}
