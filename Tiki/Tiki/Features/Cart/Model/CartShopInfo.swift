//
//  CartShopInfo.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 4/25/21.
//

import UIKit

class CartShopInfo: NSObject {
    var id              = 0
    var name            = ""
    var avatar          = ""
    var provinceId      = 0
    var provinveName    = ""
    var districtId      = 0
    var districtName    = ""
    var wardId          = 0
    var wardName        = ""
    var address         = ""
    var products: [Product] = []
    
    var totalMoney: Double {
        var totalMoney: Double = 0
        for product in products {
            totalMoney += product.totalMoney
        }
        return totalMoney
    }
    
    override init() {}
    
    init(product: Product) {
        id      = product.shopId ?? 0
        name    = product.shopName
        avatar  = product.shopAvatar
        
        products.append(product)
        
        if provinveName == "" {
            provinveName = "Tp. Hồ Chí Minh"
        }
        
        if districtName == "" {
            districtName = "Quận Tân Bình"
        }
        
        if wardName == "" {
            wardName = "Bình Tân"
        }
    }
    
    func addProduct(_ product: Product) {
        if let existProductIndex = products.firstIndex(where: { $0.id == product.id }),
            let existProduct = products[safe: existProductIndex] {
            existProduct.quantity += 1
            products[existProductIndex] = existProduct
        } else {
            products.append(product)
        }
    }
    
}
