//
//  FeedSectionSecparatorCollectionViewCell.swift
//  ZoZoApp
//
//  Created by LAP12852 on 9/2/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit
import IGListKit

class FeedSectionSecparatorCollectionViewCell: BaseCollectionViewCell {
    override func initialize() {
        super.initialize()
        backgroundColor = UIColor.separator
    }
}

// MARK: - ListBindable

extension FeedSectionSecparatorCollectionViewCell {
    override func bindViewModel(_ viewModel: Any) {
        
    }
}
