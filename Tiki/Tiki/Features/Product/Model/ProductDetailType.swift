//
//  EnumProductDetail.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 4/13/21.
//

import UIKit

enum ProductDetailType: Int {
    case infomation   = 0
    case benefits     = 1
    case preferential = 2
    case description  = 3
    case recoment     = 4
    
    static func numberSection() -> Int {
        return 5
    }
}
