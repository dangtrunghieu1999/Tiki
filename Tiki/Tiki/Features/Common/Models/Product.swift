//
//  Product.swift
//  ZoZoApp
//
//  Created by MACOS on 6/29/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit
import SwiftyJSON

class Product: NSObject, JSONParsable{
    
    var id: Int?
    var name                = ""
    var createdDate         = Date()
    var createdBy           = Date()
    var modifiedDate        = Date()
    var modifedBy           = Date()
    var unitPrice: Double   = 0.0
    var promoPrice: Double  = 0.0
    var sale                = ""
    var photos: [Photo]     = []
    var detailProduct       = ""
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
    
    /// Use this model to create and edit size
    private (set) var sizeModels: [String] = []
    
    /// Use this model to create and edit color
    private (set) var colorModels: [String] = []
    
    var selectedSize: String?
    var selectedColor: String?
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
        detailProduct       = json["description"].stringValue
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
}

// MARK: - Update

extension Product {
    func addNewSize(size: String) {
        sizeModels.append(size)
    }
    
    func removeSize(at index: Int) {
        if index < sizeModels.count {
            sizeModels.remove(at: index)
        }
    }
    
    func addNewColor(color: String) {
        colorModels.append(color)
    }
    
    func removeColor(at index: Int) {
        if index < colorModels.count {
            colorModels.remove(at: index)
        }
    }
    
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
        
        
        
        dict["Status"]              = status
        dict["Comments"]            = comments.map { $0.toDictionary() }
        dict["Photos"]              = photos.map { $0.toDictionary() }
        
        // Add Size params
        var newSize = ""
        for (index, size) in sizeModels.enumerated() {
            if index == 0 {
                newSize += size
            } else {
                newSize += ",\(size)"
            }
        }
        
        dict["Sizes"] = newSize
        
        // Add Color params
        var newColor = ""
        for (index, color) in colorModels.enumerated() {
            if index == 0 {
                newColor += color
            } else {
                newColor += ";\(color)"
            }
        }
        
        dict["Colors"] = newColor;
        
        return dict
    }
    
    func toOrderDictionary() -> [String: Any] {
        return ["ProductId": id ?? 0,
                "PromoPrice": promoPrice,
                "Quantity": quantity,
                "TotalAmount": totalMoney,
                "Discount": "",
                "Name": name,
                "UnitPrice": unitPrice,
                "ColorSelected": selectedColor ?? "",
                "SizeSelected": selectedSize ?? ""]
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
    
    var isSelectSize: Bool {
        return !sizeModels.isEmpty && selectedSize != nil && selectedSize != ""
    }
    
    var isSelectColor: Bool {
        return !colorModels.isEmpty && selectedColor != nil && selectedColor != ""
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
