//
//  ProductRecommend.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 4/9/21.
//

import UIKit
import SwiftyJSON

class ProductRecommendModel: BaseHomeSectionModel {
    
    var title = ""
    var link  = ""
    var list: [ListRecommend] = []
    
    required init() {
        super.init()
    }
    
    required init(json: JSON) {
        super.init(json: json)
        title = json["title"].stringValue
        link  = json["link"].stringValue
        list  = json["list"].arrayValue.map{ ListRecommend(json: $0) }
    }
}

class ListRecommend: BaseHomeSectionModel {
    var name              = ""
    var price             = 0.0
    var final_price       = 0.0
    var promotion_percent = 0
    var image             = ""
    var product_url       = ""
    var product_id        = ""
    
    
    required init() {
        super.init()
    }
    
    required init(json: JSON) {
        super.init(json: json)
        name              = json["name"].stringValue
        price             = json["price"].doubleValue
        final_price       = json["final_price"].doubleValue
        promotion_percent = json["promotion_percent"].intValue
        image             = json["img_url_mob"].stringValue
        product_url       = json["product_url"].stringValue
        product_id        = json["product_id"].stringValue
    }
    
}
