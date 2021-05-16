//
//  SignUpViewModel.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 5/10/21.
//

import UIKit

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
        
        var params = ["firstName": firstName,
                      "lastName": lastName,
                      "password": password,
                      "dayOfBirth": dob.desciption(by: DateFormat.fullDateServerFormat)]
        if userName.isValidEmail {
            params["email"] = userName
        } else if userName.isPhoneNumber {
            params["email"] = "\(userName)@gmail.com"
            params["phone"] = userName
        }
        
        let endPoint = UserEndPoint.register(bodyParams: params)
        
        APIService.request(endPoint: endPoint, onSuccess: { (apiResponse) in
            if let userId = apiResponse.data?.dictionaryValue["id"]?.stringValue {
                UserSessionManager.shared.saveUserId(userId)
            }
            
            if let token = apiResponse.data?.dictionaryValue["token"]?.stringValue {
                UserSessionManager.shared.saveToken(token)
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
