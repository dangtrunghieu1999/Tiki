//
//  Category.swift
//  ZoZoApp
//
//  Created by MACOS on 7/5/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit
import SwiftyJSON

class Category: NSObject, JSONParsable {

    var id = 0
    var name = ""
    var desciption = ""
    var photoURL = ""
    var parentId: Int?
    var icon = ""
    var children: Int?
    
    required override init() {}
    
    required init(json: JSON) {
        id = json["Id"].intValue
        name = json["Name"].stringValue
        desciption = json["Description"].stringValue
        photoURL = json["PhotoUrl"].stringValue
        parentId = json["ParentId"].int
        icon = json["Icon"].stringValue
        children = json["children"].int
    }
    
}
