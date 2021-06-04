//
//  CartManager.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 4/25/21.
//

import UIKit

class CartManager {
    
    static let shared = CartManager()
    
    // MARK: - Variables
    
    var totalProducts: Int {
        return cartShopInfos.reduce(0) { (result, cartShopInfo) -> Int in
            result + cartShopInfo.products.reduce(0, { (quantiy, product) -> Int in
                quantiy + product.quantity
            })
        }
    }
    
    var totalMoney: Double {
        return cartShopInfos.reduce(0) { (result, cartShopInfo) -> Double in
            result + cartShopInfo.products.reduce(0, { ( money, product ) -> Double in
                money + product.totalMoney
            })
        }
    }
    
    private (set) var cartShopInfos: [CartShopInfo] = []
    
    // MARK: - LifeCycles
    
    private init() {}
    
    // MARK: - APIs Request
    
    
    // MARK: - Public Methods
    
    func removeAll() {
        cartShopInfos.removeAll()
    }
    
    func removeCartShopInfo(_ cartShopInfo: CartShopInfo) {
        if let index = cartShopInfos.firstIndex(of: cartShopInfo) {
            cartShopInfos.remove(at: index)
            NotificationCenter.default.post(name: NSNotification.Name.reloadCartBadgeNumber, object: nil)
        }
    }
    
    func addProductToCart(_ product: Product,
                          completionHandler: () -> Void,
                          error: () -> Void) {
        guard let copyProduct = product.copy() as? Product else {
            error()
            return
        }
        
        if let index = cartShopInfos.firstIndex(where: { $0.id == copyProduct.shopId }) {
            cartShopInfos[index].addProduct(copyProduct)
        } else {
            let cartShopInfo = CartShopInfo(product: copyProduct)
            cartShopInfos.append(cartShopInfo)
        }
        completionHandler()
    }
    
    func deleteProduct(_ product: Product,
                       completionHandler: () -> Void,
                       error: () -> Void) {
        guard let cartIndex = cartShopInfos.firstIndex(where: { $0.id == product.shopId }) else {
            return
        }
        
        guard let productIndex = cartShopInfos[cartIndex].products
                .firstIndex(where: { $0.id == product.id }) else {
            return
        }
        
        cartShopInfos[cartIndex].products.remove(at: productIndex)
        if cartShopInfos[cartIndex].products.isEmpty {
            cartShopInfos.remove(at: cartIndex)
        }
        completionHandler()
    }
    
    func increaseProductQuantity(_ product: Product,
                                 completionHandler: () -> Void,
                                 error: () -> Void) {
        guard let cartIndex = cartShopInfos.firstIndex(where: { $0.id == product.shopId }) else {
            return
        }
        
        guard let productIndex = cartShopInfos[cartIndex].products
                .firstIndex(where: { $0.id == product.id }) else {
            return
        }
        
        cartShopInfos[cartIndex].products[productIndex].quantity += 1
        completionHandler()
    }
    
    func decreaseProductQuantity(_ product: Product,
                                 completionHandler: () -> Void,
                                 error: () -> Void) {
        guard let cartIndex = cartShopInfos.firstIndex(where: { $0.id == product.shopId }) else {
            return
        }
        
        guard let productIndex = cartShopInfos[cartIndex].products
                .firstIndex(where: { $0.id == product.id }) else {
            return
        }
        
        cartShopInfos[cartIndex].products[productIndex].quantity -= 1
        completionHandler()
    }
    
}

