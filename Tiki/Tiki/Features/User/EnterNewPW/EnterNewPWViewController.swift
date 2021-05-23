//
//  EnterNewPWViewController.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 3/27/21.
//

import UIKit

class EnterNewPWViewController: BaseViewController {
    
    // MARK: - Variables
    var userId = ""
    
    // MARK: - UI Elements
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.beginPassword
        label.font = UIFont.systemFont(ofSize: FontSize.headline.rawValue,
                                       weight: .medium)
        label.textColor = UIColor.titleText
        label.textAlignment = .left
        return label
    }()
    
    fileprivate let continuePasswordTitleLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.continuePassword
        label.textColor = UIColor.titleText
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        return label
    }()
    
    fileprivate lazy var passwordTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.fontSizePlaceholder(text: TextManager.password,
                                      size: FontSize.body.rawValue)
        textField.padding =  UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        textField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)
        textField.delegate = self
        textField.isSecureTextEntry = true
        return textField
    }()
    
    fileprivate lazy var firstLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.separator
        return view
    }()
    
    fileprivate lazy var confirmPasswordTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.fontSizePlaceholder(text: TextManager.confirmPW,
                                      size: FontSize.body.rawValue)
        textField.padding =  UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        textField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)
        textField.delegate = self
        textField.isSecureTextEntry = true
        return textField
    }()

    fileprivate lazy var secondLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.separator
        return view
    }()
    
    fileprivate lazy var changePasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.changePassword, for: .normal)
        button.backgroundColor = UIColor.disable
        button.layer.cornerRadius = Dimension.shared.cornerRadiusSmall
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(tapOnNextButton), for: .touchUpInside)
        button.isUserInteractionEnabled = false
        return button
    }()

    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Tạo mật khẩu mới"
        layoutTitleLabel()
        layoutContinuePasswordTitleLabel()
        layoutPasswordTextField()
        layoutFirstLineView()
        layoutConfirmPasswordTextField()
        layoutSecondLineView()
        layoutChangePasswordButton()
        
    }
    
    // MARK: - UI Actions
    
    @objc private func textFieldValueChange(_ textField: UITextField) {
        guard let password          = passwordTextField.text else { return }
        guard let confirmPassword   = confirmPasswordTextField.text else { return }
        
        if password != "" && confirmPassword != "" {
            changePasswordButton.backgroundColor = UIColor.primary
            changePasswordButton.isUserInteractionEnabled = true
        } else {
            changePasswordButton.backgroundColor = UIColor.disable
            changePasswordButton.isUserInteractionEnabled = false
        }
    }
    
    @objc private func tapOnNextButton() {
        
        guard let password = passwordTextField.text else { return }
        
        let endPoint = UserEndPoint.forgotPW(bodyParams: ["userId": userId,
                                                        "password": password])
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
    
    // MARK: - Helper Method
    
    // MARK: - GET API
    
    // MARK: - Layout
    
    private func layoutTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
                .offset(Dimension.shared.normalMargin)
            if #available(iOS 11, *) {
                make.top.equalTo(view.safeAreaLayoutGuide)
                    .offset(Dimension.shared.largeMargin_32)
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom)
                    .offset(Dimension.shared.largeMargin_32)
            }
            make.right.equalToSuperview()
        }
    }

    private func layoutContinuePasswordTitleLabel() {
        view.addSubview(continuePasswordTitleLabel)
        continuePasswordTitleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(Dimension.shared.normalMargin)
            make.left.equalToSuperview().offset(Dimension.shared.normalMargin)
            make.right.equalToSuperview().offset(-Dimension.shared.normalMargin)
        }
    }
    
    private func layoutPasswordTextField() {
        view.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { (make) in
            make.top.equalTo(continuePasswordTitleLabel.snp.bottom)
                .offset(Dimension.shared.largeMargin_32)
            make.left.equalTo(view)
                .offset(Dimension.shared.normalMargin)
            make.right.equalToSuperview()
                .offset(-Dimension.shared.normalMargin)
            make.height.equalTo(50)
        }
    }
    
    private func layoutFirstLineView() {
        view.addSubview(firstLineView)
        firstLineView.snp.makeConstraints { (make) in
            make.top.equalTo(passwordTextField.snp.bottom)
            make.left.equalToSuperview()
                .offset(Dimension.shared.normalMargin)
            make.right.equalToSuperview()
                .offset(-Dimension.shared.normalMargin)
            make.height.equalTo(1)
        }
    }
    
    private func layoutConfirmPasswordTextField() {
        view.addSubview(confirmPasswordTextField)
        confirmPasswordTextField.snp.makeConstraints { (make) in
            make.top.equalTo(firstLineView.snp.bottom)
                .offset(Dimension.shared.largeMargin_32)
            make.left.equalTo(view)
                .offset(Dimension.shared.normalMargin)
            make.right.equalToSuperview()
                .offset(-Dimension.shared.normalMargin)
            make.height.equalTo(50)
        }
    }
    
    private func layoutSecondLineView() {
        view.addSubview(secondLineView)
        secondLineView.snp.makeConstraints { (make) in
            make.top.equalTo(confirmPasswordTextField.snp.bottom)
            make.left.equalToSuperview()
                .offset(Dimension.shared.normalMargin)
            make.right.equalToSuperview()
                .offset(-Dimension.shared.normalMargin)
            make.height.equalTo(1)
        }
    }
    
    private func layoutChangePasswordButton() {
        view.addSubview(changePasswordButton)
        changePasswordButton.snp.makeConstraints { (make) in
            make.height.equalTo(Dimension.shared.largeHeightButton)
            make.left.equalTo(passwordTextField)
            make.right.equalTo(view)
                .offset(-Dimension.shared.normalMargin)
            make.top.equalTo(secondLineView.snp.bottom)
                .offset(Dimension.shared.largeMargin_32)
        }
    }

}
