//
//  VerifyCodeViewController.swift
//  ZoZoApp
//
//  Created by MACOS on 6/4/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class VerifyOTPViewController: BaseViewController {

    var userName: String = ""
    var isActiveAccount = false
    
    // MARK: - UI Elements
    
    fileprivate let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = ImageManager.sendMail
        return imageView
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        if !isActiveAccount && userName.isPhoneNumber {
            label.text = TextManager.sendCodeRecoverPWInSMS.localized()
        } else if !isActiveAccount && userName.isValidEmail {
            label.text = TextManager.sendCodeRecoverPWInEmail.localized()
        } else if isActiveAccount {
            label.text = TextManager.sendCodeActiveAccInSMS.localized()
        } else {
            label.text = TextManager.defaultSendCodeMessage.localized()
        }
        
        label.textColor = UIColor.lightBodyText
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: FontSize.body.rawValue)
        return label
    }()
    
    fileprivate lazy var enterCodeTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.placeholder = TextManager.yourCode.localized()
        textField.layer.borderColor = UIColor.separator.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = Dimension.shared.defaultHeightTextField / 2
        textField.layer.masksToBounds = true
        textField.keyboardType = .numberPad
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
    
    private lazy var resendCodeLabel: NIAttributedLabel = {
        let label = NIAttributedLabel()
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        label.textColor = UIColor.bodyText
        label.linkColor = UIColor.link
        label.numberOfLines = 0
        label.delegate = self
        label.lineBreakMode = .byWordWrapping
        label.text = TextManager.resendCodeAgain.localized()
        
        if let conditionRange = label.text?.range(of: "Thử lại".localized()),
            let conditionNSRange = label.text?.nsRange(from: conditionRange) {
            label.addLink(URL(string: "https://careers.zalo.me/")!, range: conditionNSRange)
        }

        return label
    }()
    
    // MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = TextManager.verifyCode.localized()
        
        layoutImageView()
        layoutMessageLabel()
        layoutEnterCodeTextField()
        layoutNextButton()
        layoutResendCode()
        
    }
    
    // MARK: - UI Actions
    
    @objc private func textFieldValueChange(_ textField: UITextField) {
        let userName = textField.text ?? ""
        if userName != "" {
            nextButton.backgroundColor = UIColor.accentColor
            nextButton.isUserInteractionEnabled = true
        } else {
            nextButton.backgroundColor = UIColor.disable
            nextButton.isUserInteractionEnabled = false
        }
    }
    
    @objc private func tapOnNextButton() {
        guard let code = enterCodeTextField.text else { return }
        let endPoint = UserEndPoint.checkValidCode(bodyParams: ["UserId": UserManager.userId ?? "",
                                                                "Code": code])
        
        APIService.request(endPoint: endPoint, onSuccess: { [weak self] (apiResponse) in
            if self?.isActiveAccount ?? false {
                AlertManager.shared.show(message: TextManager.activeAccSuccess.localized())
                UIViewController.setRootVCBySinInVC()
            } else {
                let enterNewPWVC = EnterNewPWViewController()
                enterNewPWVC.code = code
                self?.navigationController?.pushViewController(enterNewPWVC, animated: true)
            }
            
        }, onFailure: { (apiError) in
            AlertManager.shared.show(message: TextManager.invalidCode.localized())
        }) {
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
    
    private func layoutMessageLabel() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(Dimension.shared.normalMargin)
            make.left.equalToSuperview().offset(Dimension.shared.largeMargin_32)
            make.right.equalToSuperview().offset(-Dimension.shared.largeMargin_32)
        }
    }
    
    private func layoutEnterCodeTextField() {
        view.addSubview(enterCodeTextField)
        enterCodeTextField.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(Dimension.shared.largeMargin_32)
            make.right.equalTo(view).offset(-Dimension.shared.largeMargin_32)
            make.height.equalTo(Dimension.shared.defaultHeightTextField)
            make.top.equalTo(titleLabel.snp.bottom).offset(Dimension.shared.largeMargin)
        }
    }
    
    private func layoutNextButton() {
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { (make) in
            make.width.equalTo(Dimension.shared.smallWidthButton)
            make.height.equalTo(Dimension.shared.defaultHeightButton)
            make.left.equalTo(enterCodeTextField)
            make.top.equalTo(enterCodeTextField.snp.bottom)
                .offset(Dimension.shared.largeMargin_32)
        }
    }
    
    private func layoutResendCode() {
        view.addSubview(resendCodeLabel)
        resendCodeLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-Dimension.shared.largeMargin_32)
        }
    }

}

// MARK: - NIAttributedLabelDelegate

extension VerifyOTPViewController: NIAttributedLabelDelegate {
    func attributedLabel(_ attributedLabel: NIAttributedLabel!,
                         didSelect result: NSTextCheckingResult!,
                         at point: CGPoint) {
        
        var endPoint: UserEndPoint
        
        if userName.isPhoneNumber {
            endPoint = UserEndPoint.forgotPW(bodyParams: ["PhoneNumber": userName])
        } else {
            endPoint = UserEndPoint.forgotPW(bodyParams: ["Email": userName])
        }
        
        self.showLoading()
        APIService.request(endPoint: endPoint, onSuccess: { [weak self] (apiResponse) in
            guard let userId = apiResponse.data?.dictionaryValue["UserId"]?.stringValue else {
                #if DEBUG
                fatalError("TRIEUND > ForgotPW Request OTP > UserId Nil")
                #else
                return
                #endif
            }
            
            UserSessionManager.shared.saveUserId(userId)
            self?.hideLoading()
            }, onFailure: { (serviceError) in
                self.hideLoading()
                
                if self.userName.isPhoneNumber {
                    AlertManager.shared.show(message: TextManager.invalidPhone.localized())
                } else {
                    AlertManager.shared.show(message: TextManager.invalidEmail.localized())
                }
        }) {
            self.hideLoading()
            AlertManager.shared.show(message: TextManager.errorMessage.localized())
        }
    }
}
