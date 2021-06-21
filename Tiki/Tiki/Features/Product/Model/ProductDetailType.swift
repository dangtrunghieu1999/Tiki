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
    case section7          = 14
    case recommend         = 15
    case section8          = 16
    
    static func numberSection() -> Int {
        return 17
    }
    
    func sizeForHeader() -> CGSize {
        switch self {
        case .sameProduct, .infoDetail, .description, .comment:
            return CGSize(width: ScreenSize.SCREEN_WIDTH, height: 50)
        default:
            return .zero
        }
    }
    
    var title: String {
        switch self {
        case .sameProduct:
            return TextManager.sameProudct
        case .infoDetail:
            return TextManager.detailProduct
        case .description:
            return TextManager.detailDes
        case .comment:
            return TextManager.comment
        default:
            return ""
        }
    }
    
}
