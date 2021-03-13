//
//  SearchResultUserTableViewCell.swift
//  ZoZoApp
//
//  Created by LAP12852 on 8/4/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class SearchResultUserTableViewCell: BaseTableViewCell {
    
    // MARK: - Variables
    
    var isShowCheckBox = false {
        didSet {
            var width: CGFloat = 0
            if isShowCheckBox {
                width = 25
            }
            checkBoxImageView.snp.updateConstraints { (make) in
                make.width.equalTo(width)
            }
        }
    }
    
    var isCheck: Bool = false {
        didSet {
            if isCheck {
                checkBoxImageView.image = ImageManager.checkMarkCheck
            } else {
                checkBoxImageView.image = ImageManager.checkMarkUnCheck
            }
        }
    }
    
    private let avatarHeight: CGFloat = 60
    private var user = User()
    
    // MARK: - UI Elements
    
    private lazy var checkBoxImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.image = ImageManager.checkMarkUnCheck
        return imageView
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.userAvatar
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor.separator.cgColor
        imageView.layer.cornerRadius = avatarHeight / 2
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnUserAvatar))
        imageView.addGestureRecognizer(tapGesture)
        return imageView
    }()
    
    private let displayNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.titleText
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .medium)
        label.numberOfLines = 1
        return label
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        label.numberOfLines = 2
        return label
    }()
    
    fileprivate let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightSeparator
        return view
    }()
    
    // MARK: - LifeCycles
    
    override func initialize() {
        layoutCheckBoxImageView()
        layoutAvatarImageView()
        layoutDisplayNameLabel()
        layoutUserNameLabel()
    }
    
    // MARK: - Public Methods
    
    func configureData(user: User) {
        self.user = user
        self.avatarImageView.loadImage(by: user.pictureURL, defaultImage: ImageManager.userAvatar)
        self.displayNameLabel.text = user.fullName
        self.userNameLabel.text = user.email
    }
    
    // MARK: - UI Actions
    
    @objc private func tapOnUserAvatar() {
        AppRouter.pushToUserProfile(user.id)
    }
    
    // MARK: - Helper Methods
    
    // MARK: - Layout
    
    private func layoutCheckBoxImageView() {
        addSubview(checkBoxImageView)
        checkBoxImageView.snp.makeConstraints { (make) in
            make.width.equalTo(0)
            make.height.equalTo(25)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(dimension.normalMargin)
        }
    }
    
    private func layoutAvatarImageView() {
        addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(avatarHeight)
            make.centerY.equalToSuperview()
            make.left.equalTo(checkBoxImageView.snp.right).offset(Dimension.shared.mediumMargin)
        }
    }
    
    private func layoutDisplayNameLabel() {
        addSubview(displayNameLabel)
        displayNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatarImageView.snp.right).offset(Dimension.shared.normalMargin)
            make.right.equalToSuperview().offset(Dimension.shared.smallMargin)
            make.top.equalTo(avatarImageView)
        }
    }
    
    private func layoutUserNameLabel() {
        addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(displayNameLabel)
            make.top.equalTo(displayNameLabel.snp.bottom).offset(Dimension.shared.mediumMargin)
        }
    }
    
}
