//
//  ProductEndPoint.swift
//  ZoZoApp
//
//  Created by MACOS on 7/5/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import Foundation
import Alamofire

enum ProductEndPoint {
    case getAllCategory
    case createProduct(parameters: Parameters)
    case getAllProductByShopId(parameters: Parameters)
    case updateProduct(parameters: Parameters)
    case deleteProduct(id: Int)
    case refreshProduct(id: Int)
    case getProductById(parameters: Parameters)
    case getSuggestProduct(parameters: Parameters)
    case createComment(parameters: Parameters)
    case getAllSuplier
    case likeProduct(parameters: Parameters)
    case folowProduct(parameters: Parameters)
    case getAllProductByCategoryId(parameters: Parameters)
}

extension ProductEndPoint: EndPointType {
    var path: String {
        switch self {
        case .getAllCategory:
            return "/Category/GetAll"
        case .createProduct:
            return "/Product/Create"
        case .getAllProductByShopId:
            return "/Product/GetAllProductByShopId"
        case .updateProduct:
            return "/Product/Update"
        case .deleteProduct(let id):
            return "/Product/Delete/\(id.description)"
        case .refreshProduct(let id):
            return "/Product/UpdateNumberRefreshOfProduct/\(id)"
        case .getProductById:
            return "/Product/GetById"
        case .getSuggestProduct:
            return "/Product/GetSuggestProduct"
        case .createComment:
            return "/ProductComment/Create"
        case .getAllSuplier:
            return "/Supplier/GetAll"
        case .likeProduct:
            return "/ProductLike/CreateOrUpdate"
        case .folowProduct:
            return "/ProductFollow/CreateOrUpdate"
        case .getAllProductByCategoryId:
            return "/Product/GetAllProductByCategoryId"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getAllCategory:
            return .get
        case .createProduct:
            return .post
        case .getAllProductByShopId:
            return .get
        case .updateProduct:
            return .put
        case .deleteProduct:
            return .put
        case .refreshProduct:
            return .put
        case .getProductById:
            return .get
        case .getSuggestProduct:
            return .get
        case .createComment:
            return .post
        case .getAllSuplier:
            return .get
        case .likeProduct:
            return .post
        case .folowProduct:
            return .post
        case .getAllProductByCategoryId:
            return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .getAllCategory:
            return nil
        case .createProduct(let parameters):
            return parameters
        case .getAllProductByShopId(let parameters):
            return parameters
        case .updateProduct(let parameters):
            return parameters
        case .deleteProduct:
            return nil
        case .refreshProduct:
            return nil
        case .getProductById(let parameters):
            return parameters
        case .getSuggestProduct(let parameters):
            return parameters
        case .createComment(let parameters):
            return parameters
        case .getAllSuplier:
            return nil
        case .likeProduct(let parameters):
            return parameters
        case .folowProduct(let parameters):
            return parameters
        case .getAllProductByCategoryId(let parameters):
            return parameters
        }
    }
}
