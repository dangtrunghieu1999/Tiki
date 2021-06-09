//
//  Menu.swift
//  Tiki
//
//  Created by Bee_MacPro on 02/06/2021.
//

import SwiftyJSON

class Categories: NSObject, JSONParsable {
    
//    private var identifier: String = UUID().uuidString
    
    var uuid:  Int?              = 0
    var name:  String?           = ""
    var image: String?           = ""
    var parentId: Int?           = 0
    var subCategories: [Categories]     = []
    
    required override init() {}
    required init(json: JSON) {
        
        self.uuid           = json["id"].intValue
        self.name           = json["name"].stringValue
        self.image          = json["image"].stringValue
        self.subCategories  = json["subCategories"].arrayValue.map {Categories(json: $0)}
    }
}


