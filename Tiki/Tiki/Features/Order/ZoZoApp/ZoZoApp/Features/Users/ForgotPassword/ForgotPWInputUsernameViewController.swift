//
//  ForgotPWInputUsernameViewController.swift
//  ZoZoApp
//
//  Created by MACOS on 6/1/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class ForgotPWInputUsernameViewController: BaseViewController {
    
    // MARK: - UI Elements
    
    fileprivate let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = ImageManager.lock
        return imageView
    }()
    
    fileprivate let enterUserNameTitleLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.weWillSendCodeToEmail.localized()
        label.textColor = UIColor.lightBodyText
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: FontSize.body.rawValue)
        return label
    }()
    
    fileprivate lazy var userNameTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.placeholder = TextManager.signInUserNamePlaceHolder.localized()
        textField.layer.borderColor = UIColor.separator.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = Dimension.shared.defaultHeightTextField / 2
        textField.layer.masksToBounds = true
        textField.keyboardType = .emailAddress
        textField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)
        return textField
    }()
    
    fileprivate lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.next.uppercased().localized(), for: .normal)
        button.backgroundColor = UIColor.disable
        button.titleLabel?.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .medium)
        button.layer.cornerRadius = Dimension.shared.defaultHeightButton / 2
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(tapOnNextButton), for: .touchUpInside)
        button.isUserInteractionEnabled = false
        return button
    }()
    
    fileprivate let youDontHaveAccountLabel: UILabel = {
       let label = UILabel()
        label.text = TextManager.youNotHaveAccount.localized()
        label.textColor = UIColor.lightBodyText
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: FontSize.h3.rawValue)
        return label
    }()
    
    fileprivate lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.signUp.uppercased().localized(), for: .normal)
        button.setTitleColor(UIColor.link, for: .normal)
        button.addTarget(self, action: #selector(tapOnSignUp), for: .touchUpInside)
        return button
    }()
    
    // MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = TextManager.resetPWTitle.localized()
        
        layoutImageView()
        layoutEnterUserNameLabel()
        layoutUserNameTextField()
        layoutNextButton()
        layoutSignUPButton()
        layoutYouDontHaveAccountLabel()
    }
    
    // MARK: - UI Actions
    
    @objc private func textFieldValueChange(_ textField: UITextField) {
        let userName = textField.text ?? ""
        if userName.isUserName {
            nextButton.backgroundColor = UIColor.accentColor
            nextButton.isUserInteractionEnabled = true
        } else {
            nextButton.backgroundColor = UIColor.disable
            nextButton.isUserInteractionEnabled = false
        }
    }
    
    @objc private func tapOnSignUp() {
        let viewController = SignUpViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc private func tapOnNextButton() {
        guard let userName = userNameTextField.text else { return }
        var endPoint: UserEndPoint
        
        if userName.isPhoneNumber {
            endPoint = UserEndPoint.forgotPW(bodyParams: ["PhoneNumber": userName])
        } else {
            endPoint = UserEndPoint.forgotPW(bodyParams: ["Email": userName])
        }
        
        showLoading()
        
        APIService.request(endPoint: endPoint, onSuccess: { [weak self] (apiResponse) in
            guard let userId = apiResponse.data?.dictionaryValue["UserId"]?.stringValue else {
                #if DEBUG
                    fatalError("TRIEUND > ForgotPW Request OTP > UserId Nil")
                #else
                    return
                #endif
            }
            
            self?.hideLoading()
            UserSessionManager.shared.saveUserId(userId)
            AppRouter.pushToVerifyOTPVC(with: userName)
        }, onFailure: { [weak self] (serviceError) in
            self?.hideLoading()
            
            if userName.isPhoneNumber {
                AlertManager.shared.show(message: TextManager.invalidPhone.localized())
            } else {
                AlertManager.shared.show(message: TextManager.invalidEmail.localized())
            }
            
        }) { [weak self] in
            self?.hideLoading()
            AlertManager.shared.show(message: TextManager.errorMessage.localized())
        }
    }
    
    // MARK: - Setup Layouts
    
    private func layoutImageView() {
        view.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(100 * Dimension.shared.heightScale)
            make.centerX.equalToSuperview()
            if #available(iOS 11, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40 * Dimension.shared.heightScale)
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom).offset(40 * Dimension.shared.heightScale)
            }
        }
    }
    
    private func layoutEnterUserNameLabel() {
        view.addSubview(enterUserNameTitleLabel)
        enterUserNameTitleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(Dimension.shared.normalMargin)
            make.left.equalToSuperview().offset(Dimension.shared.largeMargin_32)
            make.right.equalToSuperview().offset(-Dimension.shared.largeMargin_32)
        }
    }
    
    private func layoutUserNameTextField() {
        view.addSubview(userNameTextField)
        userNameTextField.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(Dimension.shared.largeMargin_32)
            make.right.equalTo(view).offset(-Dimension.shared.largeMargin_32)
            make.height.equalTo(Dimension.shared.defaultHeightTextField)
            make.top.equalTo(enterUserNameTitleLabel.snp.bottom).offset(Dimension.shared.largeMargin)
        }
    }
    
    private func layoutNextButton() {
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { (make) in
            make.width.equalTo(Dimension.shared.smallWidthButton)
            make.height.equalTo(Dimension.shared.defaultHeightButton)
            make.left.equalTo(userNameTextField)
            make.top.equalTo(userNameTextField.snp.bottom)
                .offset(Dimension.shared.largeMargin_32)
        }
    }
    
    private func layoutSignUPButton() {
        view.addSubview(signUpButton)
        signUpButton.snp.makeConstraints { (make) in
            make.width.equalTo(Dimension.shared.mediumWidthButton)
            make.height.equalTo(Dimension.shared.defaultHeightButton)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-Dimension.shared.largeMargin_32)
        }
    }
    
    private func layoutYouDontHaveAccountLabel() {
        view.addSubview(youDontHaveAccountLabel)
        youDontHaveAccountLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(signUpButton.snp.top)
        }
    }
    
}
