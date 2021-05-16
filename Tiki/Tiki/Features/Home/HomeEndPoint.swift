//
//  HomeEndPoint.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 5/11/21.
//

import Foundation
import Alamofire

enum HomeEndPoint {
    case getAllHome
}

extension HomeEndPoint: EndPointType {
    var path: String {
        switch self {
        case .getAllHome:
            return "/home/data"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getAllHome:
            return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .getAllHome:
            return nil
        }
    }

}
