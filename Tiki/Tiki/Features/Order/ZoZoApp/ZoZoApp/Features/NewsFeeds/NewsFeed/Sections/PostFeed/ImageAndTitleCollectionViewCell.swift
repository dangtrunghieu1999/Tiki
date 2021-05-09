//
//  ImageAndTitleCollectionViewCell.swift
//  ZoZoApp
//
//  Created by LAP12852 on 9/21/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class ImageAndTitleCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Variables
    
    private let imageWidth:         CGFloat     = 20
    private let titleLeftMargin:    CGFloat     = 6
    
    // MARK: - UI Elements
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.image = ImageManager.postPhoto
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.image.localized()
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        return label
    }()
    
    fileprivate let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.separator
        return view
    }()
    
    // MARK: - LifeCycles
    
    override func initialize() {
        addSubview(separatorView)
        separatorView.snp.makeConstraints { (make) in
            make.width.equalTo(0.5)
            make.right.equalToSuperview()
            make.top.equalToSuperview().offset(4)
            make.bottom.equalToSuperview().offset(-4)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(imageView)
        addSubview(titleLabel)
        
        let titleWidth = titleLabel.text?.width(withConstrainedHeight: 30, font: UIFont.systemFont(ofSize: FontSize.body.rawValue)) ?? 0
        let totalWidth = imageWidth + titleLeftMargin + titleWidth
        let imageViewX = (frame.width - totalWidth) / 2
        let imageViewY = (frame.height - imageWidth) / 2
        
        imageView.frame = CGRect(x: imageViewX, y: imageViewY, width: imageWidth, height: imageWidth)
        titleLabel.frame = CGRect(x: imageViewX + imageWidth + titleLeftMargin,
                                  y: imageViewY,
                                  width: titleWidth + 3,
                                  height: imageWidth)
    }
    
    // MARK: - Public methods
    
    func configureDate(_ image: UIImage?, _ title: String?) {
        imageView.image = image
        titleLabel.text = title
    }
    
}
