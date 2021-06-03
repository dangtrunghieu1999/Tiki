//
//  Banner.swift
//  Tiki
//
//  Created by Bee_MacPro on 02/06/2021.
//

import SwiftyJSON

class Banner: NSObject, JSONParsable {
    
    var uuid: Int?              = 0
    var name: String?           = ""
    var url : String?           = ""
    
    required override init() {}
    
    required init(json: JSON) {
        
        self.uuid = json["id"].intValue
        self.name = json["name"].stringValue
        self.url  = json["url"].stringValue
    }
    
}
