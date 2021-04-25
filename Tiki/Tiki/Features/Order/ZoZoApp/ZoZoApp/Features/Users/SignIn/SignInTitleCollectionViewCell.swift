//
//  SignInTitleCollectionViewCell.swift
//  ZoZoApp
//
//  Created by MACOS on 5/31/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class SignInTitleCollectionViewCell: BaseCollectionViewCell {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightBodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        return label
    }()
    
    override func initialize() {
        layoutImageView()
        layoutTitleLabel()
    }
    
    func configCell(image: UIImage?, titile: String) {
        imageView.image = image
        titleLabel.text = titile
    }
    
    private func layoutImageView() {
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.width.height.equalTo(22)
            make.centerY.equalToSuperview()
        }
    }
    
    private func layoutTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(imageView.snp.right).offset(Dimension.shared.mediumMargin)
        }
    }
    
}
