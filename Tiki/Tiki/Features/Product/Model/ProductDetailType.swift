//
//  EnumProductDetail.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 4/13/21.
//

import UIKit

enum ProductDetailType: Int {
    case infomation        = 0
    case section1          = 1
    case sameProduct       = 3
    case section2          = 4
    case stallShop         = 5
    case section3          = 6
    case advanedShop       = 7
    case section4          = 8
    case infoDetail        = 9
    case section5          = 10
    case description       = 11
    case section6          = 12
    case comment           = 13
    case recomment         = 14
    case section7          = 15
    case recommend         = 16
    case section8          = 17
    
    static func numberSection() -> Int {
        return 18
    }
    
}

class ProductParameterModel {
    let keyTitle: [String]  =         ["Danh mục",
                                       "Cung cấp bởi",
                                       "Thương hiệu",
                                       "Xuất xứ thương hiệu",
                                       "Hướng dẫn",
                                       "Model",
                                       "Xuất xứ",
                                       "SKU",
                                       "Hoá đơn VAT",
                                       "Bảo hành"]
}
