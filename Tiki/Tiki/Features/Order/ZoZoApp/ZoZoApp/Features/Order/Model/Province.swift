//
//  Province.swift
//  ZoZoApp
//
//  Created by LAP12852 on 8/25/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit
import SwiftyJSON

class Province: NSObject, NSCoding, JSONParsable {
    var id      = 0
    var code    = ""
    var name    = ""
    
    required override init() {}
    
    required init(json: JSON) {
        id      = json["Id"].intValue
        code    = json["Code"].stringValue
        name    = json["Name"].stringValue
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "Id")
        aCoder.encode(code, forKey: "Code")
        aCoder.encode(name, forKey: "Name")
    }
    
    required init?(coder aDecoder: NSCoder) {
        id   = aDecoder.decodeInteger(forKey: "Id")
        code = aDecoder.decodeObject(forKey: "Code") as? String ?? ""
        name = aDecoder.decodeObject(forKey: "Name") as? String ?? ""
    }
    
}
