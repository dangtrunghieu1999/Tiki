//
//  InfomationSection.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 4/13/21.
//

import UIKit
import IGListKit
import SwiftyJSON

class InfomationSectionModel: BaseProductSectionModel {
    
    var data: JSON?
    var productDetail: Product?
    
    required init() {
        super.init()
    }
    
    required init(json: JSON) {
        super.init(json: json)
        self.data = json["data"]
        self.productDetail = Product(json: data ?? [])
    }
    
}
