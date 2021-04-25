//
//  EnterNewPWViewController.swift
//  ZoZoApp
//
//  Created by MACOS on 6/4/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class EnterNewPWViewController: BaseViewController {
    
    // MARK: - Variables
    
    var code: String = ""
    
    // MARK: - UI Elements
    
    fileprivate let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = ImageManager.unLock
        return imageView
    }()
    
    fileprivate let titleLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.oneStepToResetPW.localized()
        label.textColor = UIColor.lightBodyText
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: FontSize.body.rawValue)
        return label
    }()
    
    fileprivate lazy var newPWTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.placeholder = TextManager.password.localized()
        textField.layer.borderColor = UIColor.separator.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = Dimension.shared.defaultHeightTextField / 2
        textField.layer.masksToBounds = true
        textField.isSecureTextEntry = true
        textField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)
        return textField
    }()
    
    fileprivate lazy var confimNewPWTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.placeholder = TextManager.confirmPW.localized()
        textField.layer.borderColor = UIColor.separator.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = Dimension.shared.defaultHeightTextField / 2
        textField.layer.masksToBounds = true
        textField.isSecureTextEntry = true
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
    
    // MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = TextManager.resetPWTitle.localized()
        
        layoutImageView()
        layoutMessageLabel()
        layoutNewPWTextField()
        layoutConfimNewPWTextField()
        layoutNextButton()
    }
    
    // MARK: - UI Actions
    
    @objc private func textFieldValueChange(_ textField: UITextField) {
        let passWord = newPWTextField.text ?? ""
        let confirmPassWord = confimNewPWTextField.text ?? ""
        if passWord != "" && confirmPassWord != "" {
            nextButton.backgroundColor = UIColor.accentColor
            nextButton.isUserInteractionEnabled = true
        } else {
            nextButton.backgroundColor = UIColor.disable
            nextButton.isUserInteractionEnabled = false
        }
    }
    
    @objc private func tapOnNextButton() {
        let passWord = newPWTextField.text ?? ""
        let confirmPassWord = confimNewPWTextField.text ?? ""
        
        if (passWord != confirmPassWord) {
            AlertManager.shared.show(message: TextManager.passwordNotMatch.localized())
            return
        }
        
        let endPoint = UserEndPoint.createNewPW(bodyParams: ["UserId": UserManager.userId ?? "",
                                                             "NewPassword": passWord,
                                                             "Code": code])
        
        APIService.request(endPoint: endPoint, onSuccess: { (apiResponse) in
            AlertManager.shared.show(TextManager.alertTitle.localized(),
                                     message: TextManager.resetPWSuccessMessage.localized(),
                                     buttons: [TextManager.IUnderstand.localized()],
                                     tapBlock: { (action, index) in
                                        UIViewController.setRootVCBySinInVC()
            })
        }, onFailure: { (apiError) in
            AlertManager.shared.show(TextManager.alertTitle.localized(),
                                     message: TextManager.errorMessage.localized())
        }) {
            AlertManager.shared.show(TextManager.alertTitle.localized(),
                                     message: TextManager.errorMessage.localized())
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
    
    private func layoutNewPWTextField() {
        view.addSubview(newPWTextField)
        newPWTextField.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(Dimension.shared.largeMargin_32)
            make.right.equalTo(view).offset(-Dimension.shared.largeMargin_32)
            make.height.equalTo(Dimension.shared.defaultHeightTextField)
            make.top.equalTo(titleLabel.snp.bottom).offset(Dimension.shared.largeMargin)
        }
    }
    
    private func layoutConfimNewPWTextField() {
        view.addSubview(confimNewPWTextField)
        confimNewPWTextField.snp.makeConstraints { (make) in
            make.width.height.centerX.equalTo(newPWTextField)
            make.top.equalTo(newPWTextField.snp.bottom).offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutNextButton() {
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { (make) in
            make.width.equalTo(Dimension.shared.smallWidthButton)
            make.height.equalTo(Dimension.shared.defaultHeightButton)
            make.left.equalTo(newPWTextField)
            make.top.equalTo(confimNewPWTextField.snp.bottom)
                .offset(Dimension.shared.largeMargin_32)
        }
    }
    
}
