//
//  BasProductSectionModel.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 4/13/21.
//

import UIKit
import IGListKit
import SwiftyJSON

class BaseProductSectionModel: NSObject, JSONParsable {
    var id:         String?
    var diffID:     String              = Ultilities.randomStringKey()
    var cellDiffID: String?
    var productType: ProductDetailType     = .infomation
    
    
    required override init() {
        super.init()
    }
    
    required init(json: JSON) {
        productType         = ProductDetailType(rawValue: json["type"].stringValue) ?? .infomation
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

extension BaseProductSectionModel: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return self
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if let productDetailModel = object as? BaseProductSectionModel {
            return getDiffID() == productDetailModel.getDiffID()
        } else {
            return false
        }
    }
}

