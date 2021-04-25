//
//  MenuOption.swift
//  ZoZoApp
//
//  Created by Dang Trung Hieu on 8/28/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

enum MenuOption: Int, CustomStringConvertible {
    
    case shopping               = 0
    case earnMoney              = 1
    case myStall                = 2
    case orderSetting           = 3
    case financial              = 4
    case promo                  = 5
    case following              = 6
    case report                 = 7
    case guideOrder             = 8
    case guideEarnMoney         = 9
    case settingAndPrivacy      = 10
    case profileMenu            = 11
    case logOut                 = 12
    
    static func numberSection() -> Int {
        return 13
    }
    
    var description: String {
        switch self {
        case .shopping:            return TextManager.shopping.localized()
        case .earnMoney:           return TextManager.makeMoney.localized()
        case .myStall:             return TextManager.myStall.localized()
        case .orderSetting:        return TextManager.orderSetting.localized()
        case .financial:           return TextManager.financial.localized()
        case .promo:               return TextManager.promo.localized()
        case .following:           return TextManager.following.localized()
        case .report:              return TextManager.report.localized()
        case .guideOrder:          return TextManager.guideOrder.localized()
        case .guideEarnMoney:      return TextManager.guideEarnMoney.localized()
        case .settingAndPrivacy:   return TextManager.settingAndPrivacy.localized()
        case .logOut:              return TextManager.logOut.localized()
        case .profileMenu:         return TextManager.profileMenu.localized()
        }
    }
    
    var image: UIImage {
        switch self {
        case .shopping:            return ImageManager.shopping ?? UIImage()
        case .earnMoney:           return ImageManager.makeMoney ?? UIImage()
        case .myStall:             return ImageManager.myStall ?? UIImage()
        case .orderSetting:        return ImageManager.orderSetting ?? UIImage()
        case .financial:           return ImageManager.financial ?? UIImage()
        case .promo:               return ImageManager.promo ?? UIImage()
        case .following:           return ImageManager.following ?? UIImage()
        case .report:              return ImageManager.report ?? UIImage()
        case .guideOrder:          return ImageManager.guideOrder ?? UIImage()
        case .guideEarnMoney:      return ImageManager.guideEarnMoney ?? UIImage()
        case .settingAndPrivacy:   return ImageManager.settingAndPrivacy ?? UIImage()
        case .logOut:              return ImageManager.logOut ?? UIImage()
        case .profileMenu:         return ImageManager.profileMenu ?? UIImage()
        }
    }
}
