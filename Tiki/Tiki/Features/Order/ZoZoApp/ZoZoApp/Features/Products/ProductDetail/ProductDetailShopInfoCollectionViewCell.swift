//
//  ProductDetailShopInfoCollectionViewCell.swift
//  ZoZoApp
//
//  Created by MACOS on 7/21/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class ProductDetailShopInfoCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Variables
    
    private var shopId: Int?
    
    // MARK: - UI Elements
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.defaultAvatar
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 35
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
        imageView.layer.borderWidth = 1.0
        return imageView
    }()
    
    private let shopNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.body.rawValue)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var sendMessageButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.sendMessage.localized(), for: .normal)
        button.setTitleColor(UIColor.background, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.background.cgColor
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(tapOnSendMessageButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var viewDetailButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.viewDetail.localized(), for: .normal)
        button.setTitleColor(UIColor.accentColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.accentColor.cgColor
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(tapOnViewDetailButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - LifeCycles
    
    override func initialize() {
        layoutAvatarImageView()
        layoutShopNameLabel()
        layoutSendMessageButton()
        layoutViewDetailButton()
    }
    
    // MARK: - Public methods
    
    func configData(_ product: Product) {
        avatarImageView.loadImage(by: product.shopAvatar,
                                  defaultImage: ImageManager.defaultAvatar)
        shopNameLabel.text = product.shopName
        shopId = product.shopId
    }
    
    // MARK: - UI Actions
    
    @objc private func tapOnViewDetailButton() {
        guard let shopId = shopId else { return }
        AppRouter.pushToShopHome(shopId)
    }
    
    @objc private func tapOnSendMessageButton() {
        AppRouter.pushToChatDetail(partnerId: "")
    }
    
    // MARK: - Layouts
    
    private func layoutAvatarImageView() {
        addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(70)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutShopNameLabel() {
        addSubview(shopNameLabel)
        shopNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatarImageView.snp.right).offset(Dimension.shared.normalMargin)
            make.right.equalToSuperview().offset(-Dimension.shared.normalMargin)
            make.top.equalTo(avatarImageView)
        }
    }
    
    private func layoutSendMessageButton() {
        addSubview(sendMessageButton)
        sendMessageButton.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(30)
            make.bottom.equalTo(avatarImageView)
            make.left.equalTo(shopNameLabel)
        }
    }
    
    private func layoutViewDetailButton() {
        addSubview(viewDetailButton)
        viewDetailButton.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(30)
            make.bottom.equalTo(avatarImageView)
            make.left.equalTo(sendMessageButton.snp.right).offset(8)
        }
    }
    
}
