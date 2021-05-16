//
//  NotificationsTableViewCell.swift
//  ZoZoApp
//
//  Created by Dang Trung Hieu on 8/29/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class NotificationsTableViewCell: BaseTableViewCell {

    // MARK: - UI Elements
    
    fileprivate lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 40
        imageView.image = ImageManager.productImage
        return imageView
    }()
    
    fileprivate lazy var titleNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        label.textColor = UIColor.bodyText
        label.textAlignment = .left
        label.text = "Trung Hiếu trả lời một bình luận của bạn "
        label.numberOfLines = 0
        return label
    }()
    
    fileprivate lazy var timeDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        label.textColor = UIColor.lightBodyText
        label.textAlignment = .left
        label.text = "Yesterday at 7:58 PM"
        return label
    }()
    
    // MARK: - View LifeCycles
    
    override func initialize() {
        super.initialize()
        layoutAvatarImageView()
        layoutTitleNameLabel()
        layoutTimeDateLabel()
    }
    
    // MARK: - Setup layouts
    
    private func layoutAvatarImageView() {
        addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.height.width.equalTo(80)
            make.left.equalToSuperview().offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutTitleNameLabel() {
        addSubview(titleNameLabel)
        titleNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatarImageView.snp.right).offset(Dimension.shared.normalMargin)
            make.right.equalToSuperview().offset(-Dimension.shared.largeMargin)
            make.top.equalToSuperview().offset(Dimension.shared.largeMargin_32)
        }
    }
    
    private func layoutTimeDateLabel() {
        addSubview(timeDateLabel)
        timeDateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleNameLabel.snp.bottom).offset(Dimension.shared.smallMargin)
            make.left.equalTo(titleNameLabel)
        }
    }
}
