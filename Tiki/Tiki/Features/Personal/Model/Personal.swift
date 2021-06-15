//
//  Personal.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 3/14/21.
//

import UIKit

enum PersonalType:Int {
    case section1        = 0
    case mananger        = 1
    case recive          = 2
    case transport       = 3
    case success         = 4
    case canccel         = 5
    case section2        = 6
    case address         = 7
    case bought          = 8
    case liked           = 9
    case rating          = 10
    
    static func numberOfItems() -> Int {
        return 11
    }
    
    static func numberOfSections() -> Int {
        return 1
    }
}

class Personal {
    
    var icon        : UIImage?
    var title       : String?
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
                 cellType: .mananger),
        Personal(icon: ImageManager.reciveOrder, title: "HiShop đã tiếp nhận",
                 cellType: .recive),
        Personal(icon: ImageManager.transport, title: "Đơn hàng chờ vận chuyển",
                 cellType: .transport),
        Personal(icon: ImageManager.successOrder, title: "Đơn hàng thành công",
                 cellType: .success),
        Personal(icon: ImageManager.cancelOrder, title: "Đơn hàng đã huỷ",
                 cellType: .canccel),
        Personal(icon: nil, title: nil, cellType: .section2),
        Personal(icon: ImageManager.addressLocation, title: "Số địa chỉ",
                 cellType: .address),
        Personal(icon: ImageManager.buyProducted, title: "Sản phẩm đã mua",
                 cellType: .bought),
        Personal(icon: ImageManager.loveProduct, title: "Sản phẩm yêu thích",
                 cellType: .liked),
        Personal(icon: ImageManager.ratingProduct, title: "Sản phẩm đã đánh giá",
                 cellType: .rating),
    ]
}
