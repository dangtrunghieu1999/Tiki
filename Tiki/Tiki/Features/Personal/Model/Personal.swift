//
//  Personal.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 3/14/21.
//

import UIKit

enum PersonalType:Int {
    case welcome         = 0
    case managerOrder    = 1
    case address         = 2
    case managerProduct  = 3
    case logout          = 4
    
    static func numberOfSection() -> Int {
        return 5
    }
    
}

class Personal {
    var managerOrder:   [String] = ["Quản lý đơn hàng",
                                    "TiKi đã tiếp nhận",
                                    "Đơn hàng chờ thanh toán lại",
                                    "Đơn hàng chờ vận chuyển",
                                    "Đơn hàng thành công",
                                    "Đơn hàng đã huỷ"]
    
    var orderImage: [UIImage?] = [ImageManager.managerOrder,
                                  ImageManager.reciveOrder,
                                  ImageManager.paymentAgain,
                                  ImageManager.transportWaiting,
                                  ImageManager.successOrder,
                                  ImageManager.cancelOrder]
    
    
    var address:        [String] =  ["Số địa chỉ",
                                     "Thông tin thanh toán"]
    
    var orderAddress: [UIImage?] = [ImageManager.addressLocation, ImageManager.infoPayment]
    
    var managerProduct: [String] = ["Sản phẩm đã mua",
                                    "Sản phẩm yêu thích",
                                    "Sản phẩm đã đánh giá"]
    
    var productImage: [UIImage?] = [ImageManager.buyProducted,
                                    ImageManager.loveProduct,
                                    ImageManager.ratingProduct]
}
