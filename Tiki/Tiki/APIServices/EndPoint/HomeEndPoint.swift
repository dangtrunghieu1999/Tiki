//
//  HomeEndPoint.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 5/11/21.
//

import Foundation
import Alamofire

enum HomeEndPoint {
    case getBannerHome
    case getCateogoryMenu
}

extension HomeEndPoint: EndPointType {
    var path: String {
        switch self {
        case .getBannerHome:
            return "/home/data"
        case .getCateogoryMenu:
            return "/home/menu"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getBannerHome:
            return .get
        case .getCateogoryMenu:
            return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .getBannerHome:
            return nil
        case .getCateogoryMenu:
            return nil
        }
    }

}
