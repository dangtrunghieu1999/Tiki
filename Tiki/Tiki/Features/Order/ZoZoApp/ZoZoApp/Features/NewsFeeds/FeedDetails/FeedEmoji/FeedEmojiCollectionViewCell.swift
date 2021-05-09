//
//  FeedEmojiCollectionViewCell.swift
//  ZoZoApp
//
//  Created by LAP12852 on 10/6/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class FeedEmojiCollectionViewCell: BaseCollectionViewCell {
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode =  .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.image = ImageManager.emoji
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "hạnh phúc"
        label.textAlignment = .left
        label.textColor = UIColor.lightBodyText
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    override func initialize() {
        layer.borderColor = UIColor.lightSeparator.cgColor
        layer.borderWidth = 0.5
        layoutImageView()
        layoutTitleLabel()
    }
    
    private func layoutImageView() {
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(40)
            make.left.equalToSuperview().offset(Dimension.shared.normalMargin)
            make.centerY.equalToSuperview()
        }
    }
    
    private func layoutTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(imageView.snp.right).offset(Dimension.shared.mediumMargin)
            make.centerY.equalToSuperview()
        }
    }
    
}
