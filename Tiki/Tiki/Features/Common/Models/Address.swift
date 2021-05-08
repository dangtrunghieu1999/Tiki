//
//  Address.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 5/8/21.
//

import UIKit
import SwiftyJSON
import Alamofire

class Address: NSObject, JSONParsable {
    var fullName        = ""
    var phoneNumber     = ""
    var address         = ""
    
    required override init() {}
    
    required init(json: JSON) {
        fullName             = json["fullName"].stringValue
        phoneNumber          = json["phoneNumber"].stringValue
        address              = json["address"].stringValue
    }
}
