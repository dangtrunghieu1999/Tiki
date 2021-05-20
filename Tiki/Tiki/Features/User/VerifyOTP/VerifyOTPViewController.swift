//
//  VerifyOTPViewController.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 3/27/21.
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
        label.text = TextManager.sendCodeRecoverPWInSMS.localized()
        label.textColor = UIColor.lightBodyText
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: FontSize.body.rawValue)
        return label
    }()
    
    fileprivate lazy var enterCodeTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.placeholder = TextManager.yourCode.localized()
        textField.textAlignment = .center
        textField.layer.borderColor = UIColor.separator.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = Dimension.shared.conerRadiusMedium
        textField.layer.masksToBounds = true
        textField.keyboardType = .numberPad
        textField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)
        return textField
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
            nextButton.backgroundColor = UIColor.primary
            nextButton.isUserInteractionEnabled = true
        } else {
            nextButton.backgroundColor = UIColor.disable
            nextButton.isUserInteractionEnabled = false
        }
    }
    
    @objc private func tapOnNextButton() {
        guard let code = enterCodeTextField.text else { return }
        let endPoint = UserEndPoint.checkValidCode(bodyParams: ["phone": userName,
                                                                "otp": code])
        
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
            make.left.equalTo(view).offset(Dimension.shared.normalMargin)
            make.right.equalTo(view).offset(-Dimension.shared.normalMargin)
            make.height.equalTo(Dimension.shared.defaultHeightTextField)
            make.top.equalTo(titleLabel.snp.bottom).offset(Dimension.shared.largeMargin)
        }
    }
    
    private func layoutNextButton() {
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { (make) in
            make.height.equalTo(Dimension.shared.largeHeightButton)
            make.left.equalToSuperview()
                .offset(Dimension.shared.normalMargin)
            make.top.equalTo(enterCodeTextField.snp.bottom)
                .offset(Dimension.shared.largeMargin_32)
            make.right.equalToSuperview()
                .offset(-Dimension.shared.normalMargin)
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

extension VerifyOTPViewController: NIAttributedLabelDelegate {
    func attributedLabel(_ attributedLabel: NIAttributedLabel!,
                         didSelect result: NSTextCheckingResult!,
                         at point: CGPoint) {
        
    }
}
