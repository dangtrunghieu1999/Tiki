//
//  FeedLikeShareCollectionViewCell.swift
//  ZoZoApp
//
//  Created by LAP12852 on 9/2/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit
import IGListKit

class FeedLikeShareCollectionViewCell: BaseCollectionViewCell {
    
    private let likeButton = ZButton(with: ImageManager.like, title: TextManager.like.localized())
    private let commentButton = ZButton(with: ImageManager.feedComment, title: TextManager.comment.localized())
    private let shareButton = ZButton(with: ImageManager.feedShare, title: TextManager.share.localized())
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let width = frame.width / 3
        
        likeButton.frame = CGRect(x: 0, y: 0, width: width, height: frame.height)
        addSubview(likeButton)
        
        commentButton.frame = CGRect(x: width, y: 0, width: width, height: frame.height)
        addSubview(commentButton)
        
        shareButton.frame = CGRect(x: 2 * width, y: 0, width: width, height: frame.height)
        addSubview(shareButton)
    }
    
}

// MARK: - ListBindable

extension FeedLikeShareCollectionViewCell {
    override func bindViewModel(_ viewModel: Any) {
        
    }
}
