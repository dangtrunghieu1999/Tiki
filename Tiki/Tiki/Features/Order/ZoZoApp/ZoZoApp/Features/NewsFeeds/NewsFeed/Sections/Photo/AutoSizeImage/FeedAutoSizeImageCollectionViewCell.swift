//
//  FeedAutoSizeImageCollectionViewCell.swift
//  ZoZoApp
//
//  Created by LAP12852 on 9/2/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit
import IGListKit

class FeedAutoSizeImageCollectionViewCell: BaseCollectionViewCell {
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode         = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth   = 1.5
        imageView.layer.borderColor   = UIColor.white.cgColor
        return imageView
    }()
    
    fileprivate let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.layer.borderWidth   = 1.5
        view.layer.borderColor   = UIColor.white.cgColor
        return view
    }()
    
    private let numberSeeMoreImageLabel: UILabel = {
        let label = UILabel()
        label.text = "+3"
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: FontSize.superHeadline.rawValue, weight: .bold)
        label.isHidden = true
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(imageView)
        imageView.frame = bounds
        addSubview(overlayView)
        overlayView.frame = bounds
        addSubview(numberSeeMoreImageLabel)
        numberSeeMoreImageLabel.frame = bounds
    }
    
}

// MARK: - ListBindable

extension FeedAutoSizeImageCollectionViewCell {
    override func bindViewModel(_ viewModel: Any) {
        guard let imageCellModel = viewModel as? FeedAutoSizeImageCellModel else {
            return
        }
        if imageCellModel.imageURL != "" {
            imageView.loadImage(by: imageCellModel.imageURL)
        } else {
            imageView.image = imageCellModel.image
        }
        
        overlayView.isHidden = (imageCellModel.numberSeeMoreImages == 0)
        numberSeeMoreImageLabel.isHidden = (imageCellModel.numberSeeMoreImages == 0)
        numberSeeMoreImageLabel.text = "+\(imageCellModel.numberSeeMoreImages)"
    }
}
