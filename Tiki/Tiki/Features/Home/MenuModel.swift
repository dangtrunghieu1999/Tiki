//
//  MenuModel.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 4/7/21.
//

import UIKit
import SwiftyJSON

class MenuModel: BaseHomeSectionModel {
    
    var uuid: Int      = 0
    var name           = ""
    var image          = ""
    var parentId: Int  = 0
    
    
    required init() {
        super.init()
    }
    
    required init(json: JSON) {
        super.init(json: json)
        uuid        = json["id"].intValue
        name        = json["name"].stringValue
        image       = json["image"].stringValue
        parentId    = json["parentId"].intValue
    }
}

