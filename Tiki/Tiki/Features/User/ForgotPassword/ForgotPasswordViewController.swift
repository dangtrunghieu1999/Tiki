//
//  ForgotPasswordViewController.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 3/27/21.
//

import UIKit

class ForgotPasswordViewController: BaseViewController {

    
    // MARK: - UI Elements
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.beginPassword
        label.font = UIFont.systemFont(ofSize: FontSize.headline.rawValue,
                                       weight: .semibold)
        label.textColor = UIColor.titleText
        label.textAlignment = .left
        return label
    }()
    
    fileprivate let enterUserNameTitleLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.weWillSendCodeToEmail.localized()
        label.textColor = UIColor.titleText
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        return label
    }()
    
    fileprivate lazy var phoneTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.fontSizePlaceholder(text: TextManager.signInUserNamePlaceHolder,
                                      size: FontSize.h1.rawValue)
        textField.padding =  UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        textField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)
        textField.keyboardType = .numberPad
        textField.delegate = self
        return textField
    }()
    
    fileprivate lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.separator
        return view
    }()
    
    fileprivate lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.next, for: .normal)
        button.backgroundColor = UIColor.disable
        button.layer.cornerRadius = Dimension.shared.cornerRadiusSmall
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(tapOnNextButton), for: .touchUpInside)
        button.isUserInteractionEnabled = false
        return button
    }()
        
    // MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = TextManager.resetPWTitle.localized()
        layoutTitleLabel()
        layoutEnterUserNameLabel()
        layoutPhoneTextField()
        layoutLineView()
        layoutNextButton()

    }
    
    // MARK: - UI Actions
    
    @objc private func textFieldValueChange(_ textField: UITextField) {
        let userName = textField.text ?? ""
        if userName.isUserName {
            nextButton.backgroundColor = UIColor.primary
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
        guard let phoneNumber = self.phoneTextField.text else { return }
    
        let params   = ["phone": phoneNumber]
        let endPoint = UserEndPoint.sendOTP(bodyParams: params)
        self.showLoading()
        APIService.request(endPoint: endPoint, onSuccess: { (apiResponse) in
            self.hideLoading()
            let message = TextManager.sendCodeRecoverPWInSMS
            AppRouter.pushToVerifyOTPVCWithPhone(with: phoneNumber)
            AlertManager.shared.show(TextManager.alertTitle, message: message,
                                     buttons: [TextManager.IUnderstand.localized()],
                                     tapBlock: { (action, index) in })
        }, onFailure: { (apiError) in
            self.hideLoading()
            AlertManager.shared.show(TextManager.alertTitle, message: apiError?.message ??  " ")
        }) {
            AlertManager.shared.show(TextManager.alertTitle, message: TextManager.errorMessage)
        }
    }
    
    // MARK: - Setup Layouts
    
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

    private func layoutEnterUserNameLabel() {
        view.addSubview(enterUserNameTitleLabel)
        enterUserNameTitleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(Dimension.shared.normalMargin)
            make.left.equalToSuperview().offset(Dimension.shared.normalMargin)
            make.right.equalToSuperview().offset(-Dimension.shared.normalMargin)
        }
    }
    
    private func layoutPhoneTextField() {
        view.addSubview(phoneTextField)
        phoneTextField.snp.makeConstraints { (make) in
            make.top.equalTo(enterUserNameTitleLabel.snp.bottom)
                .offset(Dimension.shared.largeMargin_32)
            make.left.equalTo(view)
                .offset(Dimension.shared.normalMargin)
            make.right.equalToSuperview()
                .offset(-Dimension.shared.normalMargin)
            make.height.equalTo(50)
        }
    }
    
    private func layoutLineView() {
        view.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(phoneTextField.snp.bottom)
            make.left.equalToSuperview()
                .offset(Dimension.shared.normalMargin)
            make.right.equalToSuperview()
                .offset(-Dimension.shared.normalMargin)
            make.height.equalTo(1)
        }
    }
    
    private func layoutNextButton() {
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { (make) in
            make.height.equalTo(Dimension.shared.largeHeightButton)
            make.left.equalTo(phoneTextField)
            make.right.equalTo(view)
                .offset(-Dimension.shared.normalMargin)
            make.top.equalTo(lineView.snp.bottom)
                .offset(Dimension.shared.largeMargin_32)
        }
    }
    
}
