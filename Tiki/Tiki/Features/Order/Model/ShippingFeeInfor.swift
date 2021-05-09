//
//  ShippingFeeInfor.swift
//  ZoZoApp
//
//  Created by LAP12852 on 9/20/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit
import SwiftyJSON

class ShippingFeeInfor: NSObject {
    var name                    = ""
    var fee: Double             = 0
    var insuranceFee: Double    = 0
    var delivery                = true
    var includeVAT              = false
    var costId                  = 0
    var deliveryType            = ""
    var deliverDate             = Date()
    
    override init() {
        super.init()
    }
    
    init(forGHTK json: JSON) {
        let jsonData = JSON(json["fee"].object)
        
        name            = jsonData["name"].stringValue
        fee             = jsonData["fee"].doubleValue
        insuranceFee    = jsonData["insurance_fee"].doubleValue
        delivery        = jsonData["delivery"].boolValue
        includeVAT      = jsonData["include_vat"].boolValue
        costId          = jsonData["cost_id"].intValue
        deliveryType    = jsonData["delivery_type"].stringValue
        deliverDate     = jsonData["deliver_date"].stringValue.toDate(with: .shortDateServerFormat)
    }
}
