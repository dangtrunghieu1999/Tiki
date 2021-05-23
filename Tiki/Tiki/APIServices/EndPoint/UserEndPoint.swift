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
    case register(bodyParams: Parameters)
    case forgotPW(bodyParams: Parameters)
    case checkValidCode(bodyParams: Parameters)
    case checkValidCodeWithPhone(bodyParams: Parameters)
    case createNewPW(bodyParams: Parameters)
    case sendOTP(bodyParams: Parameters)
    case getUserInfo
    case searchUser(params: Parameters)
}

extension UserEndPoint: EndPointType {
    var path: String {
        switch self {
        case .signIn:
            return "/user/login"
        case .register:
            return "/user/register"
        case .forgotPW:
            return "/user/forgotpassword"
        case .checkValidCode:
            return "/user/verify"
        case .checkValidCodeWithPhone:
            return "/user/checkotp"
        case .createNewPW:
            return "/User/CreateNewPassword"
        case .sendOTP:
            return "/user/sendotp"
        case .getUserInfo:
            return "/user/me"
        case .searchUser:
            return "/User/SearchUser"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .signIn:
            return .post
        case .register:
            return .post
        case .forgotPW:
            return .post
        case .checkValidCode:
            return .post
        case .checkValidCodeWithPhone:
            return .post
        case .createNewPW:
            return .post
        case .sendOTP:
            return .post
        case .getUserInfo:
            return .get
        case .searchUser:
            return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .signIn(let bodyParams):
            return bodyParams
        case .register(let bodyParams):
            return bodyParams
        case .forgotPW(let bodyParams):
            return bodyParams
        case .checkValidCode(let bodyParams):
            return bodyParams
        case .checkValidCodeWithPhone(let bodyParams):
            return bodyParams
        case .createNewPW(let bodyParams):
            return bodyParams
        case .sendOTP(let bodyParams):
            return bodyParams
        case .getUserInfo:
            return nil
        case .searchUser(let params):
            return params
        }
    }
    
    
}
