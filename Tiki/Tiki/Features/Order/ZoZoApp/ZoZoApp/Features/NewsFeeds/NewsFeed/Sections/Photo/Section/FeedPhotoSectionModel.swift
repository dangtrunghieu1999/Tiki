//
//  FeedPhotoSectionModel.swift
//  ZoZoApp
//
//  Created by LAP12852 on 9/2/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit
import IGListKit
import SwiftyJSON

class FeedPhotoSectionModel: BaseFeedSectionModel {
    
    private (set) var headerInfoModel              = FeedHeaderInfoModel()
    private (set) var statusMessageModel           = FeedStatusMessageModel()
    private (set) var sectionSeparatorModel        = FeedSectionSeparatorModel()
    private (set) var likeShareModel               = FeedLikeShareModel()
    
    private (set) var allImageCellModel: [FeedAutoSizeImageCellModel] = []
    
    required init() {
        super.init()
    }
    
    required init(json: JSON) {
        super.init(json: json)
        allImageCellModel       = json["PhotosCreate"].arrayValue.map { FeedAutoSizeImageCellModel(json: $0) }
        headerInfoModel         = FeedHeaderInfoModel(from: json, numberPhotos: allImageCellModel.count)
        statusMessageModel      = FeedStatusMessageModel(json: json)
    }
    
    override func buildAllSection() -> [ListDiffable] {
        var allSections: [ListDiffable] = [headerInfoModel]
        
        if statusMessageModel.status != "" {
            allSections.append(statusMessageModel)
        }
        
        if !allImageCellModel.isEmpty {
            if allImageCellModel.count == 1 {
                allImageCellModel[0].estimateCellSize = CGSize(width: ScreenSize.SCREEN_WIDTH,
                                                               height: ScreenSize.SCREEN_WIDTH)
            } else {
                buildImageSections()
            }
            allSections.append(contentsOf: allImageCellModel)
        }
        
        allSections.append(contentsOf: [likeShareModel, sectionSeparatorModel])
        
        return allSections
    }
    
    private func buildImageSections() {
        let largeSize   = CGSize(width:floor(ScreenSize.SCREEN_WIDTH),
                                 height: ScreenSize.SCREEN_WIDTH * 3 / 4)
        let mediumSize  = CGSize(width: floor(ScreenSize.SCREEN_WIDTH / 2),
                                 height: floor(ScreenSize.SCREEN_WIDTH / 2))
        let smallSize   = CGSize(width: ScreenSize.SCREEN_WIDTH / 3,
                                 height: ScreenSize.SCREEN_WIDTH / 3)
        
        let numberImages = allImageCellModel.count
        
        if numberImages == 2 {
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
    }
    
}
