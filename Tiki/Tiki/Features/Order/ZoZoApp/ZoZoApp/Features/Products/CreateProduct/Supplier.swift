//
//  Supplier.swift
//  ZoZoApp
//
//  Created by LAP12852 on 8/5/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit
import SwiftyJSON

class Supplier: NSObject, JSONParsable {
    var id: Int     = 0
    var name        = ""
    var address     = ""
    var logo        = ""
    var phone       = ""
    
    required override init() {}
    
    required init(json: JSON) {
        id      = json["Id"].intValue
        name    = json["Name"].stringValue
        address = json["Address"].stringValue
        logo    = json["Logo"].stringValue
        phone   = json["Phone"].stringValue
    }
    
}
