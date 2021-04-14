//
//  BannerModel.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 4/2/21.
//

import UIKit
import SwiftyJSON
class BannerModel: BaseHomeSectionModel {
    
    var title = ""
    var link  = ""
    var list: [ListBanner] = []
    
    required init() {
        super.init()
    }
    
    required init(json: JSON) {
        super.init(json: json)
        title = json["title"].stringValue
        link  = json["link"].stringValue
        list  = json["list"].arrayValue.map{ ListBanner(json: $0) }
    }
    
}

class ListBanner: BaseHomeSectionModel {
    
    var title = ""
    var image = ""
    
    required init() {
        super.init()
    }
    
    required init(json: JSON) {
        super.init(json: json)
        title = json["title"].stringValue
        image = json["image"].stringValue
    }
    
}
