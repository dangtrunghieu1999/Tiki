//
//  StallShopCollectionViewCell.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 4/15/21.
//

import UIKit

class ProductStallShopCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Variables
    private var shopId: Int?
    
    let widthButton = (ScreenSize.SCREEN_WIDTH - Dimension.shared.normalMargin * 3) / 2
    
    // MARK: - UI Elements
    
    fileprivate lazy var avatarShopImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = Dimension.shared.largeHeightButton / 2
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
        imageView.layer.borderWidth = 1.0
        return imageView
    }()
    
    fileprivate lazy var nameShopLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.body.rawValue, weight: .semibold)
        label.numberOfLines = 2
        return label
    }()
    
    fileprivate lazy var seeShopButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor.thirdColor.cgColor
        button.layer.borderWidth = 1.0
        button.setTitle(TextManager.seeShop, for: .normal)
        button.setImage(ImageManager.shop_home, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.titleLabel?.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        button.setTitleColor(UIColor.thirdColor, for: .normal)
        button.layer.cornerRadius = Dimension.shared.cornerRadiusSmall
        button.addTarget(self, action: #selector(tapOnViewDetailButton), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var followShopButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor.thirdColor.cgColor
        button.layer.borderWidth = 1.0
        button.setTitle(TextManager.followShop, for: .normal)
        button.setImage(ImageManager.addCircle, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.titleLabel?.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        button.setTitleColor(UIColor.thirdColor, for: .normal)
        button.layer.cornerRadius = Dimension.shared.cornerRadiusSmall
        return button
    }()

    
    // MARK: - View LifeCycles
    
    override func initialize() {
        super.initialize()
        layoutAvatarShopImageView()
        layoutNameShopLabel()
        layoutSeeShopButton()
        layoutFollowShopButton()
    }
    
    // MARK: - Helper Method
    
    func configDataShop(_ product: Product) {
        self.avatarShopImageView.sd_setImage(with: product.shopAvatar.url, completed: nil)
        self.nameShopLabel.text = product.shopName
        self.shopId = product.shopId
    }
    
    @objc private func tapOnViewDetailButton() {
        guard let shopId = shopId else {return}
        AppRouter.pushToShopHome(shopId)
    }
    
    // MARK: - GET API
    
    // MARK: - Layout
    
    private func layoutAvatarShopImageView() {
        addSubview(avatarShopImageView)
        avatarShopImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Dimension.shared.normalMargin)
            make.left.equalToSuperview().offset(Dimension.shared.normalMargin)
            make.width.height.equalTo(Dimension.shared.largeHeightButton)
        }
    }
    
    private func layoutNameShopLabel() {
        addSubview(nameShopLabel)
        nameShopLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatarShopImageView.snp.right).offset(Dimension.shared.mediumMargin)
            make.top.equalTo(avatarShopImageView).offset(Dimension.shared.mediumMargin)
            make.right.equalToSuperview()
        }
    }
    
    private func layoutSeeShopButton() {
        addSubview(seeShopButton)
        seeShopButton.snp.makeConstraints { (make) in
            make.width.equalTo(widthButton)
            make.height.equalTo(Dimension.shared.defaultHeightButton)
            make.left.equalToSuperview().offset(Dimension.shared.normalMargin)
            make.top.equalTo(avatarShopImageView.snp.bottom).offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutFollowShopButton() {
        addSubview(followShopButton)
        followShopButton.snp.makeConstraints { (make) in
            make.width.height.top.equalTo(seeShopButton)
            make.right.equalToSuperview().offset(-Dimension.shared.normalMargin)
        }
    }
}
