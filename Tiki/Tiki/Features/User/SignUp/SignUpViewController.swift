//
//  SignUpViewController.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 3/27/21.
//

import UIKit

class SignUpViewController: BaseViewController {
    
    // MARK: - Variables
    
    private var selectedDate = AppConfig.defaultDate
    
    // MARK: - UI Elements
    
    fileprivate let signUpTitleLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.createNewAccount.localized()
        label.textColor = UIColor.titleText
        label.font = UIFont.systemFont(ofSize: FontSize.superHeadline.rawValue)
        return label
    }()
     
    fileprivate let freePolicyLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.freePolicy.localized()
        label.textColor = UIColor.titleText
        label.font = UIFont.systemFont(ofSize: FontSize.title.rawValue)
        return label
    }()
    
    fileprivate lazy var firstNameTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.placeholder = TextManager.firstName.localized()
        textField.layer.borderColor = UIColor.separator.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = Dimension.shared.conerRadiusMedium
        textField.layer.masksToBounds = true
        textField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)
        return textField
    }()
    
    fileprivate lazy var lastNameTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.placeholder = TextManager.lastName.localized()
        textField.layer.borderColor = UIColor.separator.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = Dimension.shared.conerRadiusMedium
        textField.layer.masksToBounds = true
        textField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)
        return textField
    }()
    
    fileprivate lazy var userNameTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.placeholder = TextManager.signInUserNamePlaceHolder.localized()
        textField.layer.borderColor = UIColor.separator.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = Dimension.shared.conerRadiusMedium
        textField.layer.masksToBounds = true
        textField.keyboardType = .emailAddress
        textField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)
        return textField
    }()
    
    fileprivate lazy var passwordTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.isSecureTextEntry = true
        textField.placeholder = TextManager.password.localized()
        textField.layer.borderColor = UIColor.separator.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = Dimension.shared.conerRadiusMedium
        textField.layer.masksToBounds = true
        textField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)
        return textField
    }()
    
    fileprivate lazy var confirmpasswordTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.isSecureTextEntry = true
        textField.placeholder = TextManager.confirmPassword.localized()
        textField.layer.borderColor = UIColor.separator.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = Dimension.shared.conerRadiusMedium
        textField.layer.masksToBounds = true
        textField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)
        return textField
    }()
    
    fileprivate let DOBTitleLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.dateOfBirth.localized()
        label.textColor = UIColor.titleText
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        return label
    }()
    
    fileprivate lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.locale = Locale(identifier: "Vi")
        datePicker.datePickerMode = .date
        datePicker.minimumDate = AppConfig.minDate
        datePicker.maximumDate = Date()
        datePicker.date = selectedDate
        datePicker.addTarget(self, action: #selector(datePickerChange(_:)), for: .valueChanged)
        return datePicker
    }()
    
    fileprivate lazy var DOBTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.placeholder = TextManager.dateOfBirth.localized()
        textField.layer.borderColor = UIColor.separator.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = Dimension.shared.conerRadiusMedium
        textField.layer.masksToBounds = true
        textField.inputView = datePicker
        textField.text = selectedDate.desciption(by: DateFormat.shortDateUserFormat)
        return textField
    }()
    
    private lazy var termAndConditionLabel: NIAttributedLabel = {
        let label = NIAttributedLabel()
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        label.textColor = UIColor.bodyText
        label.linkColor = UIColor.link
        label.numberOfLines = 0
        label.delegate = self
        label.lineBreakMode = .byWordWrapping
        label.text = "Bằng cách nhấp vào Tạo tài khoản, bạn đồng ý với Điều khoản của chúng tôi và rằng bạn đã đọc Chính sách dữ liệu của chúng tôi.".localized()
        
        if let conditionRange = label.text?.range(of: "Điều khoản".localized()),
            let conditionNSRange = label.text?.nsRange(from: conditionRange) {
            label.addLink(URL(string: "https://careers.zalo.me/")!, range: conditionNSRange)
        }
        
        if let termRange = label.text?.range(of: "Chính sách dữ liệu".localized()),
            let termNSRange = label.text?.nsRange(from: termRange) {
            label.addLink(URL(string: "https://careers.zalo.me/")!, range: termNSRange)
        }
        
        return label
    }()
    
    fileprivate lazy var createAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.createAccount, for: .normal)
        button.backgroundColor = UIColor.primary
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(tapOnCreateAccountButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = TextManager.signUpAccount.localized()
        
        layoutScrollView()
        layoutTitleLabel()
        layoutFreePolicyLabel()
        layoutFirstNameTextField()
        layoutLastNameTextField()
        layoutUserNameTextField()
        layoutPasswordTextField()
        layoutConfirmPasswordTextField()
        layoutDOBTitleLabel()
        layoutDOBTextField()
        layoutTermAndConditionLabel()
        layoutCreateAccountButton()
    }
    
    
    
    @objc private func textFieldValueChange(_ textField: UITextField) {
       
    }
    
    @objc private func tapOnCreateAccountButton() {
        let verifyOTPVC = VerifyOTPViewController()
        self.navigationController?.pushViewController(verifyOTPVC, animated: true)
    }
    
    @objc private func datePickerChange(_ picker: UIDatePicker) {
        selectedDate = picker.date
        DOBTextField.text = selectedDate.desciption(by: DateFormat.shortDateUserFormat)
        textFieldValueChange(DOBTextField)
    }
    
    // MARK: - Layouts
    
    private func layoutTitleLabel() {
        scrollView.addSubview(signUpTitleLabel)
        signUpTitleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Dimension.shared.largeMargin)
            make.left.equalToSuperview().offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutFreePolicyLabel() {
        scrollView.addSubview(freePolicyLabel)
        freePolicyLabel.snp.makeConstraints { (make) in
            make.top.equalTo(signUpTitleLabel.snp.bottom).offset(Dimension.shared.normalMargin)
            make.left.equalTo(signUpTitleLabel)
        }
    }
    
    private func layoutFirstNameTextField() {
        let width = view.frame.width / 2 - Dimension.shared.largeMargin_32 - Dimension.shared.mediumMargin
        scrollView.addSubview(firstNameTextField)
        firstNameTextField.snp.makeConstraints { (make) in
            make.width.equalTo(width)
            make.height.equalTo(Dimension.shared.defaultHeightTextField)
            make.left.equalToSuperview().offset(Dimension.shared.normalMargin)
            make.top.equalTo(freePolicyLabel.snp.bottom).offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutLastNameTextField() {
        scrollView.addSubview(lastNameTextField)
        lastNameTextField.snp.makeConstraints { (make) in
            make.width.height.centerY.equalTo(firstNameTextField)
            make.right.equalTo(view)
                .offset(-Dimension.shared.normalMargin)
        }
    }
    
    private func layoutUserNameTextField() {
        scrollView.addSubview(userNameTextField)
        userNameTextField.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(Dimension.shared.normalMargin)
            make.right.equalTo(view).offset(-Dimension.shared.normalMargin)
            make.height.equalTo(Dimension.shared.defaultHeightTextField)
            make.top.equalTo(firstNameTextField.snp.bottom).offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutPasswordTextField() {
        scrollView.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { (make) in
            make.width.height.centerX.equalTo(userNameTextField)
            make.top.equalTo(userNameTextField.snp.bottom).offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutConfirmPasswordTextField() {
        scrollView.addSubview(confirmpasswordTextField)
        confirmpasswordTextField.snp.makeConstraints { (make) in
            make.width.height.centerX.equalTo(userNameTextField)
            make.top.equalTo(passwordTextField.snp.bottom).offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutDOBTitleLabel() {
        scrollView.addSubview(DOBTitleLabel)
        DOBTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(signUpTitleLabel)
            make.top.equalTo(confirmpasswordTextField.snp.bottom)
                .offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutDOBTextField() {
        scrollView.addSubview(DOBTextField)
        DOBTextField.snp.makeConstraints { (make) in
            make.left.width.height.equalTo(userNameTextField)
            make.top.equalTo(DOBTitleLabel.snp.bottom).offset(Dimension.shared.mediumMargin)
        }
    }
    
    private func layoutTermAndConditionLabel() {
        scrollView.addSubview(termAndConditionLabel)
        termAndConditionLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(userNameTextField)
            make.top.equalTo(DOBTextField.snp.bottom).offset(Dimension.shared.largeMargin)
        }
    }
    
    private func layoutCreateAccountButton() {
        scrollView.addSubview(createAccountButton)
        createAccountButton.snp.makeConstraints { (make) in
            make.top.equalTo(termAndConditionLabel.snp.bottom)
                .offset(Dimension.shared.largeMargin)
            make.bottom.equalToSuperview()
                .offset(-Dimension.shared.largeMargin)
            make.height.equalTo(50)
            make.left.equalTo(view)
                .offset(Dimension.shared.normalMargin)
            make.right.equalTo(view)
                .offset(-Dimension.shared.normalMargin)
        }
    }
    
}

// MARK: - NIAttributedLabelDelegate

extension SignUpViewController: NIAttributedLabelDelegate {
    func attributedLabel(_ attributedLabel: NIAttributedLabel!, didSelect result: NSTextCheckingResult!, at point: CGPoint) {
        guard let url = result.url else { return }
        AppRouter.pushToWebView(config: url)
    }
}

