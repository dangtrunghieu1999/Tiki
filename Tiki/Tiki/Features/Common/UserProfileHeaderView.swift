//
//  UserProfileHeaderView.swift
//  ZoZoApp
//
//  Created by MACOS on 6/9/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class UserProfileHeaderView: BaseView {
    
    // MARK: - Variables
    
    static var avatarImageHeight: CGFloat = 80
    
    static var estimatedHeight: CGFloat {
        let coverHeight = ScreenSize.SCREEN_WIDTH * AppConfig.coverImageRatio
        return coverHeight
    }
    
    // MARK: - UI Elements
    
    lazy var coverImageView: ShimmerImageView = {
        let imageView = ShimmerImageView()
        imageView.image = ImageManager.defaultCoverImage
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    lazy var coverGradientImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.coverGradient
        imageView.contentMode = .bottom
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    lazy var avatarImageView: ShimmerImageView = {
        let imageView = ShimmerImageView()
        imageView.image = ImageManager.defaultAvatar
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = UserProfileHeaderView.avatarImageHeight / 2
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.lightSeparator.cgColor
        imageView.layer.borderWidth = 3
        return imageView
    }()
    
    let shopNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: FontSize.body.rawValue, weight: .semibold)
        return label
    }()
    
    let numberFollowLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        label.text = "543 người theo dõi"
        return label
    }()
    
    // MARK: - LifeCycles
    
    override func initialize() {
        layoutCoverImageView()
        layoutCoverGradientImageView()
        layoutAvatarImageView()
        layoutShopNameLabel()
        layoutNumberFollowLabel()
    }
    
    // MARK: - Public methods
    
    func configShop(by shopInfo: Shop) {
        if shopInfo.displayName != "" {
            shopNameLabel.text = shopInfo.displayName
        } else {
            shopNameLabel.text = shopInfo.name
        }
        
        avatarImageView.loadImage(by: shopInfo.avatar, defaultImage: ImageManager.defaultAvatar)
    }
    
    func setAvatarImage(by image: UIImage) {
        avatarImageView.image = image
    }
    
    func setCoverImage(by image: UIImage){
        coverImageView.image = image
    }
    
    func startShimmering() {
        avatarImageView.startShimmer()
        coverImageView.startShimmer()
    }
    
    func stopShimmering() {
        avatarImageView.stopShimmer()
        coverImageView.stopShimmer()
    }
    
    // MARK: - Layouts
    
    private func layoutCoverImageView() {
        addSubview(coverImageView)
        coverImageView.snp.makeConstraints { (make) in
            make.width.centerX.top.equalToSuperview()
            make.height.equalTo(ScreenSize.SCREEN_WIDTH * AppConfig.coverImageRatio)
        }
    }
    
    private func layoutCoverGradientImageView() {
        addSubview(coverGradientImageView)
        coverGradientImageView.snp.makeConstraints { (make) in
            make.width.height.centerX.centerY.equalTo(coverImageView)
        }
    }
    
    private func layoutAvatarImageView() {
        addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(UserProfileHeaderView.avatarImageHeight)
            make.left.equalToSuperview().offset(Dimension.shared.largeMargin)
            make.centerY.equalToSuperview()
        }
    }
    
    private func layoutShopNameLabel() {
        addSubview(shopNameLabel)
        shopNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatarImageView.snp.right).offset(Dimension.shared.normalMargin)
            make.right.equalToSuperview().offset(-Dimension.shared.mediumMargin)
            make.top.equalTo(avatarImageView).offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutNumberFollowLabel() {
        addSubview(numberFollowLabel)
        numberFollowLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(shopNameLabel)
            make.top.equalTo(shopNameLabel.snp.bottom).offset(Dimension.shared.smallMargin)
        }
    }
    
}
