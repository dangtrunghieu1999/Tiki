//
//  HomeViewController.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 2/28/21.
//

import UIKit
import IGListKit
import SwiftyJSON

class HomeViewController: BaseViewController {
    
    // MARK: - Variables
    
    private lazy var adapter: ListAdapter = {
        let updater = ListAdapterUpdater()
        let adapter = ListAdapter(updater: updater,
                                  viewController: self,
                                  workingRangeSize: 4)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        return adapter
    }()
    
    private var dataSource: [BaseHomeSectionModel] = []
    
    // MARK: - UI Elements
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.lightBackground
        collectionView.frame = view.bounds
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItems = [cartBarButtonItem, notifiBarButtonItem]
        navigationItem.titleView = searchBar
        view.addSubview(collectionView)
        requestHomeAPI()
        self.collectionView.contentInset.bottom = self.tabBarController?.tabBar.frame.height ?? 0
        self.tabBarController?.tabBar.isTranslucent = false
    }
    
    override func touchInSearchBar() {
        AppRouter.pushViewToSearchBar(viewController: self)
        searchBar.endEditing(true)
    }
    
    // MARK: - Helper Method
    
    func requestHomeAPI() {
        let endPoint = HomeEndPoint.getAllHome
        self.showLoading()
        
        APIService.request(endPoint: endPoint) { (apiResponse) in
            self.hideLoading()
            let json = apiResponse.data
            let homeSectionModels = json?.arrayValue.compactMap { (json) -> BaseHomeSectionModel? in
                let model = BaseHomeSectionModel(json: json)
                switch model.feedType {
                case .SlideWidget:
                    return BannerFeedSectionModel(json: json)
                case .ShortcutWidget:
                    return MenuFeedSectionModel(json: json)
                case .BannerEventWidget:
                    return BannerEventSectionModel(json: json)
                case .ProductRecommendWidget:
                    return ProductRecommendSectionModel(json: json)
                }
            }
            self.dataSource.append(contentsOf: homeSectionModels!)
            self.adapter.reloadData(completion: nil)
        } onFailure: { (errorResponse) in
            
        } onRequestFail: {
            
        }
    }
}

// MARK: - ListAdapterDataSource

extension HomeViewController: ListAdapterDataSource {
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        
        guard let model = object as? BaseHomeSectionModel else {
            return ListSectionController()
        }
        switch model.feedType {
        case .SlideWidget:
            return BannerFeedSectionController()
        case .ShortcutWidget:
            return MenuFeedSectionViewController()
        case .BannerEventWidget:
            return BannerEventViewController()
        case .ProductRecommendWidget:
            let vc = ProductRecommendViewController()
            vc.delegate = self
            return vc
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return dataSource
    }
    
}

// MARK: - ProductRecommendDelagte

extension HomeViewController: ProductRecommendDelagte {
    func tapProductDetail(product: Product?) {
        AppRouter.pushToProductDetail(product ?? Product())
    }
}
