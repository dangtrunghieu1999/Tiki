//
//  CartShopInfo.swift
//  ZoZoApp
//
//  Created by LAP12852 on 8/25/19.
//  Copyright © 2019 MACOS. All rights reserved.
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
    
    var totalWeight: Double {
        let totalWeight = products.reduce(0.0) { (result, product) -> Double in
            return result + product.weight
        }
        if totalWeight == 0 {
            return 1.000
        } else {
            return totalWeight
        }
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
            let existProduct = products[safe: existProductIndex],
            existProduct.selectedSize == product.selectedSize,
            existProduct.selectedColor == product.selectedColor {
            
            existProduct.quantity += 1
            products[existProductIndex] = existProduct
        } else {
            products.append(product)
        }
    }
    
}
