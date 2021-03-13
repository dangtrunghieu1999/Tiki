//
//  ShopEndPoint.swift
//  ZoZoApp
//
//  Created by MACOS on 6/9/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import Foundation
import Alamofire

enum ShopEndPoint {
    case getShopsByUser
    case getAll
    case getAllCategory
    case createShop(params: Parameters)
    case updateShopInfo(params: Parameters)
    case getShopById(params: Parameters)
    case getAllPhotos(params: Parameters)
    case getAllUserHasRoleInShop(params: Parameters)
    case getAllShopRolesByUserId(params: Parameters)
    case getAllShopRoleOfCurrentUser(params: Parameters)
    case updateShopRole(params: Parameters)
    case removeUserInShop(params: Parameters)
}

extension ShopEndPoint: EndPointType {
    var path: String {
        switch self {
        case .getShopsByUser:
            return "/Shop/GetShopByUserId"
        case .getAll:
            return "/Shop/GetAll"
        case .getAllCategory:
            return "/Category/GetAll"
        case .createShop:
            return "/Shop/Create"
        case .updateShopInfo:
            return "/Shop/Update"
        case .getShopById:
            return "/Shop/GetById"
        case .getAllPhotos:
            return "/Shop/GetAllPhotosByShopId"
        case .getAllShopRolesByUserId:
            return "/ShopRoles/GetAllShopRolesByUserId"
        case .getAllShopRoleOfCurrentUser:
            return "/ShopRoles/GetAllShopRolesByCurrentUserId"
        case .updateShopRole:
            return "/ShopRoles/UpdatePermissionInShopRole"
        case .getAllUserHasRoleInShop:
            return "/ShopRoles/GetAllUsersByShopId"
        case .removeUserInShop:
            return "/ShopRoles/RemoveUserShopRole"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getShopsByUser:
            return .get
        case .getAll:
            return .get
        case .getAllCategory:
            return .get
        case .createShop:
            return .post
        case .updateShopInfo:
            return .put
        case .getShopById:
            return .get
        case .getAllPhotos:
            return .get
        case .getAllShopRolesByUserId:
            return .get
        case .getAllShopRoleOfCurrentUser:
            return .get
        case .updateShopRole:
            return .post
        case .getAllUserHasRoleInShop:
            return .get
        case .removeUserInShop:
            return .post
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .getShopsByUser:
            return nil
        case .getAll:
            return nil
        case .getAllCategory:
            return nil
        case .createShop(let params):
            return params
        case .updateShopInfo(let params):
            return params
        case .getShopById(let params):
            return params
        case .getAllPhotos(let params):
            return params
        case .getAllShopRolesByUserId(let params):
            return params
        case .getAllShopRoleOfCurrentUser(let params):
            return params
        case .updateShopRole(let params):
            return params
        case .getAllUserHasRoleInShop(let params):
            return params
        case .removeUserInShop(let params):
            return params
        }
    }
}
