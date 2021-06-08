//
//  ImageCollectionViewCell.swift
//  Ecom
//
//  Created by MACOS on 3/25/19.
//  Copyright © 2019 Minh Tri. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: BaseCollectionViewCell {
    
    var imageContentMode: ContentMode = .scaleAspectFit {
        didSet {
            imageView.contentMode = imageContentMode
        }
    }
    
    var cornerRadius: CGFloat = 0.0 {
        didSet {
            imageView.layer.cornerRadius = cornerRadius
        }
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override func initialize() {
        setupViewImageView()
    }
    
    func borderColorCell() {
        layer.borderColor = UIColor.separator.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = dimension.conerRadiusMedium
    }
    
    func configCell(_ image: String?) {
        if let url = image {
            imageView.loadImage(by: url)
        }
    }
    
    func setupData(_ photo: Photo) {
        if let image = photo.currentImage {
            imageView.image = image
        } else {
            imageView.loadImage(by: photo.url)
        }
    }
    
    private func setupViewImageView() {
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.left
                .right
                .equalToSuperview()
                .inset(dimension.mediumMargin)
            make.top
                .bottom
                .equalToSuperview()
        }
    }
    
}
