//
//  EventModel.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 4/8/21.
//

import UIKit
import SwiftyJSON

class EventModel: BaseHomeSectionModel {
    
    var title = ""
    var link  = ""
    var list: [ListEvent] = []
    
    required init() {
        super.init()
    }
    
    required init(json: JSON) {
        super.init(json: json)
        title = json["title"].stringValue
        link  = json["link"].stringValue
        list  = json["list"].arrayValue.map{ ListEvent(json: $0) }
    }
}

class ListEvent: BaseHomeSectionModel {
    var image = ""
    var url   = ""
    
    required init() {
        super.init()
    }
    
    required init(json: JSON) {
        super.init(json: json)
        image = json["image"].stringValue
        url   = json["url"].stringValue
    }
    
}
