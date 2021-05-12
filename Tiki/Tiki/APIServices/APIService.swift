//
//  APIService.swift
//  iOSCore
//
//  Created by MACOS on 3/17/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import Foundation
import Alamofire

public final class APIService<EndPoint: EndPointType> {
    
    static func requestByJSONString(endPoint: EndPoint,
                                    onSuccess: @escaping ((APIResponse) -> Void),
                                    onFailure: @escaping (ServiceErrorAPI?) -> Void,
                                    onRequestFail: @escaping () -> Void) {
        
        var request = URLRequest(url: endPoint.baseURL)
        request.httpMethod = endPoint.httpMethod.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonString = "'\(endPoint.parameters?.jsonString ?? "")'"
        request.httpBody = Data(jsonString.utf8)
        let dataRequest = SessionManager.default.request(request)
        
        #if DEBUG
        if (endPoint.parameters?["Base64String"] == nil) {
            _ = dataRequest.debugLog()
        }
        #endif
        processResponse(dataRequest: dataRequest,
                        onSuccess: onSuccess,
                        onFailure: onFailure,
                        onRequestFail: onRequestFail)
    }
    
    static func request(endPoint: EndPoint,
                        onSuccess: @escaping ((APIResponse) -> Void),
                        onFailure: @escaping (ServiceErrorAPI?) -> Void,
                        onRequestFail: @escaping () -> Void) {
        
        var encoding: ParameterEncoding
        if (endPoint.httpMethod == .post || endPoint.httpMethod == .put) {
            encoding = JSONEncoding.default
        } else {
            encoding = URLEncoding.default
        }
        let dataRequest = SessionManager.default.request(endPoint.baseURL,
                                                         method: endPoint.httpMethod,
                                                         parameters: endPoint.parameters,
                                                         encoding: encoding,
                                                         headers: endPoint.headers)
        
        #if DEBUG
        if (endPoint.parameters?["Base64String"] == nil) {
            _ = dataRequest.debugLog()
        }
        #endif
        
        processResponse(dataRequest: dataRequest,
                        onSuccess: onSuccess,
                        onFailure: onFailure,
                        onRequestFail: onRequestFail)
    }
    
    private static func processResponse(dataRequest: DataRequest,
                                        onSuccess: @escaping ((APIResponse) -> Void),
                                        onFailure: @escaping (ServiceErrorAPI?) -> Void,
                                        onRequestFail: @escaping () -> Void) {
        
        dataRequest.responseData { (dataResponse) in
            
            #if DEBUG
            if let request = dataRequest.request, let response = dataResponse.response, let data = dataResponse.data {
                NetworkLogger.log(request: request,
                                  response: response,
                                  data: data)
            }
            #endif
            
            if dataResponse.response?.statusCode == HTTPStatusCode.unauthorized.rawValue ||
                dataResponse.response?.statusCode == HTTPStatusCode.unauthenticated.rawValue {
                UserManager.logout()
                UINavigationController.topNavigationVC?.viewControllers.removeAll()
                UIViewController.setRootVCBySinInVC()
                AlertManager.shared.show(message: TextManager.tokenFailMessage.localized())
                return
            }
            
            if dataResponse.response?.isSuccess ?? false {
                let apiResponse = APIResponse(response: dataResponse)
                if apiResponse.data != nil {
                    onSuccess(apiResponse)
                } else {
                    onFailure(apiResponse.error)
                }
            } else {
                onRequestFail()
            }
        }
    }
    
}

extension Request {
    public func debugLog() -> Self {
        #if DEBUG
        debugPrint(self)
        #endif
        return self
    }
}
