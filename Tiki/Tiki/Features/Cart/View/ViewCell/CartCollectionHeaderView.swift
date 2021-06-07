//
//  HeaderCartCollectionReusableView.swift
//  ZoZoApp
//
//  Created by Dang Trung Hieu on 8/17/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class CartCollectionHeaderView: BaseCollectionViewHeaderFooterCell {
    
    private var shopId: Int?
    
    // MARK: - UI Elements
    
    fileprivate lazy var thumbnailShopImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor.lightSeparator.withAlphaComponent(0.5).cgColor
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(tapOnShopAvatar))
        imageView.addGestureRecognizer(tapGesture)
        return imageView
    }()
    
    fileprivate lazy var shopNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        label.textColor = UIColor.bodyText
        return label
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.separator
        return view
    }()
    
    // MARK: - View LifeCycles
    
    override func initialize() {
        super.initialize()
        backgroundColor = UIColor.white
        layoutThumbnailShopImageView()
        layoutShopNameLabel()
        layoutLineView()
    }
    
    // MARK: - Public methods
    
    func configData(_ cartShopInfo: CartShopInfo) {
        shopId = cartShopInfo.id
        thumbnailShopImageView.loadImage(by: cartShopInfo.avatar)
        shopNameLabel.text = cartShopInfo.name
    }
    
    // MARK: - UI Actions
    
    @objc private func tapOnShopAvatar() {
        guard let shopId = shopId else { return }
        AppRouter.pushToShopHome(shopId)
    }
    
    // MARK: - Setup Layouts
    
    private func layoutThumbnailShopImageView() {
        addSubview(thumbnailShopImageView)
        thumbnailShopImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.height.width.equalTo(30)
            make.left.equalToSuperview()
                .offset(dimension.normalMargin)
        }
    }
    
    private func layoutShopNameLabel() {
        addSubview(shopNameLabel)
        shopNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(thumbnailShopImageView)
            make.left.equalTo(thumbnailShopImageView.snp.right)
                .offset(dimension.smallMargin)
            make.right.equalToSuperview()
                .inset(dimension.normalMargin)
            make.centerY.equalTo(thumbnailShopImageView)
        }
    }
    
    private func layoutLineView() {
        addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
            make.width.equalToSuperview()
        }
    }
}
