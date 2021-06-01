//
//  BannerEventSectionModel.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 3/28/21.
//

import UIKit
import IGListKit
import SwiftyJSON


class BannerEventSectionModel: BaseHomeSectionModel {
    
    var data: JSON?
    var uuid: Int       = 0
    var name: String    = ""
    var url:  String    = ""

    required init() {
        super.init()
    }
    
    required init(json: JSON) {
        super.init(json: json)
        self.data = json["data"]
        self.uuid = data?["id"].intValue ?? 0
        self.name = data?["name"].stringValue ?? ""
        self.url  = data?["url"].stringValue ?? ""
    }
}
