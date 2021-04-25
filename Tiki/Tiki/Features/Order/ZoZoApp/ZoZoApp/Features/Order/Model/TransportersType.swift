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
    case VTCPay             = 1
    
    var name: String? {
        switch self {
        case .VTCPay:
            return TextManager.paymentMethodVTCPay.localized()
        case .cash:
            return TextManager.paymentMethodCash.localized()
        }
    }
}
