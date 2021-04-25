//
//  ListShopCollectionViewCell.swift
//  ZoZoApp
//
//  Created by MACOS on 6/9/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit
import SDWebImage

class ListShopCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Variables

    private var shop = Shop()
    
    // MARK: - UI Elements
    
    private let imageView: ShimmerImageView = {
        let imageView = ShimmerImageView()
        imageView.imageContentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 41
        imageView.layer.masksToBounds = true
        imageView.image = ImageManager.defaultAvatar
        imageView.layer.borderColor = UIColor.separator.withAlphaComponent(0.5).cgColor
        imageView.layer.borderWidth = 1.5
        return imageView
    }()
    
    private let shopNameLabel: ShimmerLabel = {
        let label = ShimmerLabel()
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .medium)
        label.numberOfLines = 1
        return label
    }()
    
    private let numberFollowLabel: ShimmerLabel = {
        let label = ShimmerLabel()
        label.textColor = UIColor.lightBodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        label.numberOfLines = 1
        return label
    }()
    
    private let newOrderLabel: ShimmerLabel = {
        let label = ShimmerLabel()
        label.textColor = UIColor.lightBodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        label.numberOfLines = 1
        return label
    }()
    
    private let newMessageLabel: ShimmerLabel = {
        let label = ShimmerLabel()
        label.textColor = UIColor.lightBodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        label.numberOfLines = 1
        return label
    }()
    
    // MARK: - LifeCycles
    
    override func initialize() {
        layer.cornerRadius = 5
        layer.masksToBounds = true
        
        layoutImageView()
        layoutShopNameLabel()
        layoutNumberFollowsLabel()
        layoutNewOrdersLabel()
        layoutNewMessageLabel()
        
        imageView.startShimmer()
        shopNameLabel.startShimmer()
        numberFollowLabel.startShimmer()
        newOrderLabel.startShimmer()
        newMessageLabel.startShimmer()
    }
  
    // MARK: - Public methods
    
    func configCell(by shop: Shop) {
        self.shop = shop
        imageView.loadImage(by: shop.avatar, defaultImage: ImageManager.defaultAvatar)
        
        shopNameLabel.text = shop.name
        numberFollowLabel.text = "\(shop.totalFollows) \(TextManager.numberFollows.localized())"
        newOrderLabel.text = "\(shop.countOrdered) \(TextManager.newOrders.localized())"
        newMessageLabel.text = "\(0) \(TextManager.newMessage.localized())"
    }
    
    func stopShimmer() {
        imageView.stopShimmer()
        shopNameLabel.stopShimmer()
        numberFollowLabel.stopShimmer()
        newOrderLabel.stopShimmer()
        newMessageLabel.stopShimmer()
    }
    
    // MARK: - Layouts
    
    private func layoutImageView() {
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(82)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutShopNameLabel() {
        addSubview(shopNameLabel)
        shopNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(imageView.snp.right).offset(Dimension.shared.mediumMargin)
            make.right.equalToSuperview().offset(-Dimension.shared.mediumMargin)
            make.top.equalTo(imageView)
        }
    }
    
    private func layoutNumberFollowsLabel() {
        addSubview(numberFollowLabel)
        numberFollowLabel.snp.makeConstraints { (make) in
            make.left.equalTo(shopNameLabel)
            make.top.equalTo(shopNameLabel.snp.bottom).offset(Dimension.shared.mediumMargin)
        }
    }
    
    private func layoutNewOrdersLabel() {
        addSubview(newOrderLabel)
        newOrderLabel.snp.makeConstraints { (make) in
            make.left.equalTo(shopNameLabel)
            make.top.equalTo(numberFollowLabel.snp.bottom).offset(Dimension.shared.smallMargin)
        }
    }
    
    private func layoutNewMessageLabel() {
        addSubview(newMessageLabel)
        newMessageLabel.snp.makeConstraints { (make) in
            make.left.equalTo(shopNameLabel)
            make.top.equalTo(newOrderLabel.snp.bottom).offset(Dimension.shared.smallMargin)
        }
    }
    
}
