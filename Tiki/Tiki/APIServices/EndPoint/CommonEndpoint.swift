//
//  CommonEndpoint.swift
//  ZoZoApp
//
//  Created by MACOS on 6/15/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import Alamofire
import UIKit

enum CommonEndPoint {
    case uploadPhoto(image: UIImage)
}

extension CommonEndPoint: EndPointType {
    
    var path: String {
        switch self {
        case .uploadPhoto:
            return "/Photo/Create"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .uploadPhoto:
            return .post
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .uploadPhoto(let image):
            var params: Parameters = [:]
            let id = UUID().uuidString
            params["Name"]          = id
            params["Alt"]           = id
            params["PhotoTypeId"]   = 1
            params["Base64String"]  = image.base64ImageString
            params["Status"]        = 1
            return params
        }
    }
}
