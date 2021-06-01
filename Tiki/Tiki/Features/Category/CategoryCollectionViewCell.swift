//
//  CategoryCollectionViewCell.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 5/16/21.
//

import UIKit

class CategoryCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - UI Elements
    
    fileprivate lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.image = ImageManager.productImage
        return imageView
    }()
    

    override func initialize() {
        super.initialize()
        layoutProductImage()
    }
    
    func configCell(_ image: UIImage?) {
        self.productImageView.image = image
    }
    
    private func layoutProductImage() {
        addSubview(productImageView)
        productImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(100)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
}
