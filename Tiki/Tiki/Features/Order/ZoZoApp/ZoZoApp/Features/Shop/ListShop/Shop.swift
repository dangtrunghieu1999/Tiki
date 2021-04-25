//
//  Shop.swift
//  ZoZoApp
//
//  Created by MACOS on 6/9/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class Shop: NSObject, JSONParsable {
    var id              : Int?
    var code            = ""
    var name            = ""
    var displayName     = ""
    var address         = ""
    var mobile          = ""
    var hotline         = ""
    var cardImage       = ""
    var avatar          = ""
    var map             = ""
    var website         = ""
    var countOrdered    = 0
    var totalNewOrder   = 0
    var totalFollows    = 0
    var userId          = ""
    var provinceId      = 0
    var provinceName    = ""
    var districtId      = 0
    var districtName    = ""
    var wardId          = 0
    var wardName        = ""
    
    required override init() {}
    
    required init(json: JSON) {
        id              = json["Id"].intValue
        code            = json["Code"].stringValue
        name            = json["Name"].stringValue
        displayName     = json["DisplayName"].stringValue
        address         = json["Address"].stringValue
        mobile          = json["Mobile"].stringValue
        hotline         = json["Hotline"].stringValue
        cardImage       = json["CardImage"].stringValue
        avatar          = json["Avatar"].stringValue
        map             = json["Map"].stringValue
        website         = json["Website"].stringValue
        countOrdered    = json["CountOrdered"].intValue
        totalNewOrder   = json["TotalNewOrders"].intValue
        totalFollows    = json["TotalFollows"].intValue
        userId          = json["UserId"].stringValue
        provinceId      = json["ProvinceId"].intValue
        provinceName    = json["ProvinceName"].stringValue
        districtId      = json["DistrictId"].intValue
        districtName    = json["DistrictName"].stringValue
        wardId          = json["WardId"].intValue
        wardName        = json["WardName"].stringValue
    }
    
    func toDictionary() -> [String: Any] {
        var params: Parameters = ["Code":         code,
                                  "Name":         name,
                                  "DisplayName":  displayName,
                                  "Address":      address,
                                  "Mobile":       mobile,
                                  "Hotline":      hotline,
                                  "CardImage":    cardImage,
                                  "Avatar":       avatar,
                                  "Map":          map,
                                  "Website":      website,
                                  "UserId":       userId,
                                  "CountOrdered": countOrdered,
                                  "TotalNewOrders": totalNewOrder,
                                  "TotalFollows": totalFollows,
                                  "ProvinceId":   provinceId,
                                  "ProvinceName": provinceName,
                                  "DistrictId":   districtId,
                                  "DistrictName": districtName,
                                  "WardId":       wardId,
                                  "WardName":     wardName]
        
        if let id = id {
            params["Id"] = id
        }
        
        return params
    }
    
}

// MARK: - Helper Properties

extension Shop {
    var isOwner: Bool {
        return userId == UserManager.userId
    }
}
