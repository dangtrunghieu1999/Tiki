//
//  Ward.swift
//  ZoZoApp
//
//  Created by LAP12852 on 8/25/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit
import SwiftyJSON

class Ward: NSObject, NSCoding, JSONParsable {
    var id          = 0
    var provinceId  = 0
    var districtId  = 0
    var prefix      = ""
    var name        = ""
    
    required override init() {}
    
    required init(json: JSON) {
        id              = json["Id"].intValue
        provinceId      = json["ProvinceId"].intValue
        districtId      = json["DistrictId"].intValue
        prefix          = json["Prefix"].stringValue
        name            = json["Name"].stringValue
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "Id")
        aCoder.encode(provinceId, forKey: "ProvinceId")
        aCoder.encode(districtId, forKey: "DistrictId")
        aCoder.encode(prefix, forKey: "Prefix")
        aCoder.encode(name, forKey: "Name")
    }
    
    required init?(coder aDecoder: NSCoder) {
        id   = aDecoder.decodeInteger(forKey: "Id")
        provinceId = aDecoder.decodeInteger(forKey: "ProvinceId")
        districtId = aDecoder.decodeInteger(forKey: "DistrictId")
        prefix = aDecoder.decodeObject(forKey: "Prefix") as? String ?? ""
        name = aDecoder.decodeObject(forKey: "Name") as? String ?? ""
    }
    
}
