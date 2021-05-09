//
//  ShopProductSectionViewController.swift
//  ZoZoApp
//
//  Created by LAP12852 on 10/27/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit
import IGListKit

class ShopProductSectionViewController: ListBindingSectionController<ShopProductSectionModel> {
    override init() {
        super.init()
        dataSource = self
    }
}

// MARK: - ListBindingSectionControllerDataSource

extension ShopProductSectionViewController: ListBindingSectionControllerDataSource {
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>,
                           viewModelsFor object: Any) -> [ListDiffable] {
        guard let sectionModel = object as? ShopProductSectionModel else { return [] }
        return sectionModel.buildAllSection()
    }
    
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>,
                           cellForViewModel viewModel: Any,
                           at index: Int) -> UICollectionViewCell & ListBindable {
        
        guard let collectionViewContext = collectionContext else {
            return FeedHeaderInfoCollectionViewCell()
        }
        
        var className: AnyClass
        
        switch viewModel {
        case is FeedHeaderInfoModel:
            className = FeedHeaderInfoCollectionViewCell.self
            break
            
        case is FeedProductInformationCellModel:
            className = FeedProductInformationCollectionViewCell.self
            
        case is FeedSectionSeparatorModel:
            className = FeedSectionSecparatorCollectionViewCell.self
            break
            
        case is FeedAutoSizeImageCellModel:
            className = FeedAutoSizeImageCollectionViewCell.self
            break
            
        case is FeedLikeShareModel:
            className = FeedLikeShareCollectionViewCell.self
            break
            
        default:
            className = FeedHeaderInfoCollectionViewCell.self
        }
        
        let cell = collectionViewContext.dequeueReusableCell(of: className, for: self, at: index)
        guard let feedCell = cell as? UICollectionViewCell & ListBindable else {
            return FeedHeaderInfoCollectionViewCell()
        }
        
        return feedCell
    }
    
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>,
                           sizeForViewModel viewModel: Any, at index: Int) -> CGSize {
        guard let setionModel = viewModel as? BaseFeedSectionModel else {
            return .zero
        }
        
        return setionModel.cellSize()
    }
}
