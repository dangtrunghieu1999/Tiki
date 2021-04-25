//
//  ProductChildCommentCollectionViewCell.swift
//  ZoZoApp
//
//  Created by LAP12852 on 9/15/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class ProductChildCommentCollectionViewCell: BaseCommentCollectionViewCell {
    
    override func initialize() {
        super.initialize()
        setupLayout(isParentComment: false)
    }
    
}

