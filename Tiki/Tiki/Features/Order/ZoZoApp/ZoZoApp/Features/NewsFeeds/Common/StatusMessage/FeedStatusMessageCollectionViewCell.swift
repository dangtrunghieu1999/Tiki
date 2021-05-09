//
//  FeedStatusMessageCollectionViewCell.swift
//  ZoZoApp
//
//  Created by LAP12852 on 9/2/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit
import IGListKit

class FeedStatusMessageCollectionViewCell: BaseCollectionViewCell {
    
    private var statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        label.numberOfLines = 0
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        statusLabel.frame = CGRect(x: 16, y: 4, width: frame.width - 32, height: frame.height - 12)
        addSubview(statusLabel)
    }
    
}

// MARK: - ListBindable

extension FeedStatusMessageCollectionViewCell {
    override func bindViewModel(_ viewModel: Any) {
        guard let statusMessageModel = viewModel as? FeedStatusMessageModel else {
            return
        }
        statusLabel.text = statusMessageModel.status
    }
}
