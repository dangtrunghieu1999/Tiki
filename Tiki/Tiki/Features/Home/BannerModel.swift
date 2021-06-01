//
//  BannerModel.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 4/2/21.
//

import UIKit
import SwiftyJSON
class BannerModel: BaseHomeSectionModel {
    
    var idHome    = 0
    var name      = ""
    var url       = ""
    
    
    required init() {
        super.init()
    }
    
    required init(json: JSON) {
        super.init(json: json)
        
        idHome    = json["id"].intValue
        name      = json["name"].stringValue
        url       = json["url"].stringValue
    }
    
}
