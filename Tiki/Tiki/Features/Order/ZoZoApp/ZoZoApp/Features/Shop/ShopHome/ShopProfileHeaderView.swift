//
//  ShopProfileHeaderView.swift
//  ZoZoApp
//
//  Created by LAP12852 on 7/6/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

protocol ShopProfileHeaderViewDelegate: class {
    func didSelectSetting()
    func didSelectSendMessage()
    func didSelectFollow()
}

class ShopProfileHeaderView: UserProfileHeaderView {
    
    // MARK: - Variables
    
    weak var shopHeaderDelegate: ShopProfileHeaderViewDelegate?
    private var shop = Shop()
    
    // MARK: - UI Elements
    
    private lazy var settingButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.settingShop, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(tapOnSettingButton), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    private lazy var sendMessageButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.commentFriendShare, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(tapOnMessageButton), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    private lazy var followButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.connectFriend, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(tapOnFollowButton), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    
    // MARK: - Init
    
    override func initialize() {
        super.initialize()
        layoutSettingButton()
        layoutSendMesageButton()
        layoutFollowButton()
    }
    
    // MARK: - Public Methods
    
    override func configShop(by shopInfo: Shop) {
        super.configShop(by: shopInfo)
        shop = shopInfo
        updateShopIfNeeded()
    }
    
    func updateShopIfNeeded() {
        if shop.isOwner || ShopRoleManager.shared.isShopAdmin {
            settingButton.isHidden = false
            sendMessageButton.isHidden = true
            followButton.isHidden = true
        } else {
            settingButton.isHidden = true
            sendMessageButton.isHidden = false
            followButton.isHidden = false
        }
    }
    
    // MARK: - UI Action
    
    @objc private func tapOnSettingButton() {
        shopHeaderDelegate?.didSelectSetting()
    }
    
    @objc private func tapOnMessageButton() {
        shopHeaderDelegate?.didSelectSendMessage()
    }
    
    @objc private func tapOnFollowButton() {
        shopHeaderDelegate?.didSelectFollow()
    }
    
    // MARK: - SetupLayouts
    
    private func layoutSettingButton() {
        addSubview(settingButton)
        settingButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(25)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalTo(avatarImageView).offset(4)
        }
    }
    
    private func layoutSendMesageButton() {
        addSubview(sendMessageButton)
        sendMessageButton.snp.makeConstraints { (make) in
            make.width.height.top.right.equalTo(settingButton)
        }
    }
    
    private func layoutFollowButton() {
        addSubview(followButton)
        followButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(24)
            make.centerY.equalTo(settingButton)
            make.right.equalTo(sendMessageButton.snp.left).offset(-22)
        }
    }
    
}
