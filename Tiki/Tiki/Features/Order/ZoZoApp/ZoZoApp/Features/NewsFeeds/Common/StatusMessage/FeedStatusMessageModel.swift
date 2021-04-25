//
//  NewsFeedContentModel.swift
//  ZoZoApp
//
//  Created by LAP12852 on 9/2/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit
import SwiftyJSON

class FeedStatusMessageModel: BaseFeedSectionModel {
    
    // MARK: - Varibles
    
    var status          = ""
    private var cacheStatusHeight: CGFloat?
    
    // MARK: - Object LifeCycle
    
    required init() {
        super.init()
    }
    
    required init(json: JSON) {
        super.init(json: json)
        status = json["Content"].stringValue
    }
    
    // MARK: - Override methods
    
    override func cellSize() -> CGSize {
        if let height = cacheStatusHeight {
            return CGSize(width: ScreenSize.SCREEN_WIDTH, height: height)
        } else {
            cacheStatusHeight = status.height(withConstrainedWidth: ScreenSize.SCREEN_WIDTH - 32,
                                              font: UIFont.systemFont(ofSize: FontSize.h1.rawValue)) + 12
            return CGSize(width: ScreenSize.SCREEN_WIDTH, height: cacheStatusHeight ?? 0)
        }
    }
    
}

