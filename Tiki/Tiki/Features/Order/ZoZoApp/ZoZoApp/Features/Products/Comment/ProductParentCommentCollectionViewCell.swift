//
//  ProductParentCommentCollectionViewCell.swift
//  ZoZoApp
//
//  Created by MACOS on 7/20/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class ProductParentCommentCollectionViewCell: BaseCommentCollectionViewCell {
    
    override func initialize() {
        super.initialize()
        setupLayout(isParentComment: true)
    }
    
}
