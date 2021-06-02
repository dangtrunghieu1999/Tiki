//
//  Menu.swift
//  Tiki
//
//  Created by Bee_MacPro on 02/06/2021.
//

import SwiftyJSON

class Menu {
    var data:  JSON?
    var uuid:  Int?              = 0
    var name:  String?           = ""
    var image: String?           = ""
    
    init(json: JSON?) {
        self.data   = json?["data"]
        self.uuid   = data?["id"].intValue
        self.name   = data?["name"].stringValue
        self.image  = data?["image"].stringValue
    }
}
