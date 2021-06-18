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
        case .recive:
            return "Đã tiếp nhận"
        case .transport:
            return "Đã tiếp nhận vận chuyển"
        case .success:
            return "Đã giao thành công"
        case .canccel:
            return "Đã huỷ"
        case .all:
            return ""
        }
    }
    
    var title: String? {
        switch self {
        case .recive:
            return TextManager.processing
        case .transport:
            return TextManager.transported
        case .success:
            return TextManager.recivedSuccess
        case .canccel:
            return TextManager.cancelOrder
        case .all:
            return TextManager.allOrder
        }
    }
}

class Order: NSObject, JSONParsable {
    var id: Int               = 0
    var status: OrderStatus     = .success
    var image: String           = ""
    var name: String            = ""
    var quantity: Int           = 0
    var price: Double           = 0.0
    var bill: String            = ""
    
    required override init() { }
    
    required init(json: JSON) {
        
        self.status     = OrderStatus(rawValue: json["status"].intValue) ?? .success
        self.id         = json["id"].intValue
        self.image      = json["image"].stringValue
        self.name       = json["name"].stringValue
        self.quantity   = json["quantity"].intValue
        self.price      = json["price"].doubleValue
        
        self.bill = "\(quantity) sản phẩm | \(price.currencyFormat)"
    }
    
}

extension Order {
    static var arraySubVC: [OrderStatus] = [.all, .recive, .transport, .success, .canccel]
}
