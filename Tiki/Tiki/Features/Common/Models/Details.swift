//
//  Details.swift
//  Tiki
//
//  Created by Bee_MacPro on 11/06/2021.
//

import Foundation

import UIKit
import SwiftyJSON

class Details: NSObject, JSONParsable {

    var uuid: Int                  = 0
    var category: String?          = ""
    var provideByShop: String?     = ""
    var trademark: String?         = ""
    var brandOrigin: String?       = ""
    var useTutorial: String?       = ""
    var madeBy: String?            = ""
    var material: String?          = ""
    var model: String?             = ""
    var vat: String?               = ""
    var gurantee:Int               = 0
    var dictValues: [Int: String?] = [:]
    var dictKeys: [Int: String]    = [:]
    
    required override init() {}
    
    required init(json: JSON) {
        super.init()
        self.uuid           = json["id"].intValue
        self.category       = json["category"].stringValue
        self.provideByShop  = json["provideByShop"].stringValue
        self.trademark      = json["trademark"].stringValue
        self.brandOrigin    = json["brandOrigin"].stringValue
        self.useTutorial    = json["useTutorial"].stringValue
        self.madeBy         = json["madeBy"].stringValue
        self.material       = json["material"].stringValue
        self.model          = json["model"].stringValue
        self.vat            = json["vat"].stringValue
        self.gurantee       = json["gurantee"].intValue
        
        self.toObjectDictionary()
        self.toDictionKeyDetail()
    }
    
    func toObjectDictionary() {
        
        self.dictValues.updateValue(self.category, forKey: 0)
        self.dictValues.updateValue(self.provideByShop, forKey: 1)
        self.dictValues.updateValue(self.trademark, forKey: 2)
        self.dictValues.updateValue(self.brandOrigin, forKey: 3)
        self.dictValues.updateValue(self.useTutorial, forKey: 4)
        self.dictValues.updateValue(self.madeBy, forKey: 5)
        self.dictValues.updateValue(self.material, forKey: 6)
        self.dictValues.updateValue(self.model, forKey: 7)
        self.dictValues.updateValue(self.vat, forKey: 8)
        self.dictValues.updateValue(self.gurantee.description, forKey: 9)
    }
    
    func toDictionKeyDetail() {
        
        self.dictKeys.updateValue("Danh mục", forKey: 0)
        self.dictKeys.updateValue("Cung cấp bởi", forKey: 1)
        self.dictKeys.updateValue("Thương hiệu", forKey: 2)
        self.dictKeys.updateValue("Xuất xứ thương hiệu", forKey: 3)
        self.dictKeys.updateValue("Hướng dẫn", forKey: 4)
        self.dictKeys.updateValue("Xuất xứ", forKey: 5)
        self.dictKeys.updateValue("Chất liệu", forKey: 6)
        self.dictKeys.updateValue("Model", forKey: 7)
        self.dictKeys.updateValue("Hoá đơn VAT", forKey: 8)
        self.dictKeys.updateValue("Bảo hành", forKey: 9)
    }
}

