//
//  BannerFeedSectionModel.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 3/28/21.
//

import UIKit
import IGListKit
import SwiftyJSON

class BannerFeedSectionModel: BaseHomeSectionModel {
    
    var data: JSON?
    var bannerModel:  [BannerModel] = []
    
    required init() {
        super.init()
    }
    
    required init(json: JSON) {
        super.init(json: json)
        self.data = json["data"]
        self.bannerModel = data?.arrayValue.map{ BannerModel(json: $0) } ?? []
    }

}



