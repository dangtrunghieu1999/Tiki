//
//  ResultUserCollectionViewCell.swift
//  ZoZoApp
//
//  Created by Dang Trung Hieu on 8/30/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class ResultUserCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - UI Elements
    
    fileprivate lazy var avatarUserImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "avatarUser")
        return imageView
    }()
    
    fileprivate lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .medium)
        label.textAlignment = .left
        label.text = "Name of user"
        label.numberOfLines = 0
        return label
    }()
    
    fileprivate lazy var liveCityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        label.textColor = UIColor.lightBodyText
        label.text = "TP HoChiMinh"
        label.textAlignment = .left
        return label
    }()
    
    fileprivate lazy var addFriendButton: UIButton = {
        let button = UIButton()
        button.layer.borderColor = UIColor.background.cgColor
        button.layer.borderWidth = 1
        button.setTitle(TextManager.makeFriend.localized(), for: .normal)
        button.setTitleColor(UIColor.background, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 15
        button.titleLabel?.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        return button
    }()
    
    fileprivate lazy var chatButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.accentColor
        button.setTitle(TextManager.chat.localized(), for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 15
        button.titleLabel?.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        return button
    }()
    
    
    // MARK: - View LifeCycles
    
    override func initialize() {
        super.initialize()
        layoutAvatarUserImageView()
        layoutUserNameLabel()
        layoutLiveCityLabel()
        layoutAddFriendButton()
        layoutChatButton()
    }
    
    // MARK: - Public methods
    
    
    // MARK: - Setup layouts
    
    private func layoutAvatarUserImageView() {
        addSubview(avatarUserImageView)
        avatarUserImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(Dimension.shared.normalMargin)
            make.width.height.equalTo(70)
        }
    }
    
    private func layoutUserNameLabel() {
        addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Dimension.shared.mediumMargin)
            make.left.equalTo(avatarUserImageView.snp.right).offset(Dimension.shared.normalMargin)
            make.right.equalToSuperview().offset(-Dimension.shared.largeMargin)
        }
    }
    
    private func layoutLiveCityLabel() {
        addSubview(liveCityLabel)
        liveCityLabel.snp.makeConstraints { (make) in
            make.top.equalTo(userNameLabel.snp.bottom).offset(Dimension.shared.mediumMargin)
            make.left.equalTo(userNameLabel)
        }
    }
    
    private func layoutAddFriendButton() {
        addSubview(addFriendButton)
        addFriendButton.snp.makeConstraints { (make) in
            make.top.equalTo(liveCityLabel.snp.bottom).offset(Dimension.shared.mediumMargin)
            make.left.equalTo(liveCityLabel)
            make.height.equalTo(30)
            make.width.equalTo(100)
        }
    }
    
    private func layoutChatButton() {
        addSubview(chatButton)
        chatButton.snp.makeConstraints { (make) in
            make.height.equalTo(30)
            make.width.equalTo(100)
            make.left.equalTo(addFriendButton.snp.right).offset(Dimension.shared.normalMargin)
            make.centerY.equalTo(addFriendButton)
        }
    }
    
}
