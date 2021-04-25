//
//  BaseNewsFeedModel.swift
//  ZoZoApp
//
//  Created by LAP12852 on 9/2/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit
import IGListKit
import SwiftyJSON

class BaseFeedSectionModel: NSObject, JSONParsable {
    var id:         String?
    var diffID:     String              = Ultilities.randomStringKey()
    var cellDiffID: String?
    var feedType: NewsFeedType          = .postFeed
    var isShared                        = false
    
    required override init() {
        super.init()
    }
    
    required init(json: JSON) {
        feedType            = NewsFeedType(rawValue: json["Type"].intValue) ?? .postFeed
    }
    
    func buildAllSection() -> [ListDiffable] {
        return []
    }
    
    func getDiffID() -> String {
        return id ?? diffID
    }
    
    func cellSize() -> CGSize {
        return .zero
    }
    
}

// MARK: - ListDiffable

extension BaseFeedSectionModel: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return self
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if let newsFeedModel = object as? BaseFeedSectionModel {
            return getDiffID() == newsFeedModel.getDiffID()
        } else {
            return false
        }
    }
}
