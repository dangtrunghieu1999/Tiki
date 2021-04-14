//
//  EnumProductDetail.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 4/13/21.
//

import UIKit

enum ProductDetailType: String {
    case infomation   = "Infomation"
    case benefits     = "benefits"
    case preferential = "preferential"
    case description  = "description"
    case recomment    = "recomment"
    
    static func numberSection() -> Int {
        return 5
    }
}
