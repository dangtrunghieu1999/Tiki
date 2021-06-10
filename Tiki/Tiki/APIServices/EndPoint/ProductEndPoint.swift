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
    case getAllCategoryById(parameters: Parameters)
    case createProduct(parameters: Parameters)
    case getAllProductByShopId(parameters: Parameters)
    case updateProduct(parameters: Parameters)
    case deleteProduct(id: Int)
    case refreshProduct(id: Int)
    case getProductById(parameters: Parameters)
    case getSuggestProduct(parameters: Parameters)
    case createComment(parameters: Parameters)
    case getAllProduct
}

extension ProductEndPoint: EndPointType {
    var path: String {
        switch self {
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
            return "/product"
        case .getSuggestProduct:
            return "/Product/GetSuggestProduct"
        case .createComment:
            return "/"
        case .getAllProduct:
            return "/product/loadmore"
        case .getAllCategoryById:
            return "/product/ref"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
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
        case .getAllProduct:
            return .get
        case .getAllCategoryById:
            return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
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
        case .getAllProduct:
            return nil
        case .getAllCategoryById(let parameters):
            return parameters
        }
    }
}
