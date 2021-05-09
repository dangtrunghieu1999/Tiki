//
//  PostFeedSectionModel.swift
//  ZoZoApp
//
//  Created by LAP12852 on 9/21/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit
import IGListKit
import SwiftyJSON

class PostFeedDetailSectionModel: BaseFeedSectionModel {
    
    private var headerInfoModel: FeedHeaderInfoModel = {
        let dict: [String: Any] = ["DisplayName": UserManager.user?.fullName ?? "",
                                   "Content": UserManager.user?.pictureURL ?? ""]
        let model = FeedHeaderInfoModel(json: dict.JSON_Swifty ?? JSON())
        return model
    }()
    
    private (set) var images: [UIImage] = []
    private (set) var postFeedInputStatusModel = PostFeedInputStatusModel()
    
    required init() {
        super.init()
    }
    
    required init(json: JSON) {
        super.init(json: json)
    }
    
    func setFeedImages(_ images: [UIImage]) {
        self.images = images
    }
    
    func setPostFeedInputStatusCell(_ cell: PostFeedInputStatusCollectionViewCell) {
        postFeedInputStatusModel.cell = cell
    }
    
    override func buildAllSection() -> [ListDiffable] {
        var sections = [headerInfoModel, postFeedInputStatusModel]
        let largeSize   = CGSize(width:floor(ScreenSize.SCREEN_WIDTH),
                                 height: ScreenSize.SCREEN_WIDTH * 3 / 4)
        let mediumSize  = CGSize(width: floor(ScreenSize.SCREEN_WIDTH / 2),
                                 height: floor(ScreenSize.SCREEN_WIDTH / 2))
        let smallSize   = CGSize(width: ScreenSize.SCREEN_WIDTH / 3,
                                 height: ScreenSize.SCREEN_WIDTH / 3)
        
        let numberImages = images.count
        var allImageCellModel = images.map({ FeedAutoSizeImageCellModel(image: $0) })
        allImageCellModel = Array(allImageCellModel.prefix(5))
        
        if numberImages == 1 {
            allImageCellModel[0].estimateCellSize = CGSize(width: ScreenSize.SCREEN_WIDTH,
                                                           height: ScreenSize.SCREEN_WIDTH)
        } else if numberImages == 2 {
            allImageCellModel[0].estimateCellSize = largeSize
            allImageCellModel[1].estimateCellSize = largeSize
        } else if numberImages == 3 {
            allImageCellModel[0].estimateCellSize = largeSize
            allImageCellModel[1].estimateCellSize = mediumSize
            allImageCellModel[2].estimateCellSize = mediumSize
        } else if numberImages == 4 {
            allImageCellModel[0].estimateCellSize = largeSize
            allImageCellModel[1].estimateCellSize = smallSize
            allImageCellModel[2].estimateCellSize = smallSize
            allImageCellModel[3].estimateCellSize = smallSize
        } else if numberImages >= 5 {
            allImageCellModel[0].estimateCellSize = mediumSize
            allImageCellModel[1].estimateCellSize = mediumSize
            allImageCellModel[2].estimateCellSize = smallSize
            allImageCellModel[3].estimateCellSize = smallSize
            allImageCellModel[4].estimateCellSize = smallSize
            allImageCellModel[4].numberSeeMoreImages = (numberImages - 5)
        }
        
        sections.append(contentsOf: allImageCellModel)
        
        return sections
    }
    
}
