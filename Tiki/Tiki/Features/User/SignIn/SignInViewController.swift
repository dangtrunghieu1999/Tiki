//
//  SignInViewController.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 3/13/21.
//

import UIKit

class SignInViewController: BaseViewController {
    
    // MARK: - Variables
    
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
        button.addTarget(self, action: #selector(touchUpInLeftBarButtonItem), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.welcomeSignIn
        label.textColor = UIColor.titleText
        label.font = UIFont.systemFont(ofSize: FontSize.headline.rawValue, weight: .semibold)
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
        textField.fontSizePlaceholder(text: TextManager.phoneNumber,
                                      size: FontSize.title.rawValue)
        textField.padding =  UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
        button.backgroundColor = UIColor.primary
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
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
    
    private lazy var termAndConditionLabel: NIAttributedLabel = {
        let label = NIAttributedLabel()
        label.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        label.textColor = UIColor.bodyText
        label.linkColor = UIColor.link
        label.numberOfLines = 1
        label.delegate = self
        label.lineBreakMode = .byWordWrapping
        label.text = TextManager.continueRules
        if let conditionRange = label.text?.range(of: "điều khoản sử dụng".localized()),
           let conditionNSRange = label.text?.nsRange(from: conditionRange) {
            label.addLink(URL(string: "https://careers.zalo.me/")!, range: conditionNSRange)
        }
        return label
    }()
    
    fileprivate lazy var facebookButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.facebook, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Dimension.shared.largeHeightButton / 2
        button.backgroundColor = .clear
        return button
    }()

    fileprivate lazy var googleButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.google, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Dimension.shared.largeHeightButton / 2
        button.backgroundColor = .clear
        return button
    }()
    
    fileprivate lazy var optionSignInLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.optionSignIn
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        label.textAlignment = .center
        label.textColor = UIColor.bodyText
        return label
    }()
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        layoutBannerImageView()
        layoutCloseViewButton()
        layoutTitleLabel()
        layoutSubTitleLabel()
        layoutPhoneTextField()
        layoutLineView()
        layoutContinueButton()
        layoutSignUpButton()
        layoutTermAndConditionLabel()
        layoutFacebookButton()
        layoutGoogleButton()
        layoutOptionSignInLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - Helper Method
    
    override func touchUpInLeftBarButtonItem() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func tapOnPassword() {
        let vc = PasswordViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        
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
                .offset(Dimension.shared.normalMargin)
            make.width.height.equalTo(25)
            make.top.equalToSuperview()
                .offset(Dimension.shared.largeMargin)
        }
    }
    
    private func layoutTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(bannerImageView.snp.bottom)
                .offset(Dimension.shared.largeMargin)
            make.left.equalToSuperview()
                .offset(Dimension.shared.normalMargin)
            make.right.equalToSuperview()
        }
    }
    
    private func layoutSubTitleLabel() {
        view.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom)
                .offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutPhoneTextField() {
        view.addSubview(phoneTextField)
        phoneTextField.snp.makeConstraints { (make) in
            make.top.equalTo(subtitleLabel.snp.bottom)
                .offset(Dimension.shared.normalMargin)
            make.left.equalTo(titleLabel)
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
    
    private func layoutContinueButton() {
        view.addSubview(continueButton)
        continueButton.snp.makeConstraints { (make) in
            make.left.right.equalTo(phoneTextField)
            make.height.equalTo(50)
            make.top.equalTo(lineView.snp.bottom)
                .offset(Dimension.shared.largeMargin_32)
        }
    }
    
    private func layoutSignUpButton() {
        view.addSubview(signUpButton)
        signUpButton.snp.makeConstraints { (make) in
            make.top.equalTo(continueButton.snp.bottom)
                .offset(Dimension.shared.mediumMargin_12)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
    }
    
    private func layoutTermAndConditionLabel() {
        view.addSubview(termAndConditionLabel)
        termAndConditionLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
                .offset(-Dimension.shared.normalMargin)
        }
    }
    
    private func layoutFacebookButton() {
        view.addSubview(facebookButton)
        facebookButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(termAndConditionLabel.snp.top)
                .offset(-Dimension.shared.normalMargin)
            make.centerX.equalToSuperview()
                .offset(-Dimension.shared.largeMargin_32)
            make.width.height.equalTo(Dimension.shared.largeHeightButton)
        }
    }
    
    private func layoutGoogleButton() {
        view.addSubview(googleButton)
        googleButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(termAndConditionLabel.snp.top)
                .offset(-Dimension.shared.normalMargin)
            make.centerX.equalToSuperview()
                .offset(Dimension.shared.largeMargin_32)
            make.width.height.equalTo(Dimension.shared.largeHeightButton)
        }
    }
    
    private func layoutOptionSignInLabel() {
        view.addSubview(optionSignInLabel)
        optionSignInLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(facebookButton.snp.top)
                .offset(-Dimension.shared.normalMargin)
            make.width.equalTo(200)
            make.centerX.equalToSuperview()
        }
    }
}

extension SignInViewController: NIAttributedLabelDelegate {
    func attributedLabel(_ attributedLabel: NIAttributedLabel!, didSelect result: NSTextCheckingResult!, at point: CGPoint) {
        guard let url = result.url else { return }
        AppRouter.pushToWebView(config: url)
    }
}
