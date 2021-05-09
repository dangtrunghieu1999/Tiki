//
//  ShopRole.swift
//  ZoZoApp
//
//  Created by LAP12852 on 8/11/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

enum ShopRoleType: Int {
    case editShop           = 1
    case createProduct      = 2
    case updateProduct      = 3
    case viewOrder          = 4
    case viewReport         = 5
    case editUserRole       = 6
    case finaceManagement   = 7
}

// MARK: -

class ShopRole: NSObject, JSONParsable {
    var shopRoleId                      = 0
    var shopRoleName                    = ""
    var hasRole                         = false
    var roleType: ShopRoleType          = .editShop
    
    required override init() {}
    
    required init(json: JSON) {
        shopRoleId      = json["ShopRoleId"].intValue
        shopRoleName    = json["ShopRoleName"].stringValue
        hasRole         = json["HasRole"].boolValue
        roleType        = ShopRoleType(rawValue: shopRoleId) ?? .editShop
    }
    
}

// MARK: -

class ShopRoleManager {
    
    // MARK: - Variables
    
    static var shared = ShopRoleManager()
    
    private (set) var currentUserRoles = [ShopRole]()
    
    // MARK: - Object LifeCycles
    
    private init() {}
    
    // MARK: - Check Roles
    
    var isShopAdmin: Bool {
        for role in currentUserRoles {
            if role.hasRole {
                return true
            }
        }
        return false
    }
    
    func hasRole(roleType: ShopRoleType) -> Bool {
        guard let role = currentUserRoles.first(where: { $0.shopRoleId == roleType.rawValue }) else {
            return false
        }
        return role.hasRole
    }
    
    // MARK: - Request APIs
    
    func getShopRolesOfCurrentUser(shopId: Int, onSuccess: @escaping () -> Void, onError: @escaping () -> Void) {
        let endPoint = ShopEndPoint.getAllShopRoleOfCurrentUser(params: ["shopId": shopId])
        
        APIService.request(endPoint: endPoint, onSuccess: { [weak self] (apiResponse) in
            guard let self = self else { return }
            self.currentUserRoles = apiResponse.toArray([ShopRole.self])
            onSuccess()
        }, onFailure: { (apiError) in
            onError()
        }) {
            onError()
        }
    }
    
    func getShopRolesByUserId(shopId: Int,
                              userId: String,
                              onSuccess: @escaping ([ShopRole]) -> Void, onError: @escaping () -> Void) {
        let endPoint = ShopEndPoint.getAllShopRolesByUserId(params: ["shopId": shopId, "userId": userId])
        
        APIService.request(endPoint: endPoint, onSuccess: { (apiResponse) in
            let roles = apiResponse.toArray([ShopRole.self])
            onSuccess(roles)
        }, onFailure: { (apiError) in
            onError()
        }) {
            onError()
        }
    }
    
    func updateRole(params: Parameters, onSuccess: @escaping () -> Void, onError: @escaping () -> Void) {
        let endPoint = ShopEndPoint.updateShopRole(params: params)
        
        APIService.request(endPoint: endPoint, onSuccess: { (apiResponse) in
            onSuccess()
        }, onFailure: { (apiError) in
            onError()
        }) {
            onError()
        }
    }
    
    func searchUser(text: String) {
        
    }
    
    func deleteUser() {
        
    }

}
