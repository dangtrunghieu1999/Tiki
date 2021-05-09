//
//  ViewController.swift
//  ZoZoApp
//
//  Created by MACOS on 5/30/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit
import SnapKit
import Localize_Swift

class SignInViewController: BaseViewController {
    
    // MARK: - Variables
    
    fileprivate let titleCellHeight: CGFloat = 42
    
    fileprivate lazy var viewModel: SignInViewModel = {
        let viewModel = SignInViewModel()
        return viewModel
    }()
    
    // MARK: - UI Elements
    
    fileprivate let signInTitleLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.signIn.localized()
        label.textColor = UIColor.titleText
        label.font = UIFont.systemFont(ofSize: FontSize.superHeadline.rawValue)
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
    
    fileprivate lazy var passwordTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.isSecureTextEntry = true
        textField.placeholder = TextManager.password.localized()
        textField.layer.borderColor = UIColor.separator.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = Dimension.shared.defaultHeightTextField / 2
        textField.layer.masksToBounds = true
        textField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)
        return textField
    }()
    
    fileprivate lazy var signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.disable
        button.setTitle(TextManager.signIn.uppercased().localized(), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .medium)
        button.layer.cornerRadius = Dimension.shared.defaultHeightButton / 2
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(tapOnSignIn), for: .touchUpInside)
        button.isUserInteractionEnabled = false
        return button
    }()
    
    fileprivate lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.signUpAccount.localized(), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        button.setTitleColor(UIColor.accentColor, for: .normal)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(tapOnSignUp), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var forgotPasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.forgotPassword.localized(), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        button.setTitleColor(UIColor.background, for: .normal)
        button.addTarget(self, action: #selector(tapOnForgotPassword), for: .touchUpInside)
        button.contentHorizontalAlignment = .right
        return button
    }()
    
    fileprivate lazy var titleCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = UIColor.white
        collectionView.registerReusableCell(SignInTitleCollectionViewCell.self)
        return collectionView
    }()
    
    // MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBarButtonItems()
        layoutScrollView()
        layoutSignInTitleLabel()
        layoutUserNameTextField()
        layoutPasswordTextField()
        layoutSignInButton()
        layoutSignUpButton()
        layoutForgotPasswordButton()
        layoutTitlesCollectionView()
    }
    
    // MARK: - UI Actions
    
    @objc private func tapOnSignIn() {
        guard let userName = userNameTextField.text, let passWord = passwordTextField.text else {
            return
        }
        
        showLoading()
        
        viewModel.requestSignIn(userName: userName, passWord: passWord, onSuccess: {
            self.hideLoading()
            guard let window = UIApplication.shared.keyWindow else { return }
            window.rootViewController = ZTabBarViewController()
        }) { (message) in
            self.hideLoading()
            AlertManager.shared.show(TextManager.alertTitle.localized(), message: message)
        }
    }
    
    @objc private func tapOnSignUp() {
        let signUpVC = SignUpViewController()
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    @objc private func tapOnForgotPassword() {
        let forgotPWVC = ForgotPWInputUsernameViewController()
        navigationController?.pushViewController(forgotPWVC, animated: true)
    }
    
    @objc private func textFieldValueChange(_ textField: UITextField) {
        if (viewModel.canSignIn(userName: userNameTextField.text, passWord: passwordTextField.text)) {
            signInButton.isUserInteractionEnabled = true
            signInButton.backgroundColor = UIColor.accentColor
        } else {
            signInButton.isUserInteractionEnabled = false
            signInButton.backgroundColor = UIColor.disable
        }
    }
    
    // MARK: - Layouts
    
    private func addBarButtonItems() {
        let imageView = UIImageView(image: ImageManager.logoTransparentSmall)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 60, height: 21)
        let logoItem = UIBarButtonItem(customView: imageView)
        
        let fakeView = UIView()
        fakeView.backgroundColor = UIColor.clear
        fakeView.frame = CGRect(x: 0, y: 0, width: 9 * Dimension.shared.widthScale, height: 20)
        let fakeItem = UIBarButtonItem(customView: fakeView)
        
        navigationItem.leftBarButtonItems = [fakeItem, logoItem]
    }
    
    private func layoutSignInTitleLabel() {
        scrollView.addSubview(signInTitleLabel)
        signInTitleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Dimension.shared.largeMargin_32)
            make.top.equalToSuperview().offset(Dimension.shared.largeMargin)
        }
    }
    
    private func layoutUserNameTextField() {
        scrollView.addSubview(userNameTextField)
        userNameTextField.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(Dimension.shared.largeMargin_32)
            make.right.equalTo(view).offset(-Dimension.shared.largeMargin_32)
            make.height.equalTo(Dimension.shared.defaultHeightTextField)
            make.top.equalTo(signInTitleLabel.snp.bottom).offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutPasswordTextField() {
        scrollView.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { (make) in
            make.width.height.centerX.equalTo(userNameTextField)
            make.top.equalTo(userNameTextField.snp.bottom).offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutSignInButton() {
        scrollView.addSubview(signInButton)
        signInButton.snp.makeConstraints { (make) in
            make.height.equalTo(Dimension.shared.defaultHeightButton)
            make.left.equalTo(signInTitleLabel)
            make.width.equalTo(Dimension.shared.smallWidthButton)
            make.top.equalTo(passwordTextField.snp.bottom).offset(Dimension.shared.largeMargin)
        }
    }
    
    private func layoutSignUpButton() {
        scrollView.addSubview(signUpButton)
        signUpButton.snp.makeConstraints { (make) in
            make.width.equalTo(Dimension.shared.mediumWidthButton)
            make.height.equalTo(signUpButton)
            make.left.equalTo(signInButton)
            make.top.equalTo(signInButton.snp.bottom).offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutForgotPasswordButton() {
        scrollView.addSubview(forgotPasswordButton)
        forgotPasswordButton.snp.makeConstraints { (make) in
            make.width.equalTo(120)
            make.height.equalTo(signUpButton)
            make.right.equalTo(userNameTextField)
            make.centerY.equalTo(signInButton)
        }
    }
    
    private func layoutTitlesCollectionView() {
        let height = CGFloat(viewModel.titles.count) * titleCellHeight
        scrollView.addSubview(titleCollectionView)
        titleCollectionView.snp.makeConstraints { (make) in
            make.height.equalTo(height)
            make.left.right.equalTo(userNameTextField)
            make.top.equalTo(signUpButton.snp.bottom).offset(Dimension.shared.normalMargin)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
}

// MARK: - UICollectionViewDataSource

extension SignInViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SignInTitleCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.configCell(image: viewModel.images[indexPath.row], titile: viewModel.titles[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SignInViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: titleCellHeight)
    }
}
