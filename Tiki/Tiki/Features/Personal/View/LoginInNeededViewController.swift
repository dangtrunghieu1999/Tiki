//
//  LoginInNeededViewController.swift
//  Tiki
//
//  Created by Bee_MacPro on 01/06/2021.
//

import UIKit

class LoginInNeededViewController: BaseViewController {
    
    let topView: UIView = {
        let view = UIView()
        return view
    }()
    
    fileprivate lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.icon_logo2
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let centerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis         = .vertical
        stackView.alignment    = .fill
        stackView.distribution = .fill
        stackView.spacing = dimension.normalMargin
        return stackView
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        label.textColor = UIColor.bodyText
        label.text = TextManager.pleaseSignInNeed
        return label
    }()
    
    fileprivate lazy var signInButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.signInNow.localized(), for: .normal)
        button.backgroundColor = UIColor.disable
        button.layer.cornerRadius = Dimension.shared.cornerRadiusSmall
        button.layer.masksToBounds = true
        button.isUserInteractionEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutCenterStackView()
        layoutTitleLabel()
        layoutSignInButton()
        layoutTopView()
        layoutLogoImageView()
    }
    
    
    private func layoutCenterStackView() {
        view.addSubview(centerStackView)
        centerStackView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
                .offset(dimension.normalMargin)
            make.right.equalToSuperview()
                .inset(dimension.normalMargin)
            make.bottom.equalToSuperview()
                .offset(-dimension.largeMargin)
        }
    }
    
    private func layoutTitleLabel() {
        centerStackView.addArrangedSubview(titleLabel)
    }
    
    private func layoutSignInButton() {
        centerStackView.addArrangedSubview(signInButton)
        signInButton.snp.makeConstraints { (make) in
            make.height.equalTo(dimension.largeHeightButton)
        }
    }
    
    private func layoutTopView() {
        view.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(centerStackView.snp.top)
        }
    }
    
    private func layoutLogoImageView() {
        topView.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(view).multipliedBy(0.5)
            make.height.equalTo(logoImageView.snp.width)
        }
    }
    
}
