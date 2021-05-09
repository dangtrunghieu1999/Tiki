//
//  Personal.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 3/14/21.
//

import UIKit

enum PersonalType:Int {
    case section1        = 0
    case managerOrder    = 1
    case recive          = 2
    case paymentAgain    = 3
    case transport       = 4
    case successOrder    = 5
    case canccelOrder    = 6
    case section2        = 7
    case address         = 8
    case infoPayment     = 9
    case section3        = 10
    case productedBuy    = 11
    case productedLove   = 12
    case productRating   = 13
    case section4        = 14
    
    static func numberOfItems() -> Int {
        return 15
    }
    
    static func numberOfSections() -> Int {
        return 1
    }
}

class Personal {
    
    var icon        : UIImage?
    var title       : String?
    var subTitle    : String?
    var cellHeight  : Int?
    var cellType    : PersonalType?
    
    init(icon: UIImage?,
         title: String?,
         cellType: PersonalType?) {
        self.icon           = icon
        self.title          = title
        self.cellType       = cellType
    }
}

extension Personal {
    static let cellObject: [Personal] = [
        Personal(icon: nil, title: nil, cellType: .section1),
        Personal(icon: ImageManager.managerOrder, title: "Quản lý đơn hàng",
                 cellType: .managerOrder),
        
        Personal(icon: ImageManager.reciveOrder, title: "HiShop đã tiếp nhận",
                 cellType: .recive),

        Personal(icon: ImageManager.paymentAgain, title: "Đơn hàng chờ thanh toán lại",
                 cellType: .paymentAgain),

        Personal(icon: ImageManager.transportWaiting, title: "Đơn hàng chờ vận chuyển",
                 cellType: .transport),

        Personal(icon: ImageManager.successOrder, title: "Đơn hàng thành công",
                 cellType: .successOrder),

        Personal(icon: ImageManager.cancelOrder, title: "Đơn hàng đã huỷ",
                 cellType: .canccelOrder),

        Personal(icon: nil, title: nil, cellType: .section2),
        Personal(icon: ImageManager.addressLocation, title: "Số địa chỉ",
                 cellType: .address),
        
        Personal(icon: ImageManager.infoPayment, title: "Thông tin thanh toán",
                 cellType: .infoPayment),

        Personal(icon: nil, title: nil, cellType: .section3),
        Personal(icon: ImageManager.buyProducted, title: "Sản phẩm đã mua",
                 cellType: .productedBuy),

        Personal(icon: ImageManager.loveProduct, title: "Sản phẩm yêu thích",
                 cellType: .productedLove),

        Personal(icon: ImageManager.ratingProduct, title: "Sản phẩm đã đánh giá",
                 cellType: .productRating),

        Personal(icon: nil, title: nil, cellType: .section4)
    ]
}
