//
//  SignUpViewModel.swift
//  ZoZoApp
//
//  Created by MACOS on 6/1/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit
import Localize_Swift
import Alamofire

class SignUpViewModel: BaseViewModel {
    
    // MARK: - LifeCycles
    
    override func initialize() {}
    
    // MARK: - Public methods
    
    func canSignUp(firstName: String?,
                   lastName: String?,
                   userName: String?,
                   password: String?,
                   confirmPassword: String?,
                   dob: Date?) -> Bool {
        if (firstName != nil && firstName != ""
            && lastName != nil && lastName != ""
            && userName != nil && userName != "" && (userName?.isPhoneNumber ?? false || userName?.isValidEmail ?? false)
            && password != nil && password != ""
            && confirmPassword != nil && confirmPassword != ""
            && dob != nil) {
            return true
        } else {
            return false
        }
    }
    
    func requestSignUp(firstName: String,
                       lastName: String,
                       userName: String,
                       password: String,
                       dob: Date,
                       onSuccess: @escaping () -> Void,
                       onError: @escaping (String) -> Void) {
        
        var params = ["UserType": "KH",
                      "FirstName": firstName,
                      "LastName": lastName,
                      "UserName": userName,
                      "Password": password,
                      "PasswordConfirm": password,
                      "Birthday": dob.desciption(by: DateFormat.fullDateServerFormat)]
        if userName.isValidEmail {
            params["Email"] = userName
        } else if userName.isPhoneNumber {
            params["Email"] = "\(userName)@gmail.com"
            params["PhoneNumber"] = userName
        }
        
        let endPoint = UserEndPoint.signUp(bodyParams: params)
        
        APIService.request(endPoint: endPoint, onSuccess: { (apiResponse) in
            if let userId = apiResponse.data?.dictionaryValue["UserId"]?.stringValue {
                UserSessionManager.shared.saveUserId(userId)
            }
            onSuccess()
        }, onFailure: { (apiError) in
            if userName.isValidEmail {
                onError(TextManager.existEmail.localized())
            } else {
                onError(TextManager.existPhoneNumber.localized())
            }
        }) {
            onError(TextManager.errorMessage.localized())
        }
    }
    
}
