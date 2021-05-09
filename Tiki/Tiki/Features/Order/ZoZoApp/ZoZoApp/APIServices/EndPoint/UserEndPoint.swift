//
//  UserEndPoint.swift
//  ZoZoApp
//
//  Created by MACOS on 6/1/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit
import Alamofire

enum UserEndPoint {
    case signIn(bodyParams: Parameters)
    case signUp(bodyParams: Parameters)
    case forgotPW(bodyParams: Parameters)
    case checkValidCode(bodyParams: Parameters)
    case createNewPW(bodyParams: Parameters)
    case getUserById(params: Parameters)
    case searchUser(params: Parameters)
}

extension UserEndPoint: EndPointType {
    var path: String {
        switch self {
        case .signIn:
            return "/Auth/Login"
        case .signUp:
            return "/User/Create"
        case .forgotPW:
            return "/User/ForgotPassword"
        case .checkValidCode:
            return "/User/ConfirmAccount"
        case .createNewPW:
            return "/User/CreateNewPassword"
        case .getUserById:
            return "/User/GetById"
        case .searchUser:
            return "/User/SearchUser"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .signIn:
            return .post
        case .signUp:
            return .post
        case .forgotPW:
            return .post
        case .checkValidCode:
            return .post
        case .createNewPW:
            return .post
        case .getUserById:
            return .get
        case .searchUser:
            return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .signIn(let bodyParams):
            return bodyParams
        case .signUp(let bodyParams):
            return bodyParams
        case .forgotPW(let bodyParams):
            return bodyParams
        case .checkValidCode(let bodyParams):
            return bodyParams
        case .createNewPW(let bodyParams):
            return bodyParams
        case .getUserById(let params):
            return params
        case .searchUser(let params):
            return params
        }
    }
    
    
}
