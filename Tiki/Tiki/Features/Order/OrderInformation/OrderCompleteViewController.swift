//
//  OrderCompleteViewController.swift
//  Tiki
//
//  Created by Bee_MacPro on 16/06/2021.
//

import UIKit

class OrderCompleteViewController: BaseViewController {
    
    fileprivate lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.background
        view.layer.masksToBounds = true
        return view
    }()
    
    fileprivate lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "complete")
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    fileprivate lazy var usernameTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Cám ơn Trung Hiếu"
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: FontSize.title.rawValue)
        return label
    }()
    
    fileprivate lazy var orderSuccessLabel: UILabel = {
        let label = UILabel()
        label.text = "Đặt hàng thành công"
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: FontSize.title.rawValue, weight: .bold)
        return label
    }()
    
    fileprivate lazy var successImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon_success")
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var backToHomeButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.backToHome, for: .normal)
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.primary, for: .normal)
        button.layer.masksToBounds = true
        button.isUserInteractionEnabled = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.primary.cgColor
        button.layer.cornerRadius = dimension.cornerRadiusSmall
        button.addTarget(self, action: #selector(tapBackToHome),
                         for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutBannerImageView()
        layoutLogoImageView()
        layoutUsernameTitleLabel()
        layoutOrderSuccessLabel()
        layoutBackToHome()
        layoutSuccessImageView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @objc private func tapBackToHome() {
        guard let window = UIApplication.shared.keyWindow else { return }
        window.rootViewController = TKTabBarViewController()
    }
    
    private func layoutBannerImageView() {
        view.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.height.equalTo(250)
            make.left.right.equalToSuperview()
        }
    }
    
    private func layoutLogoImageView() {
        topView.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { (make) in
            make.centerY
                .equalToSuperview()
                .offset(-dimension.normalMargin)
            make.width
                .height
                .equalTo(50)
            make.centerX
                .equalToSuperview()
        }
    }
    
    private func layoutUsernameTitleLabel() {
        topView.addSubview(usernameTitleLabel)
        usernameTitleLabel.snp.makeConstraints { (make) in
            make.centerX
                .equalTo(logoImageView)
            make.width
                .equalToSuperview()
                .offset(-dimension.normalMargin)
            make.top
                .equalTo(logoImageView.snp.bottom)
                .offset(dimension.largeMargin)
        }
    }
    
    private func layoutOrderSuccessLabel() {
        topView.addSubview(orderSuccessLabel)
        orderSuccessLabel.snp.makeConstraints { (make) in
            make.top
                .equalTo(usernameTitleLabel.snp.bottom)
                .offset(dimension.smallMargin)
            make.centerX
                .equalTo(usernameTitleLabel)
            make.width
                .equalToSuperview()
                .offset(-dimension.normalMargin)
        }
    }
    
    private func layoutBackToHome() {
        view.addSubview(backToHomeButton)
        backToHomeButton.snp.makeConstraints { (make) in
            make.left
                .right
                .equalToSuperview()
                .inset(dimension.normalMargin)
            make.height
                .equalTo(dimension.defaultHeightButton)
            if #available(iOS 11, *) {
                make.bottom
                    .equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom
                    .equalTo(bottomLayoutGuide.snp.top)
            }
        }
    }
    
    private func layoutSuccessImageView() {
        view.addSubview(successImageView)
        successImageView.snp.makeConstraints { (make) in
            make.top
                .equalTo(topView.snp.bottom)
                .offset(dimension.largeMargin)
            make.width
                .equalTo(200)
            make.centerX
                .equalToSuperview()
            make.bottom
                .equalTo(backToHomeButton.snp.top)
        }
    }
}
