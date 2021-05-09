//
//  ApiResponse.swift
//  Ecom
//
//  Created by Minh Tri on 3/22/19.
//  Copyright © 2019 Minh Tri. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol JSONParsable {
    init()
    init(json: JSON)
    func export() -> JSON
}

extension JSONParsable {
    func export() -> JSON {
        return .null
    }
}

// MARK: - API Response

class APIResponse {
    
    var success: Bool = false
    let data: JSON?
    var error: ServiceErrorAPI?
    
    init(response: DataResponse<Data>) {
        let json = JSON(response.data ?? Data())
        self.success = json["success"].boolValue
        
        if (response.response?.isSuccess ?? false) && json["success"].boolValue {
            if json["data"].exists() {
                self.data = json["data"]
            } else {
                self.data = json
            }
        } else {
            if let errorCode = json["code"].int {
                self.error = ServiceErrorAPI(code: errorCode,
                                             title: json["title"].stringValue,
                                             message: json["message"].stringValue)
            } else {
                self.error = ServiceErrorAPI(code: response.response?.statusCode ?? HTTPStatusCode.internalError.rawValue,
                                             title: json["title"].stringValue,
                                             message: json["message"].stringValue)
            }
            self.data = nil
        }
    }
    
    public func toObject<T: JSONParsable>(_ as: T.Type) -> T? {
        guard let data = self.data else {
            return nil
        }
        
        return T(json: data)
    }
    
    public func toArray<T: JSONParsable>(_ as: [T.Type]) -> [T] {
        guard let arrayData = self.data else {
            return []
        }
        
        return (arrayData.arrayValue.compactMap { T(json: $0) })
    }
}

extension HTTPURLResponse {
    var isSuccess: Bool {
        return statusCode == HTTPStatusCode.success.rawValue
    }
    
    var isUnauthenticated: Bool {
        return statusCode == HTTPStatusCode.unauthenticated.rawValue
    }
    
    var isUnauthorized: Bool {
        return statusCode == HTTPStatusCode.unauthenticated.rawValue
    }
    
    var isInternalError: Bool {
        return statusCode == HTTPStatusCode.internalError.rawValue
    }
}

enum HTTPStatusCode: Int {
    case success            = 200
    case unauthenticated    = 401
    case unauthorized       = 403
    case internalError      = 500
}
