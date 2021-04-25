//
//  ShopProfileHeaderView.swift
//  ZoZoApp
//
//  Created by LAP12852 on 7/6/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit


class ShopProfileHeaderView: UserProfileHeaderView {
    
    // MARK: - Variables
    
    // MARK: - UI Elements
    
    fileprivate lazy var chatButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 1
        button.setTitle(TextManager.chat, for: .normal)
        button.titleLabel?.textColor = UIColor.white
        button.titleLabel?.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        button.backgroundColor = UIColor.clear
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = Dimension.shared.smalltHeightButton_28 / 2
        return button
    }()
    
    fileprivate lazy var followButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 1
        button.setTitle(TextManager.follow, for: .normal)
        button.titleLabel?.textColor = UIColor.white
        button.titleLabel?.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        button.backgroundColor = UIColor.tabbarIcon
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = Dimension.shared.smalltHeightButton_28 / 2
        return button
    }()
    
    
    // MARK: - Init
    
    override func initialize() {
        super.initialize()
        layoutChatButton()
        layoutFollowButton()
    }
    
    // MARK: - Public Methods
    

    // MARK: - Layout
    
    private func layoutChatButton() {
        addSubview(chatButton)
        chatButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-Dimension.shared.normalMargin)
            make.width.equalTo(Dimension.shared.supperSmallWidthButton)
            make.height.equalTo(Dimension.shared.smalltHeightButton_28)
            make.centerY.equalToSuperview().offset(-Dimension.shared.normalMargin)
        }
    }
    
    private func layoutFollowButton() {
        addSubview(followButton)
        followButton.snp.makeConstraints { (make) in
            make.right.equalTo(chatButton)
            make.width.height.equalTo(chatButton)
            make.top.equalTo(chatButton.snp.bottom).offset(Dimension.shared.smallMargin)
        }
    }
    
}
