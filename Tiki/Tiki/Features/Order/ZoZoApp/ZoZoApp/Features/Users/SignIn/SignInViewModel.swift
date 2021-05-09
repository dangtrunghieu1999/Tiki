//
//  SignInViewModel.swift
//  ZoZoApp
//
//  Created by MACOS on 5/31/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import Foundation
import Alamofire

class SignInViewModel: BaseViewModel {
    
    // MARK: - Variables
    
    private (set) var titles = [TextManager.connectFriend,
                                TextManager.commentFriendShare,
                                TextManager.followYourFavorite,
                                TextManager.buyAndSave,
                                TextManager.bussinessAndEarnMoney]
    
    private (set) var images = [ImageManager.connectFriend,
                                ImageManager.commentFriendShare,
                                ImageManager.followYourFavorite,
                                ImageManager.buyAndSave,
                                ImageManager.earnMoneySignIn]
    
    // MARK: - LifeCycles
    
    override func initialize() {}
    
    // MARK: - Public methods
    
    func canSignIn(userName: String?, passWord: String?) -> Bool {
        return (userName != nil && userName != "" && passWord != nil && passWord != "")
    }
    
    func requestSignIn(userName: String,
                       passWord: String,
                       onSuccess: @escaping () -> Void,
                       onError: @escaping (String) -> Void) {
        
        let params = ["UserName": userName, "Password": passWord]
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
