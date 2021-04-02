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
                                  workingRangeSize: 0)
        adapter.collectionView = collectionView
        return adapter
    }()
    
    private var dataSource: [BaseHomeSectionModel] = []
    
    
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
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        requestHomeAPI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    
    // MARK: - Helper Method
    
    func requestHomeAPI() {
        guard let path = Bundle.main.path(forResource: "Home", ofType: "json") else {
            fatalError("Not available json")
        }
        
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let json = try! JSON(data: data)
        
        let homeSectionModels = json.arrayValue.compactMap { (json) -> BaseHomeSectionModel? in
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
        
        dataSource.append(contentsOf: homeSectionModels)
        adapter.reloadData(completion: nil)
    }
}


extension HomeViewController: ListAdapterDataSource {
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        
        guard let model = object as? BaseHomeSectionModel else {
            return ListSectionController()
        }
        switch model.feedType {
        case .SlideWidget:
            return BannerFeedSectionController()
        case .ShortcutWidget:
            return MenuFeedViewController()
        case .BannerEventWidget:
            return BannerEventViewController()
        case .ProductRecommendWidget:
            return ProductRecommendViewController()
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return dataSource
    }

}
