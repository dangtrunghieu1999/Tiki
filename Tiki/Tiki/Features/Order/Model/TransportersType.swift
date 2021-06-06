//
//  TransportersType.swift
//  ZoZoApp
//
//  Created by LAP12852 on 8/29/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

enum TransportersType: Int {
    case giaoHangTietKiem   = 0
    case VNPost             = 1
    
    var logo: UIImage? {
        switch self {
        case .giaoHangTietKiem:
            return ImageManager.logoGHTK
        case .VNPost:
            return ImageManager.logoVietNamPost
        }
    }
}

enum PaymentMethodType: Int {
    case cash               = 0
    case momo               = 1
    
    var logo: UIImage? {
        switch self {
        case .cash:
            return ImageManager.icon_cash
        case .momo:
            return ImageManager.icon_momo
        }
    }
    
    var name: String? {
        switch self {
        case .momo:
            return TextManager.paymentMethodMomo.localized()
        case .cash:
            return TextManager.paymentMethodCash.localized()
        }
    }
}
