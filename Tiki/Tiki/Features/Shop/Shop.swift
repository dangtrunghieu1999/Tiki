//
//  Shop.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 3/13/21.
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
        id              = json["id"].intValue
        code            = json["code"].stringValue
        name            = json["name"].stringValue
        displayName     = json["displayName"].stringValue
        address         = json["address"].stringValue
        mobile          = json["mobile"].stringValue
        hotline         = json["hotline"].stringValue
        cardImage       = json["cardImage"].stringValue
        avatar          = json["avatar"].stringValue
        map             = json["map"].stringValue
        website         = json["website"].stringValue
        countOrdered    = json["countOrdered"].intValue
        totalNewOrder   = json["totalNewOrders"].intValue
        totalFollows    = json["totalFollows"].intValue
        userId          = json["userId"].stringValue
        provinceId      = json["provinceId"].intValue
        provinceName    = json["provinceName"].stringValue
        districtId      = json["districtId"].intValue
        districtName    = json["districtName"].stringValue
        wardId          = json["wardId"].intValue
        wardName        = json["wardName"].stringValue
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
