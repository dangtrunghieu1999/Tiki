//
//  UserRole.swift
//  ZoZoApp
//
//  Created by LAP12852 on 8/14/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit
import SwiftyJSON

class UserRole: NSObject, JSONParsable {
    var user            = User()
    var shopRoles       = [ShopRole]()
    
    required override init() {}
    
    required init(json: JSON) {
        user    = User(json: json)
        let roles = json["ShopRoles"].arrayValue
        shopRoles = roles.map{ ShopRole(json: $0) }
    }
}
