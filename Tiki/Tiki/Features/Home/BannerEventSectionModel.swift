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
    var eventModel: EventModel?
    required init() {
        super.init()
    }
    
    required init(json: JSON) {
        super.init(json: json)
        self.data = json["data"]
        self.eventModel = EventModel(json: data ?? [])
    }
}
