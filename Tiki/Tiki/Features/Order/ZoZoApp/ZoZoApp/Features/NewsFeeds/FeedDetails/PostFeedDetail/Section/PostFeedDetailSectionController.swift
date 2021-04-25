//
//  PostFeedDetailSectionController.swift
//  ZoZoApp
//
//  Created by LAP12852 on 9/21/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit
import IGListKit

class PostFeedDetailSectionController: ListBindingSectionController<PostFeedDetailSectionModel> {
    override init() {
        super.init()
        dataSource = self
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handlePostFeedInputStatusChangeHeight),
                                               name: Notification.Name.updateFostFeedInputStatusCellSize,
                                               object: nil)
        
    }
    
    @objc private func handlePostFeedInputStatusChangeHeight() {
        collectionContext?.invalidateLayout(for: self, completion: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: Notification.Name.updateFostFeedInputStatusCellSize,
                                                  object: nil)
    }
}

// MARK: - ListBindingSectionControllerDataSource

extension PostFeedDetailSectionController: ListBindingSectionControllerDataSource {
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>,
                           viewModelsFor object: Any) -> [ListDiffable] {
        guard let model = object as? PostFeedDetailSectionModel else {
            return []
        }
        return model.buildAllSection()
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
        case is PostFeedInputStatusModel:
            className = PostFeedInputStatusCollectionViewCell.self
        case is FeedAutoSizeImageCellModel:
            className = FeedAutoSizeImageCollectionViewCell.self
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
