//
//  SignInViewModel.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 5/10/21.
//

import UIKit

class SignInViewModel: BaseViewModel {
    
    func requestSignIn(userName: String,
                       passWord: String,
                       onSuccess: @escaping () -> Void,
                       onError: @escaping (String) -> Void) {
        
        let params = ["phone": userName, "password": passWord]
        let endPoint = UserEndPoint.signIn(bodyParams: params)
        
        APIService.request(endPoint: endPoint, onSuccess: { (apiResponse) in
            guard apiResponse.data != nil else {
                onError(TextManager.accNotActive.localized())
                return
            }
            
            if let user = apiResponse.toObject(User.self) {
                UserManager.saveCurrentUser(user)
                UserManager.getUserProfile()
                onSuccess()
            } else {
                onError(TextManager.errorMessage.localized())
            }
        }, onFailure: { [weak self] (serviceError) in
            if serviceError?.message == "Account is inactive!" {
                if userName.isPhoneNumber {
                    // If user not active and is phone number
                    // will call API to trigger send OTP
                    // Then will navigate to Verity OTP ViewController
                    self?.triggerSendPhoneNumberOTPCode(userName: userName,
                                                        password: passWord,
                                                        onSuccess: onSuccess,
                                                        onError: onError)
                } else {
                    onError(TextManager.accNotActive.localized())
                }
            } else {
                onError(TextManager.loginFailMessage.localized())
            }
            
        }) {
            onError(TextManager.errorMessage.localized())
        }
    }
    
    func triggerSendPhoneNumberOTPCode(userName: String,
                                       password: String,
                                       onSuccess: @escaping () -> Void,
                                       onError: @escaping (String) -> Void) {
        let endPoint: UserEndPoint = UserEndPoint.forgotPW(bodyParams: ["PhoneNumber": userName])
        
        APIService.request(endPoint: endPoint, onSuccess: { (apiResponse) in
            guard let userId = apiResponse.data?.dictionaryValue["UserId"]?.stringValue else {
                #if DEBUG
                fatalError("TRIEUND > ForgotPW Request OTP > UserId Nil")
                #else
                return
                #endif
            }
            
            if let topViewController = UIViewController.topViewController() as? BaseViewController {
                topViewController.hideLoading()
            }
            
            UserSessionManager.shared.saveUserId(userId)
            AppRouter.pushToVerifyOTPVC(with: userName, isActiveAcc: true)
            
            }, onFailure: { (serviceError) in
                onError(TextManager.invalidEmail.localized())
        }) {
            onError(TextManager.errorMessage.localized())
        }
    }
}
