//
//  PasswordViewController.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 3/25/21.
//

import UIKit
import SnapKit

class PasswordViewController: BaseViewController {

    // MARK: - Variables
    
    // MARK: - UI Elements
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.inputPassword
        label.font = UIFont.systemFont(ofSize: FontSize.headline.rawValue,
                                       weight: .medium)
        label.textColor = UIColor.titleText
        label.textAlignment = .left
        return label
    }()
    
    fileprivate lazy var pleaseInputPasswordLabel: UILabel = {
        let label = UILabel()
        label.attributedText = getRequiredAttibuted(from: TextManager.pleaseInputPW,
                                                    to: "0336665653")
        label.numberOfLines = 0
        return label
    }()
    
    fileprivate lazy var passwordTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.isSecureTextEntry = true
        textField.fontSizePlaceholder(text: TextManager.password,
                                      size: FontSize.title.rawValue)
        textField.padding =  UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        textField.delegate = self
        return textField
    }()
    
    fileprivate lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.separator
        return view
    }()
    
    fileprivate lazy var signInButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.signInAccount, for: .normal)
        button.backgroundColor = UIColor.primary
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(tapOnSignIn), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var forgotPWButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.second, for: .normal)
        button.setTitle(TextManager.forgotPassword, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue,
                                                    weight: .semibold)
        button.addTarget(self, action: #selector(tapOnNewPassword), for: .touchUpInside)
        return button
    }()
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = TextManager.titlePassword
        layoutTitleLabel()
        layoutPleaseInputPasswordLabel()
        layoutPasswordTextField()
        layoutLineView()
        layoutSignInButton()
        layoutForgotPassword()
     }
    
    // MARK: - Helper Method
    
    func getRequiredAttibuted(from text: String, to textAfter: String) -> NSAttributedString {
        let font = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        let fontAfter = UIFont.systemFont(ofSize: FontSize.h2.rawValue, weight: .bold)
        let attributeds = [NSAttributedString.Key.font: font,
                           NSAttributedString.Key.foregroundColor: UIColor.titleText]
        let attributedText = NSMutableAttributedString(string: text, attributes: attributeds)
        let requiredTextAttributes = [NSAttributedString.Key.font: fontAfter,
                                      NSAttributedString.Key.foregroundColor: UIColor.black]
        let requiredText = NSAttributedString(string: textAfter, attributes: requiredTextAttributes)
        attributedText.append(requiredText)
       
        return attributedText
    }
    
    
    @objc func tapOnSignIn() {
        
    }
    
    @objc func tapOnNewPassword() {
        let vc = ForgotPasswordViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
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
    
    private func layoutPleaseInputPasswordLabel() {
        view.addSubview(pleaseInputPasswordLabel)
        pleaseInputPasswordLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.right.equalToSuperview()
                .offset(-Dimension.shared.normalMargin)
            make.top.equalTo(titleLabel.snp.bottom)
                .offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutPasswordTextField() {
        view.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { (make) in
            make.top.equalTo(pleaseInputPasswordLabel.snp.bottom)
                .offset(Dimension.shared.largeMargin_32)
            make.left.equalTo(titleLabel)
            make.right.equalToSuperview()
                .offset(-Dimension.shared.normalMargin)
            make.height.equalTo(50)
        }
    }
    
    private func layoutLineView() {
        view.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(passwordTextField.snp.bottom)
            make.left.equalToSuperview()
                .offset(Dimension.shared.normalMargin)
            make.right.equalToSuperview()
                .offset(-Dimension.shared.normalMargin)
            make.height.equalTo(1)
        }
    }
    
    private func layoutSignInButton() {
        view.addSubview(signInButton)
        signInButton.snp.makeConstraints { (make) in
            make.top.equalTo(lineView.snp.bottom)
                .offset(Dimension.shared.normalMargin)
            make.left.equalToSuperview()
                .offset(Dimension.shared.normalMargin)
            make.right.equalToSuperview()
                .offset(-Dimension.shared.normalMargin)
            make.height.equalTo(50)
        }
    }
    
    private func layoutForgotPassword() {
        view.addSubview(forgotPWButton)
        forgotPWButton.snp.makeConstraints { (make) in
            make.top.equalTo(signInButton.snp.bottom)
                .offset(Dimension.shared.normalMargin)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(20)
        }
    }
}
