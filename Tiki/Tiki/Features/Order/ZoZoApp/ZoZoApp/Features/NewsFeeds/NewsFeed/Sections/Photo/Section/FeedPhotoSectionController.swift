//
//  FeedPhotoSectionController.swift
//  ZoZoApp
//
//  Created by LAP12852 on 9/2/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit
import IGListKit

class FeedPhotoSectionController: ListBindingSectionController<FeedPhotoSectionModel> {
    
    override init() {
        super.init()
        dataSource = self
    }
    
}

// MARK: - ListBindingSectionControllerDataSource

extension FeedPhotoSectionController: ListBindingSectionControllerDataSource {
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>,
                           viewModelsFor object: Any) -> [ListDiffable] {
        guard let imageSectionModel = object as? FeedPhotoSectionModel else {
            return []
        }
        
        return imageSectionModel.buildAllSection()
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
        case is FeedAutoSizeImageCellModel:
            className = FeedAutoSizeImageCollectionViewCell.self
            break
            
        case is FeedStatusMessageModel:
            className = FeedStatusMessageCollectionViewCell.self
            break
            
        case is FeedSectionSeparatorModel:
            className = FeedSectionSecparatorCollectionViewCell.self
            break
            
        case is FeedLikeShareModel:
            className = FeedLikeShareCollectionViewCell.self
            break
        
        default:
            return FeedHeaderInfoCollectionViewCell()
        }
        
        let cell = collectionViewContext.dequeueReusableCell(of: className, for: self, at: index)
        guard let feedCell = cell as? UICollectionViewCell & ListBindable else {
            return FeedHeaderInfoCollectionViewCell()
        }
        
        return feedCell
    }
    
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>,
                           sizeForViewModel viewModel: Any, at index: Int) -> CGSize {
        guard let feedModel = viewModel as? BaseFeedSectionModel else {
            return .zero
        }
        
        return feedModel.cellSize()
    }
}
