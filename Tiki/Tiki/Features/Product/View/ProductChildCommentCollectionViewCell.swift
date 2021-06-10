//
//  ProductChildCommentCollectionViewCell.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 4/15/21.
//

import UIKit

class ProductChildCommentCollectionViewCell: BaseCommentCollectionViewCell {
    override func initialize() {
        super.initialize()
        setupLayout(isParentComment: false)
    }
}
