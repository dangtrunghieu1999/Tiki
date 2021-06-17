//
//  Order.swift
//  Tiki
//
//  Created by Bee_MacPro on 16/06/2021.
//

import UIKit
import SwiftyJSON
import Alamofire

enum OrderStatus: Int {
    case all         = 0
    case recive      = 1
    case transport   = 2
    case success     = 3
    case canccel     = 4
    
    var name: String? {
        switch self {
        case .all:
            return TextManager.allOrder.localized()
        case .recive:
            return TextManager.processing.localized()
        case .transport:
            return TextManager.transported.localized()
        case .success:
            return TextManager.recivedSuccess.localized()
        case .canccel:
            return TextManager.cancelOrder.localized()
        }
    }
}

class Order: NSObject, JSONParsable {
    
    required override init() { }
    
    required init(json: JSON) {
        
    }
}
