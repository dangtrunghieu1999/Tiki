//
//  OrderEndPoint.swift
//  ZoZoApp
//
//  Created by LAP12852 on 8/17/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import Foundation
import Alamofire

enum OrderEndPoint {
    case getAllProvince
    case getDistrictByProvince(parans: Parameters)
    case getWardByProvinceIdAndDistrictId(parans: Parameters)
    case getShippingFeeGHTK(params: Parameters)
    case postOrderGHTK(params: Parameters)
    case createOrder(params: Parameters)
}

// MARK: - EndPointType

extension OrderEndPoint: EndPointType {
    var path: String {
        switch self {
        case .getAllProvince:
            return "/Province/GetAll"
        case .getDistrictByProvince:
            return "/District/GetAllDistrictByProvinceId"
        case .getWardByProvinceIdAndDistrictId:
            return "/Ward/GetWardByProvinceIdAndDistrictId"
        case .getShippingFeeGHTK:
            return "/Order/GHTKShippingFee"
        case .postOrderGHTK:
            return "/Order/GHTKPostOrder"
        case .createOrder:
            return "/Order/Create"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getAllProvince:
            return .get
        case .getDistrictByProvince:
            return .get
        case .getWardByProvinceIdAndDistrictId:
            return .get
        case .getShippingFeeGHTK:
            return .post
        case .postOrderGHTK:
            return .post
        case .createOrder:
            return .post
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .getAllProvince:
            return nil
        case .getDistrictByProvince(let params):
            return params
        case .getWardByProvinceIdAndDistrictId(let params):
            return params
        case .getShippingFeeGHTK(let params):
            return params
        case .postOrderGHTK(let params):
            return params
        case .createOrder(let params):
            return params
        }
    }
}
