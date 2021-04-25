//
//  FeedProductInformationCellModel.swift
//  ZoZoApp
//
//  Created by LAP12852 on 10/27/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit
import SwiftyJSON

class FeedProductInformationCellModel: BaseFeedSectionModel {
    private (set) var product           = Product()
    
    required init(json: JSON) {
        super.init()
        initDummyData()
    }
    
    required init() {
        super.init()
        initDummyData()
    }
    
    private func initDummyData() {
        product.id = 60
        product.name = "MV972 - MacBook Pro 2019 13 Inch Gray i5 2.4/8GB/512GB"
        product.unitPrice = 60000000
        product.promoPrice = 55000000
        product.countRating = 4
    }
    
    override func cellSize() -> CGSize {
        let height = FeedProductInformationCollectionViewCell.estimateHeight(product)
        return CGSize(width: ScreenSize.SCREEN_WIDTH, height: height)
    }
    
}
