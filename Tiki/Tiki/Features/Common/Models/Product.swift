//
//  Product.swift
//  ZoZoApp
//
//  Created by MACOS on 6/29/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit
import SwiftyJSON

class Product: NSObject, JSONParsable, NSCopying{
    
    var id: Int?
    var name                = ""
    var createdDate         = Date()
    var createdBy           = Date()
    var modifiedDate        = Date()
    var modifedBy           = Date()
    var unitPrice: Double   = 0.0
    var promoPrice: Double  = 0.0
    var photos: [Photo]     = []
    var descriptions        = ""
    var rating:Double       = 0.0
    var status              = 0
    var number_comment      = 0
    var promotion_percent   = 0
    var comments: [Comment] = []
    var shopId: Int?
    var shopName            = ""
    var shopAvatar          = ""
    var parameter: [String] = []
    var json                = JSON()
    
    var quantity = 1
    
    var defaultImage: String {
        return photos.first?.url ?? ""
    }
    
    var discount: Int {
        return Int(unitPrice - promoPrice / unitPrice) * 100
    }
    
    required override init() {}
    
    required init(json: JSON) {
        super.init()
        self.json = json
        id                  = json["id"].int
        name                = json["name"].stringValue
        photos              = json["photos"].arrayValue.map { Photo(json: $0) }
        descriptions        = json["descriptions"].stringValue
        unitPrice           = json["unit_price"].doubleValue
        promoPrice          = json["promotion_price"].doubleValue
        rating              = json["rating"].doubleValue
        number_comment      = json["number_comment"].intValue
        promotion_percent   = json["promotion_percent"].intValue
        shopName            = json["shopName"].stringValue
        shopAvatar          = json["shopAvatar"].stringValue
        shopId              = json["shopId"].intValue
        parameter           = json["parameter"].arrayValue.map{$0.stringValue}
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Product(json: json)
        copy.name = name
        copy.promoPrice = promoPrice
        copy.unitPrice = unitPrice
        return copy
    }
}

// MARK: - Update

extension Product {
    
    func addNewPhoto(photos: [Photo]) {
        self.photos.append(contentsOf: photos)
    }
    
    func addNewPhoto(photo: Photo) {
        photos.append(photo)
    }
    
    func removePhoto(at index: Int) {
        if index < photos.count {
            photos.remove(at: index)
        }
    }
}

// MARK: - To Dict

extension Product {
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        
        if let id = id {
            dict["id"] = id.description
        }
        
        dict["name"]                = name
        dict["UnitPrice"]           = unitPrice
        dict["PromoPrice"]          = promoPrice
        
        dict["Comments"]            = comments.map { $0.toDictionary() }
        dict["Photos"]              = photos.map { $0.toDictionary() }
        
        return dict
    }
    
    func toOrderDictionary() -> [String: Any] {
        return ["ProductId": id ?? 0,
                "PromoPrice": promoPrice,
                "Quantity": quantity,
                "TotalAmount": totalMoney,
                "Discount": "",
                "Name": name,
                "UnitPrice": unitPrice]
    }
}

// MARK: - Product Detail Helper

extension Product {
    var numberCommentInProductDetail: Int {
        return commentInProductDetail.count
    }
    
    var commentInProductDetail: [Comment] {
        if comments.count >= 2 {
            return Array(comments.prefix(2))
        } else if let firstComment = comments.first, let firstChildComment = firstComment.commentChild.first {
            return [firstComment, firstChildComment]
        } else if let firstComment = comments.first {
            return [firstComment]
        } else {
            return []
        }
    }
}


// MARK: - Cart Helper

extension Product {
    var finalPrice: Double {
        if promoPrice != 0 {
            return promoPrice
        } else {
            return unitPrice
        }
    }
    
    var totalMoney: Double {
        return Double(quantity) * finalPrice
    }
}
