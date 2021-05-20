//
//  EndPointType.swift
//  iOSCore
//
//  Created by MACOS on 3/17/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit
import Alamofire

public protocol EndPointType {
    var enviromentBaseURL:  String                   { get }
    var baseURL:            URL                      { get }
    var path:               String                   { get }
    var httpMethod:         HTTPMethod               { get }
    var headers:            HTTPHeaders?             { get }
    var parameters:         Parameters?              { get }
    var cachePolicy:        NSURLRequest.CachePolicy { get }
}

// MARK: -

public extension EndPointType {
    var enviromentBaseURL: String {
        return APIConfig.baseURLString
    }
    
    var baseURL: URL {
        let urlString = enviromentBaseURL + path;
        guard let url = URL(string: urlString) else {
            fatalError("baseURL could not be configured.")
        }
        return url
    }
    
    var cachePolicy: NSURLRequest.CachePolicy {
        return .useProtocolCachePolicy
    }
    
    var headers: HTTPHeaders? {
        var headers = ["Content-Type": "application/json"]
        if let token = UserManager.accessToken {
            headers["Authorization"] = "\(token)"
        }
        return headers
    }
}
