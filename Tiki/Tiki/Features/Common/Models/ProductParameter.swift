//
//  ProductParameter.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 4/19/21.
//

import UIKit
import SwiftyJSON


class ProductParameter: NSObject, JSONParsable {
    
    var category        = ""
    var provideBy       = ""
    var trademark       = ""
    var brandOrigin     = ""
    var tutorial        = ""
    var model           = ""
    var origin          = ""
    var sku             = ""
    var invoiceVAT      = ""
    var guarantee       = ""
    
    
    required override init() {}
    
    required init(json: JSON) {
        super.init()
        category                    = json["category"].stringValue
        provideBy                   = json["provideBy"].stringValue
        trademark                   = json["trademark"].stringValue
        brandOrigin                 = json["brandOrigin"].stringValue
        tutorial                    = json["tutorial"].stringValue
        model                       = json["model"].stringValue
        origin                      = json["origin"].stringValue
        sku                         = json["sku"].stringValue
        invoiceVAT                  = json["invoiceVAT"].stringValue
        guarantee                   = json["guarantee"].stringValue
    }

}
