//
//  District.swift
//  ZoZoApp
//
//  Created by LAP12852 on 8/25/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit
import SwiftyJSON

class District: NSObject, NSCoding, JSONParsable {

    var code        = ""
    var province    = ""
    var name        = ""
    
    required override init() {}
    
    required init(json: JSON) {
        code      = json["code"].stringValue
        province  = json["province"].stringValue
        name      = json["name"].stringValue
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(code, forKey: "code")
        aCoder.encode(province, forKey: "province")
        aCoder.encode(name, forKey: "name")
    }
    
    required init?(coder aDecoder: NSCoder) {
        province = aDecoder.decodeObject(forKey: "province") as? String ?? ""
        code     = aDecoder.decodeObject(forKey: "code") as? String ?? ""
        name     = aDecoder.decodeObject(forKey: "name") as? String ?? ""
    }
    
}
