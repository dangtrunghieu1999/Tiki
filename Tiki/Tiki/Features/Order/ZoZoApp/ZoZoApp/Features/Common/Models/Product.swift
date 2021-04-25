//
//  Product.swift
//  ZoZoApp
//
//  Created by MACOS on 6/29/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit
import SwiftyJSON

class Product: NSObject, JSONParsable, NSCopying {
    
    var id: Int?
    var code                = ""
    var name                = ""
    var alias               = ""
    var unitPrice: Double   = 0.0
    var promoPrice: Double  = 0.0
    var quantityPerUnit     = ""
    var shortDescription    = ""
    var detail              = ""
    var warranty            = 0
    var topHot              = Date()
    var viewCount           = 0
    var categoryId: Int?
    var categoryName: String?
    var shopId: Int?
    var shopName            = ""
    var shopAvatar          = ""
    var supplierId: Int?
    var supplierName        = ""
    var colors              = ""
    var countComments       = 0
    var countFollow         = 0
    var countLike           = 0
    var countRating         = 0
    var countShare          = 0
    var photos: [Photo]     = []
    var remainOfRefresh     = 0
    var sizes               = ""
    var status              = 0
    var userFollow          = false
    var userLike            = false
    var userRating          = false
    var authentics          = true
    var weight: Double      = 0.0
    var comments: [Comment] = []
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
        
        alias           = json["Alias"].stringValue
        categoryId      = json["CategoryId"].int
        categoryName    = json["CategoryName"].string
        code            = json["Code"].stringValue
        colors          = json["Colors"].stringValue
        countComments   = json["CountComments"].intValue
        countFollow     = json["CountFollow"].intValue
        countLike       = json["CountLike"].intValue
        countRating     = json["CountRating"].intValue
        countShare      = json["CountShare"].intValue
        detail          = json["Detail"].stringValue
        id              = json["Id"].int
        name            = json["Name"].stringValue
        photos          = json["Photos"].arrayValue.map { Photo(json: $0) }
        promoPrice      = json["PromoPrice"].doubleValue
        quantityPerUnit = json["QuantityPerUnit"].stringValue
        remainOfRefresh = json["RemainOfRefresh"].intValue
        shopId          = json["ShopId"].int
        shopName        = json["ShopName"].stringValue
        shortDescription = json["ShortDescription"].stringValue
        sizes           = json["Sizes"].stringValue
        status          = json["Status"].intValue
        supplierId      = json["SupplierId"].intValue
        supplierName    = json["SupplierName"].stringValue
        topHot          = json["TopHot"].dateValue
        unitPrice       = json["UnitPrice"].doubleValue
        userFollow      = json["UserFollow"].boolValue
        userLike        = json["UserLike"].boolValue
        userRating      = json["UserRating"].boolValue
        viewCount       = json["ViewCount"].intValue
        warranty        = json["Warranty"].intValue
        authentics      = json["Authentics"].boolValue
        weight          = json["Weight"].doubleValue
        shopAvatar      = json["ShopAvatar"].stringValue
        weight          = json["Weight"].doubleValue
        comments        = json["Comments"].arrayValue.map { Comment(json: $0) }
        
        mapSizeAndColor()
    }
    
    private func mapSizeAndColor() {
        if sizes != "" {
            sizeModels = sizes.components(separatedBy: ";")
            if sizeModels.isEmpty {
                sizeModels = sizes.components(separatedBy: ",")
            }
        }
        
        if colors != "" {
            colorModels = colors.components(separatedBy: ";")
            if colorModels.isEmpty {
                colorModels = colors.components(separatedBy: ",")
            }
        }
        
        if self.colors.contains(",") {
            colorModels = colors.components(separatedBy: ",")
        }
        
        if self.sizes.contains(",") {
            sizeModels = sizes.components(separatedBy: ",")
        }
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Product(json: json)
        copy.selectedColor = selectedColor
        copy.selectedSize = selectedSize
        copy.name = name
        copy.sizes = sizes
        copy.colors = colors
        copy.promoPrice = promoPrice
        copy.unitPrice = unitPrice
        return copy
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
            dict["Id"] = id.description
        }
        
        dict["Code"]                = code
        dict["Name"]                = name
        dict["Alias"]               = alias
        dict["UnitPrice"]           = unitPrice
        dict["PromoPrice"]          = promoPrice
        dict["QuantityPerUnit"]     = quantityPerUnit
        dict["ShortDescription"]    = shortDescription
        dict["Detail"]              = detail
        dict["Warranty"]            = warranty
        dict["TopHot"]              = topHot.desciption(by: .fullDateServerFormat)
        dict["ViewCount"]           = viewCount
        dict["CategoryId"]          = categoryId
        dict["CategoryName"]        = categoryName
        dict["ShopId"]              = shopId
        dict["ShopName"]            = shopName
        dict["SupplierId"]          = supplierId
        dict["SupplierName"]        = supplierName
        dict["Authentics"]          = authentics
        dict["UserLike"]            = userLike
        dict["UserFollow"]          = userFollow
        dict["UserRating"]          = userRating
        dict["CountLike"]           = countLike
        dict["CountShare"]          = countShare
        dict["CountFollow"]         = countFollow
        dict["RemainOfRefresh"]     = remainOfRefresh
        dict["CountRating"]         = countRating
        dict["CountComments"]       = countComments
        dict["Status"]              = status
        dict["Weight"]              = weight
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
                "Code": code,
                "UnitPrice": unitPrice,
                "ShortDescription": shortDescription,
                "Detail": detail,
                "Warranty": warranty,
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
