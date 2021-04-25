//
//  FeedViewController.swift
//  ZoZoApp
//
//  Created by MACOS on 6/1/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit
import IGListKit
import SwiftyJSON

class FeedViewController: BaseViewController {
    
    // MARK: - Variables
    
    private lazy var adapter: ListAdapter = {
        let updater = ListAdapterUpdater()
        let adapter = ListAdapter(updater: updater, viewController: self, workingRangeSize: 5)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        return adapter
    }()
    
    private var dataSource: [BaseFeedSectionModel] = []
    
    // MARK: - UI Elements
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.frame = view.bounds
        return collectionView
    }()
    
    // MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = cartBarButtonItem
        setDefaultNavigationBar(leftBarImage: ImageManager.commentWhite)
        view.addSubview(collectionView)
        requestAPINewsFeed()
    }
    
    // MARK: - Public Methods
    
    // MARK: - Override
    
    override func touchInSearchBar() {
        navigationController?.pushViewController(SearchGlobalViewController(), animated: false)
        searchBar.endEditing(true)
    }
    
    override func touchUpInLeftBarButtonItem() {
        AppRouter.pushToChatHistory()
    }
    
    // MARK: - Helper Methods
    
    private func requestAPINewsFeed() {
        dataSource.append(PostFeedSectionModel())
        
        guard let path = Bundle.main.path(forResource: "news_feed", ofType: "json") else {
            fatalError("Not available json")
        }
        
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let json = try! JSON(data: data)
        let feedSectionModels = json.arrayValue.compactMap { (json) -> BaseFeedSectionModel? in
            let model = BaseFeedSectionModel(json: json)
            switch model.feedType {
            case .postFeed:
                return FeedPhotoSectionModel(json: json)
            case .shareFeed:
                return FeedPhotoSectionModel(json: json)
            case .shopShareProduct:
                return ShopProductSectionModel(json: json)
            case .userShareProduct:
                return FeedPhotoSectionModel(json: json)
            }
        }
        
        dataSource.append(contentsOf: feedSectionModels)
        adapter.reloadData(completion: nil)
    }
    
}

// MARK: - ListAdapterDataSource

extension FeedViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return dataSource
    }
    
    func listAdapter(_ listAdapter: ListAdapter,
                     sectionControllerFor object: Any) -> ListSectionController {
        
        if object is PostFeedSectionModel {
            return PostFeedSectionController()
        } else {
            guard let model = object as? BaseFeedSectionModel else {
                return ListSectionController()
            }
            
            switch model.feedType {
            case .postFeed:
                return FeedPhotoSectionController()
            case .shareFeed:
                return FeedPhotoSectionController()
            case .shopShareProduct:
                return ShopProductSectionViewController()
            case .userShareProduct:
                return FeedPhotoSectionController()
            }
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
