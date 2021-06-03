//
//  Menu.swift
//  Tiki
//
//  Created by Bee_MacPro on 02/06/2021.
//

import SwiftyJSON

class Menu: NSObject, JSONParsable {
    
    var uuid:  Int?              = 0
    var name:  String?           = ""
    var image: String?           = ""
    
    required override init() {}
    required init(json: JSON) {
       
        self.uuid   = json["id"].intValue
        self.name   = json["name"].stringValue
        self.image  = json["image"].stringValue
    }
}
