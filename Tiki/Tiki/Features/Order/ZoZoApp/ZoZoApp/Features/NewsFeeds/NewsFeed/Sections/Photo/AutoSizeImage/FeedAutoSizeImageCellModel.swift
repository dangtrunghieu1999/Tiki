//
//  FeedAutoSizeImageCellModel.swift
//  ZoZoApp
//
//  Created by LAP12852 on 9/2/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit
import SwiftyJSON

class FeedAutoSizeImageCellModel: BaseFeedSectionModel {
    
    /// Width / Height
    var imageRatio: CGFloat     = 1
    var imageURL                = ""
    var image: UIImage?
    var estimateCellSize: CGSize?
    var numberSeeMoreImages     = 0
    
    required init() {
        super.init()
    }
    
    required init(json: JSON) {
        super.init(json: json)
        imageURL = json["url"].stringValue
    }
    
    convenience init(image: UIImage?) {
        self.init()
        self.image = image
    }
    
    override func cellSize() -> CGSize {
        if let cellSize = estimateCellSize {
            return cellSize
        } else {
            return CGSize(width: ScreenSize.SCREEN_WIDTH, height: ScreenSize.SCREEN_WIDTH * imageRatio)
        }
        
    }
    
}
