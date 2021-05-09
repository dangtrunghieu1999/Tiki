//
//  RecommendShopViewCollectionViewCell.swift
//  ZoZoApp
//
//  Created by LAP12852 on 9/1/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class RecommendShopViewCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Variables
    
    private var shop = Shop()
    
    // MARK: - UI Elements
    
    fileprivate lazy var containerView: UIView = {
        let view = UIView()
        view.addShadow()
        view.layer.cornerRadius = 15
        view.backgroundColor = UIColor.white
        return view
    }()
    
    fileprivate lazy var shopAvatarImageView: ShimmerImageView = {
        let imageView = ShimmerImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        return imageView
    }()
    
    fileprivate lazy var shopNameLabel: ShimmerLabel = {
        let label = ShimmerLabel()
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .medium)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    override func initialize() {
        super.initialize()
        layoutContainerView()
        layoutShopAvatarImageView()
        layoutShopNameLabel()
        shopAvatarImageView.startShimmer()
        shopNameLabel.startShimmer()
    }
    // MARK: - Help Method
    
    func stopShimmer() {
        shopAvatarImageView.stopShimmer()
        shopNameLabel.stopShimmer()
    }
    
    func configCell(by shop: Shop) {
        shopAvatarImageView.loadImage(by: shop.avatar, defaultImage: ImageManager.defaultAvatar)
        shopNameLabel.text = shop.name
    }
    
    // MARK: - Setup Layouts
    
    private func layoutContainerView() {
        addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(Dimension.shared.mediumMargin)
            make.right.bottom.equalToSuperview().offset(-Dimension.shared.mediumMargin)
        }
    }
    private func layoutShopAvatarImageView() {
        containerView.addSubview(shopAvatarImageView)
        shopAvatarImageView.snp.makeConstraints { (make) in
            make.height.width.equalTo(70)
            make.left.equalToSuperview().offset(Dimension.shared.normalMargin)
            make.centerY.equalToSuperview()
        }
    }
    
    private func layoutShopNameLabel() {
        containerView.addSubview(shopNameLabel)
        shopNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(shopAvatarImageView).offset(8)
            make.left.equalTo(shopAvatarImageView.snp.right).offset(Dimension.shared.mediumMargin)
            make.right.equalToSuperview().offset(-Dimension.shared.mediumMargin)
        }
    }
}

