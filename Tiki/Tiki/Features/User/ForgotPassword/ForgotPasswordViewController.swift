//
//  ForgotPasswordViewController.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 3/27/21.
//

import UIKit

class ForgotPasswordViewController: BaseViewController {

    
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
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: FontSize.body.rawValue)
        return label
    }()
    
    fileprivate lazy var phoneTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.fontSizePlaceholder(text: TextManager.signInUserNamePlaceHolder,
                                      size: FontSize.title.rawValue)
        textField.padding =  UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return textField
    }()
    
    fileprivate lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.separator
        return view
    }()
    
    fileprivate lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.next.uppercased().localized(), for: .normal)
        button.backgroundColor = UIColor.primary
        button.layer.cornerRadius = Dimension.shared.cornerRadiusSmall
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
        layoutPhoneTextField()
        layoutLineView()
        layoutNextButton()
        layoutSignUPButton()
        layoutYouDontHaveAccountLabel()
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
            make.left.equalToSuperview().offset(Dimension.shared.normalMargin)
            make.right.equalToSuperview().offset(-Dimension.shared.normalMargin)
        }
    }
    
    private func layoutPhoneTextField() {
        view.addSubview(phoneTextField)
        phoneTextField.snp.makeConstraints { (make) in
            make.top.equalTo(enterUserNameTitleLabel.snp.bottom)
                .offset(Dimension.shared.normalMargin)
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
