//
//  StickerCollectionViewCell.swift
//  ZoZoApp
//
//  Created by LAP12852 on 10/1/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class StickerCollectionViewCell: BaseCollectionViewCell {
    
    private lazy var imageView: FLAnimatedImageView = {
        let imageView = FLAnimatedImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    override func initialize() {
        configureAnimateImage()
        layoutImageView()
    }
    
    func updateState(isSelected: Bool) {
        if isSelected {
            contentView.backgroundColor = UIColor.lightBackground
        } else {
            contentView.backgroundColor = UIColor.white
        }
    }
    
    private func configureAnimateImage() {
        let imageData = try! Data.init(contentsOf: Bundle.main.url(forResource: "tenor", withExtension: "gif")!)
        let image = FLAnimatedImage(animatedGIFData: imageData)
        imageView.animatedImage = image
        imageView.shouldAnimate = false
        stopAnimate()
    }
    
    func stopAnimate() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.00000000000001) {
            self.imageView.stopAnimating()
        }
    }
    
    private func layoutImageView() {
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
}
