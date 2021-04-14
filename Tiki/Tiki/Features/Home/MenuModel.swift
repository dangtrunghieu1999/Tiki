//
//  MenuModel.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 4/7/21.
//

import UIKit
import SwiftyJSON

class MenuModel: BaseHomeSectionModel {
    
    var title = ""
    var link  = ""
    var list: [ListMenu] = []
    
    required init() {
        super.init()
    }
    
    required init(json: JSON) {
        super.init(json: json)
        title = json["title"].stringValue
        link  = json["link"].stringValue
        list  = json["list"].arrayValue.map{ ListMenu(json: $0) }
    }
    
}

class ListMenu: BaseHomeSectionModel {
    var title = ""
    var image = ""
    var url   = ""
    
    required init() {
        super.init()
    }
    
    required init(json: JSON) {
        super.init(json: json)
        title = json["title"].stringValue
        image = json["image"].stringValue
        url   = json["url"].stringValue
    }
    
}
