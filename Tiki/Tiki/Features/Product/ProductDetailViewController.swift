//
//  ProductViewController.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 4/12/21.
//

import UIKit
import IGListKit
import SwiftyJSON

class ProductDetailViewController: BaseViewController {

    private lazy var adapter: ListAdapter = {
        let updater = ListAdapterUpdater()
        let adapter = ListAdapter(updater: updater,
                                  viewController: self,
                                  workingRangeSize: 4)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        return adapter
    }()
    
    private var dataSource: [BaseProductSectionModel] = []
    
    
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
        view.addSubview(collectionView)
        requestProductDetailAPI()
    }
    
    // MARK: - Helper Method
    
    func requestProductDetailAPI() {
        guard let path = Bundle.main.path(forResource: "ProductDetail", ofType: "json") else {
            fatalError("Not available json")
        }
        
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let json = try! JSON(data: data)
        let productDetailSectionModels = json.arrayValue.compactMap { (json) -> BaseProductSectionModel? in
            let model = BaseProductSectionModel(json: json)
            switch model.productType {
            case .infomation:
                return InfomationSectionModel(json: json)
            case .benefits:
                return InfomationSectionModel(json: json)
            case .preferential:
                return InfomationSectionModel(json: json)
            case .description:
                return InfomationSectionModel(json: json)
            case .recomment:
                return InfomationSectionModel(json: json)
            }
        }
        dataSource.append(contentsOf: productDetailSectionModels)
        adapter.reloadData(completion: nil)
    }
    
    // MARK: - GET API
    
    // MARK: - Layout

}

extension ProductDetailViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return dataSource
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return InfomationSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
}
