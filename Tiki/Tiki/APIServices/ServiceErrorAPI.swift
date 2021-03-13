//
//  ServiceErrorAPI.swift
//  Ecom
//
//  Created by Minh Tri on 3/22/19.
//  Copyright © 2019 Minh Tri. All rights reserved.
//

import UIKit

enum ServiceErrorCode: String {
    case invalidDataFormat      = "INVALID_DATA"
    case unauthenticated        = "UNAUTHENTICATED"
    case timeout                = "TIMEOUT"
    case undefined              = "UNDEFINED"
}

struct ServiceErrorAPI: LocalizedError {
    
    static let unauthenticated = ServiceErrorAPI(code: .unauthenticated,
                                                 title: "Error",
                                                 message: "Unauthenticated")
    static let invalidDataFormat = ServiceErrorAPI(code: .invalidDataFormat,
                                                   title: "Error",
                                                   message: "Invalid Data Format")
    static let timeout = ServiceErrorAPI(code: .timeout,
                                         title: "Error",
                                         message: "Request Time out")
    static let undefined = ServiceErrorAPI(code: .undefined,
                                           title: "Error",
                                           message: "Undefined error")
    
    var code: String
    var title: String
    var message: String
    
    init(code: ServiceErrorCode, title: String, message: String) {
        self.code = code.rawValue
        self.title = title
        self.message = message
    }
    
    init(code: String, title: String, message: String) {
        self.code = code
        self.title = title
        self.message = message
    }
    
    init (code: Int, title: String, message: String) {
        self.code = "\(code)"
        self.title = title
        self.message = message
    }
}
