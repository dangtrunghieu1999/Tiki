//
//  FeedEmojiViewController.swift
//  ZoZoApp
//
//  Created by LAP12852 on 9/30/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class FeedEmojiViewController: BaseViewController {

    // MARK: - Variables
    
    // MARK: - UI Elements
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerReusableCell(FeedEmojiCollectionViewCell.self)
        return collectionView
    }()
    
    // MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = TextManager.whatDoYouFeel.localized()
        layoutCollectionView()
    }
    
    // MARK: - Public Methods
    
    // MARK: - UI Actions
    
    // MARK: - Helper Methods
    
    // MARK: - Layout
    
    private func layoutCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

}

// MARK: - UICollectionViewDelegate

extension FeedEmojiViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FeedEmojiViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2, height: 60)
    }
}

// MARK: - UICollectionViewDataSource

extension FeedEmojiViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 17
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FeedEmojiCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        return cell
    }
}
