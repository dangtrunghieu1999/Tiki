//
//  ShopProductSectionModel.swift
//  ZoZoApp
//
//  Created by LAP12852 on 10/27/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit
import IGListKit
import SwiftyJSON

class ShopProductSectionModel: BaseFeedSectionModel {
    private (set) var headerInfoModel              = FeedHeaderInfoModel()
    private (set) var photoModel                   = FeedAutoSizeImageCellModel()
    private (set) var productInformation           = FeedProductInformationCellModel()
    private (set) var sectionSeparatorModel        = FeedSectionSeparatorModel()
    private (set) var likeShareModel               = FeedLikeShareModel()
    
    required init(json: JSON) {
        super.init(json: json)
        photoModel                  = FeedAutoSizeImageCellModel(json: json)
        photoModel.estimateCellSize = CGSize(width: ScreenSize.SCREEN_WIDTH,
                                             height: ScreenSize.SCREEN_WIDTH * 0.75)
        headerInfoModel             = FeedHeaderInfoModel(json: json)
    }
    
    required init() {
        super.init()
    }
    
    override func buildAllSection() -> [ListDiffable] {
        var allSections: [ListDiffable] = [headerInfoModel]
        
        allSections.append(photoModel)
        allSections.append(productInformation)
        allSections.append(contentsOf: [likeShareModel, sectionSeparatorModel])
        
        return allSections
    }
    
}
