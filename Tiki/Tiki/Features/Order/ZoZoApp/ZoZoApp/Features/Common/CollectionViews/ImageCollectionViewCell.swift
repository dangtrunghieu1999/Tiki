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
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override func initialize() {
        setupViewImageView()
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
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
}
