//
//  EmptyView.swift
//  ZoZoApp
//
//  Created by LAP12852 on 7/7/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class EmptyView: BaseView {
    
    // MARK: - Variables
    
    var message: String? {
        didSet {
            titleLabel.text = message
        }
    }
    
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    var font: UIFont = UIFont.systemFont(ofSize: FontSize.body.rawValue) {
        didSet {
            titleLabel.font = font
        }
    }
    
    // MARK: - UI Elements
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode =  .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.image = ImageManager.empty
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.lightBodyText
        label.font = UIFont.systemFont(ofSize: FontSize.body.rawValue)
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - LifeCycles
    
    override func initialize() {
        layoutImageView()
        layoutTitleLabel()
    }
    
    // MARK: - Public method
    
    func updateImageSize(_ size: CGSize) {
        imageView.snp.updateConstraints { (make) in
            make.width.equalTo(size.width)
            make.height.equalTo(size.height)
        }
    }

    // MARK: - Layout
    
    private func layoutImageView() {
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(Dimension.shared.largeMargin_120)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-Dimension.shared.mediumMargin)
        }
    }
    
    private func layoutTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(Dimension.shared.mediumMargin)
        }
    }
}
