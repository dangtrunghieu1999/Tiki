//
//  SelectPermissionCollectionViewCell.swift
//  ZoZoApp
//
//  Created by LAP12852 on 8/4/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class SelectPermissionCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Variables
    
    // MARK: - UI Elements
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.checkMarkUnCheck
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.addNewProductTitle.localized()
        label.textColor = UIColor.lightBodyText
        label.font = UIFont.systemFont(ofSize: FontSize.body.rawValue)
        label.numberOfLines = 1
        return label
    }()
    
    // MARK: - LifeCycles
    
    override func initialize() {
        layoutImageView()
        layoutTitleLabel()
    }
    
    // MARK: - Public Methods
    
    func configureData(_ shopRole: ShopRole) {
        self.titleLabel.text = shopRole.shopRoleName
        if shopRole.hasRole {
            imageView.image = ImageManager.checkMarkCheck
        } else {
            imageView.image = ImageManager.checkMarkUnCheck
        }
    }
    
    // MARK: - UI Actions
    
    // MARK: - Helper Methods
    
    // MARK: - Layout
    
    private func layoutImageView() {
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(20)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(Dimension.shared.smallMargin)
        }
    }
    
    private func layoutTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(imageView.snp.right).offset(Dimension.shared.normalMargin)
            make.right.equalToSuperview().offset(-Dimension.shared.normalMargin)
        }
    }
    
}
