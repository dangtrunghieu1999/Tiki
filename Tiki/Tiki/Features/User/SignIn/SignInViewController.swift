//
//  SignInViewController.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 3/13/21.
//

import UIKit

protocol SignInViewControllerDelegate: class {
    func reloadUserInfo()
}

class SignInViewController: BaseViewController {
    
    // MARK: - Variables
    weak var delegate: SignInViewControllerDelegate?
    // MARK: - UI Elements
    
    fileprivate lazy var bannerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "banner")
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    fileprivate lazy var closeViewButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.dismiss_close, for: .normal)
        button.backgroundColor = .clear
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(touchUpInLeftBarButtonItem),
                         for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.welcomeSignIn
        label.textColor = UIColor.titleText
        label.font = UIFont.systemFont(ofSize: FontSize.headline.rawValue,
                                       weight: .semibold)
        label.textAlignment = .left
        return label
    }()
    
    fileprivate lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.signIn
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        label.textAlignment = .left
        return label
    }()
    
    fileprivate lazy var phoneTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.keyboardType = .numberPad
        textField.fontPlaceholder(text: TextManager.phoneNumber,
                                      size: FontSize.h1.rawValue)
        textField.padding =  UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        textField.addTarget(self, action: #selector(textFieldValueChange(_:))
                            , for: .editingChanged)
        textField.delegate = self
        return textField
    }()
    
    fileprivate lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.separator
        return view
    }()
    
    fileprivate lazy var continueButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.continueSignIn, for: .normal)
        button.backgroundColor = UIColor.disable
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        button.isUserInteractionEnabled = false
        button.addTarget(self, action: #selector(tapOnPassword), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.second, for: .normal)
        button.setTitle(TextManager.signUp, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue,
                                                    weight: .semibold)
        button.addTarget(self, action: #selector(tapOnSignUp), for: .touchUpInside)
        return button
    }()
    
    private let containerView: BaseView = {
        let view = BaseView()
        return view
    }()

    fileprivate lazy var lineTitleLabel: TitleCenterLineView = {
        let label = TitleCenterLineView()
        label.titleText = TextManager.optionSignIn
        label.titleLabel.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        return label
    }()
    
    fileprivate lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    lazy var facebookSignInButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.facebook, for: .normal)
        return button
    }()
    
    lazy var googleSignInButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.google, for: .normal)
        return button
    }()
    
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutBannerImageView()
        layoutCloseViewButton()
        layoutTitleLabel()
        layoutSubTitleLabel()
        layoutPhoneTextField()
        layoutLineView()
        layoutContinueButton()
        layoutSignUpButton()
        layoutContainerView()
        layoutLineTitleLabel()
        layoutButtonStackView()
        layoutFaceBookSignInButton()
        layoutGoogleSignInButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @objc private func textFieldValueChange(_ textField: UITextField) {
        guard let phoneNumber = self.phoneTextField.text else { return }
        if phoneNumber != "" {
            continueButton.isUserInteractionEnabled = true
            continueButton.backgroundColor = UIColor.primary
        } else {
            continueButton.isUserInteractionEnabled = false
            continueButton.backgroundColor = UIColor.disable
        }
    }
    
    // MARK: - Helper Method
    
    override func touchUpInLeftBarButtonItem() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func tapOnPassword() {
        let vc = PasswordViewController()
        vc.delegate = self
        guard let check = self.phoneTextField.text?.isPhoneNumber else { return }
        if check {
            vc.username = self.phoneTextField.text ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            AlertManager.shared.show(TextManager.alertTitle,
                                     message: TextManager.invalidPhone)
        }
    }
    
    @objc func tapOnSignUp() {
        let vc = SignUpViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - GET API
    
    // MARK: - Layout
    
    private func layoutBannerImageView() {
        view.addSubview(bannerImageView)
        bannerImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.height.equalTo(200)
            make.left.right.equalToSuperview()
        }
    }
    
    private func layoutCloseViewButton() {
        view.addSubview(closeViewButton)
        closeViewButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
                .offset(dimension.normalMargin)
            make.width.height.equalTo(25)
            make.top.equalToSuperview()
                .offset(dimension.largeMargin_32)
        }
    }
    
    private func layoutTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(bannerImageView.snp.bottom)
                .offset(dimension.largeMargin)
            make.left.equalToSuperview()
                .offset(dimension.normalMargin)
            make.right.equalToSuperview()
        }
    }
    
    private func layoutSubTitleLabel() {
        view.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom)
                .offset(dimension.normalMargin)
        }
    }
    
    private func layoutPhoneTextField() {
        view.addSubview(phoneTextField)
        phoneTextField.snp.makeConstraints { (make) in
            make.top
                .equalTo(subtitleLabel.snp.bottom)
                .offset(dimension.normalMargin)
            make.left
                .equalTo(titleLabel)
            make.right.equalToSuperview()
                .offset(-dimension.normalMargin)
            make.height.equalTo(50)
        }
    }
    
    private func layoutLineView() {
        view.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.top
                .equalTo(phoneTextField.snp.bottom)
            make.left
                .right
                .equalToSuperview()
                .inset(dimension.normalMargin)
            make.height.equalTo(1)
        }
    }
    
    private func layoutContinueButton() {
        view.addSubview(continueButton)
        continueButton.snp.makeConstraints { (make) in
            make.left
                .right
                .equalTo(phoneTextField)
            make.height.equalTo(50)
            make.top
                .equalTo(lineView.snp.bottom)
                .offset(dimension.largeMargin_32)
        }
    }
    
    private func layoutSignUpButton() {
        view.addSubview(signUpButton)
        signUpButton.snp.makeConstraints { (make) in
            make.top
                .equalTo(continueButton.snp.bottom)
                .offset(dimension.normalMargin)
            make.centerX
                .equalToSuperview()
            make.width
                .equalTo(100)
            make.height
                .equalTo(20)
        }
    }
        
    private func layoutContainerView() {
        view.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.top
                .equalTo(signUpButton.snp.bottom)
                .offset(dimension.largeMargin_32)
            make.left
                .right
                .equalToSuperview()
                .inset(dimension.normalMargin)
            make.height.equalTo(20)
        }
    }
    
    private func layoutLineTitleLabel() {
        containerView.addSubview(lineTitleLabel)
        lineTitleLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func layoutButtonStackView() {
        view.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints { (make) in
            make.top
                .equalTo(containerView.snp.bottom)
                .offset(dimension.largeMargin_32)
            make.width
                .equalTo(116)
            make.centerX
                .equalToSuperview()
        }
    }
    
    private func layoutFaceBookSignInButton() {
        buttonStackView.addArrangedSubview(facebookSignInButton)
        facebookSignInButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(50)
        }
    }
    
    private func layoutGoogleSignInButton() {
        buttonStackView.addArrangedSubview(googleSignInButton)
        googleSignInButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(50)
        }
    }
    
}

// MARK: - NIAttributedLabelDelegate

extension SignInViewController: NIAttributedLabelDelegate {
    func attributedLabel(_ attributedLabel: NIAttributedLabel!,
                         didSelect result: NSTextCheckingResult!, at point: CGPoint) {
        guard let url = result.url else { return }
        AppRouter.pushToWebView(config: url)
    }
}

extension SignInViewController: PasswordViewControllerDelegate {
    func handleLoginSuccess() {
        self.dismiss(animated: false) {
            self.delegate?.reloadUserInfo()
        }
    }
}
