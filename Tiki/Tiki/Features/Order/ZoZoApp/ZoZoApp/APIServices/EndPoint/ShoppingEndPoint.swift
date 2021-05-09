//
//  ShoppingEndPoint.swift
//  ZoZoApp
//
//  Created by Dang Trung Hieu on 8/30/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import Foundation
import Alamofire

enum ShoppingEndPoint {
    case getPopularProduct(parameters: Parameters)
    case getAuthenticProduct(parameters: Parameters)
    case getSuggestProduct(parameters: Parameters)
}

// MARK: - EndPointType

extension ShoppingEndPoint: EndPointType {
    var path: String {
        switch self {
        case .getPopularProduct:
            return "/Product/GetPopularProduct"
        case .getAuthenticProduct:
            return "/Product/GetAuthenticProduct"
        case .getSuggestProduct:
            return "/Product/GetSuggestProduct"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getPopularProduct:
            return .get
        case .getAuthenticProduct:
            return .get
        case .getSuggestProduct:
            return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .getPopularProduct(let parameters):
            return parameters
        case .getAuthenticProduct(let parameters):
            return parameters
        case .getSuggestProduct(let parameters):
            return parameters
        }
    }
}
