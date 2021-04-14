//
//  FeedSectionSecparatorCollectionViewCell.swift
//  ZoZoApp
//
//  Created by LAP12852 on 9/2/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit
import IGListKit

class SecparatorCollectionViewCell: BaseCollectionViewCell {
    override func initialize() {
        super.initialize()
        backgroundColor = UIColor.separator
    }
}

// MARK: - ListBindable

extension SecparatorCollectionViewCell {
    override func bindViewModel(_ viewModel: Any) {
        
    }
}
