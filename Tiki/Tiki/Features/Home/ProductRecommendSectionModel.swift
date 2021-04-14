//
//  ProductRecommendSectionModel.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 3/28/21.
//

import UIKit
import IGListKit
import SwiftyJSON

class ProductRecommendSectionModel: BaseHomeSectionModel {
    
    var data: JSON?
    var productRecommend: ProductRecommendModel?
    required init() {
        super.init()
    }
    
    required init(json: JSON) {
        super.init(json: json)
        self.data = json["data"]
        self.productRecommend = ProductRecommendModel(json: data ?? [])
    }
    
}
