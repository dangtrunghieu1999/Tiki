//
//  FeedHeaderInfoCollectionViewCell.swift
//  ZoZoApp
//
//  Created by LAP12852 on 9/2/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit
import IGListKit

class FeedHeaderInfoCollectionViewCell: BaseCollectionViewCell {
    
    // Support caculate height
    
    let avatarLeftMargin:       CGFloat     = 16
    let avatarTopMargin:        CGFloat     = 10
    let avatarWidth:            CGFloat     = 40
    let displayNameLeftMargin:  CGFloat     = 10
    let displayNameRightMargin: CGFloat     = 8
    
    lazy var headerTitleX         = avatarLeftMargin + avatarWidth + displayNameLeftMargin
    lazy var headerTitleWidth     = ScreenSize.SCREEN_WIDTH - headerTitleX - displayNameRightMargin
    
    private var headerInfoModel: FeedHeaderInfoModel?
    var headerTitleFont           = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode         = .scaleAspectFill
        imageView.layer.cornerRadius  = avatarWidth / 2
        imageView.layer.borderWidth   = 2
        imageView.layer.borderColor   = UIColor.background.cgColor
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var headerTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        return label
    }()
    
    private var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightBodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        label.text = "1 giờ trước"
        label.numberOfLines = 3
        return label
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Avatar ImageView
        avatarImageView.frame = CGRect(x: avatarLeftMargin,
                                       y: avatarTopMargin,
                                       width: avatarWidth,
                                       height: avatarWidth)
        addSubview(avatarImageView)
        
        // Header title Label
        var headerInfoLabelHeight: CGFloat = 16
        if let height = headerInfoModel?.headerTitleHeight {
            headerInfoLabelHeight = height
        }
        
        headerTitleLabel.frame = CGRect(x: headerTitleX,
                                        y: avatarTopMargin,
                                        width: headerTitleWidth,
                                        height: headerInfoLabelHeight)
        
        addSubview(headerTitleLabel)
        
        // Time Label
        timeLabel.frame = CGRect(x: headerTitleX,
                                 y: avatarTopMargin + headerInfoLabelHeight + 5,
                                 width: headerTitleWidth,
                                 height: 10)
        addSubview(timeLabel)
    }
    
}

// MARK: - ListBindable

extension FeedHeaderInfoCollectionViewCell {
    override func bindViewModel(_ viewModel: Any) {
        guard let headerInfoModel = viewModel as? FeedHeaderInfoModel else {
            return
        }
        self.headerInfoModel = headerInfoModel
        avatarImageView.loadImage(by: headerInfoModel.avatar)
        headerTitleLabel.attributedText = headerInfoModel.headerAttrString
    }
}
