//
//  BaseHomeSectionModel.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 3/28/21.
//

import UIKit
import IGListKit
import SwiftyJSON

class BaseHomeSectionModel: NSObject, JSONParsable {
    var id:         String?
    var diffID:     String              = Ultilities.randomStringKey()
    var cellDiffID: String?
    var feedType: HomeFeedType          = .SlideWidget
    
    required override init() {
        super.init()
    }
    
    required init(json: JSON) {
        feedType            = HomeFeedType(rawValue: json["type"].intValue) ?? .SlideWidget
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

extension BaseHomeSectionModel: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return self
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if let homeFeedModel = object as? BaseHomeSectionModel {
            return getDiffID() == homeFeedModel.getDiffID()
        } else {
            return false
        }
    }
}
