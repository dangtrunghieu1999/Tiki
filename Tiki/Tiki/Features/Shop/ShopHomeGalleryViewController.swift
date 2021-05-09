//
//  ShopHomeGalleryViewController.swift
//  ZoZoApp
//
//  Created by MACOS on 6/29/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class ShopHomeGalleryViewController: BaseViewController {
    
    // MARK: - Varibles
    
    private var shopId: Int?
    private var photos: [Photo] = []
    private let interItemSpacing: CGFloat = 4
    private let numberOfItemPerRow: CGFloat = 3
    private let lineSpacing: CGFloat = 4
    
    // MARK: - UI Elements
    
    fileprivate lazy var imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = interItemSpacing
        layout.minimumLineSpacing = lineSpacing
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
        collectionView.backgroundColor = UIColor.white
        collectionView.registerReusableCell(ImageCollectionViewCell.self)
        collectionView.registerReusableCell(EmptyCollectionViewCell.self)
        return collectionView
    }()
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutImageCollectionView()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    // MARK: - Public methods
    
    func setupData(shopId: Int) {
        self.shopId = shopId
        self.getAPIPhotos()
    }
    
    // MARK: - API Requests
    
    private func getAPIPhotos() {

    }
    
    // MARK: - Setup layouts
    
    func layoutImageCollectionView() {
        view.addSubview(imageCollectionView)
        imageCollectionView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(Dimension.shared.smallMargin)
            make.right.equalToSuperview().offset(-Dimension.shared.smallMargin)
            make.bottom.equalToSuperview().offset(-Dimension.shared.smallMargin)
        }
    }
    
}

// MARK: - UICollectionViewDelegate

extension ShopHomeGalleryViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let scrollDelegate = scrollDelegateFunc {
            scrollDelegate(scrollView)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !photos.isEmpty else { return }
        let imageURLs = photos.map({$0.url})
        AppRouter.presentPopupImage(urls: imageURLs , selectedIndexPath: indexPath, productName: "")
    }
}

// MARK: - UICollectionViewDataSource

extension ShopHomeGalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if photos.isEmpty {
            return 1
        } else {
            return photos.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (photos.isEmpty) {
            let cell: EmptyCollectionViewCell = imageCollectionView.dequeueReusableCell(for: indexPath)
            cell.message = TextManager.emptyPhotos.localized()
            return cell
        } else {
            let cell: ImageCollectionViewCell = imageCollectionView.dequeueReusableCell(for: indexPath)
            cell.setupData(photos[indexPath.row])
            cell.imageContentMode = .scaleAspectFill
            return cell
        }
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ShopHomeGalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (photos.isEmpty) {
            return CGSize(width: collectionView.frame.width, height: 300)
        } else {
            let widthItem = (imageCollectionView.bounds.width - (numberOfItemPerRow-1) * interItemSpacing)/numberOfItemPerRow
            return CGSize(width: widthItem, height: widthItem + 30)
        }
    }
}

