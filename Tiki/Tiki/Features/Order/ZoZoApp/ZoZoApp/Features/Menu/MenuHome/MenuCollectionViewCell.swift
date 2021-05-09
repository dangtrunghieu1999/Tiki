//
//  MenuCollectionViewCell.swift
//  ZoZoApp
//
//  Created by Dang Trung Hieu on 8/28/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class MenuCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - UI Elements
    
    fileprivate lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    fileprivate lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightBodyText
        label.font = UIFont.systemFont(ofSize: FontSize.title.rawValue)
        return label
    }()
    
    fileprivate lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightSeparator
        return view
    }()
    
    // MARK: - View LifeCycles
    
    override func initialize() {
        super.initialize()
        
        layoutLogoImageView()
        layoutDescriptionLabel()
        layoutLineView()
    }
    
    // MARK: - Public Method
    
    public func configSetting(setting: MenuOption?) {
        self.iconImageView.image = setting?.image
        self.descriptionLabel.text = setting?.description
    }
    
    // MARK: - Setup Layouts
    
    private func layoutLogoImageView() {
        addSubview(iconImageView)
        iconImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(20)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutDescriptionLabel() {
        addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(iconImageView)
            make.left.equalTo(iconImageView.snp.right).offset(Dimension.shared.normalMargin)
            make.right.equalToSuperview().offset(-Dimension.shared.normalMargin)
        }
    }
    
    private func layoutLineView() {
        addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
            make.right.equalToSuperview().offset(-Dimension.shared.mediumMargin)
            make.left.equalToSuperview().offset(Dimension.shared.largeMargin_42)
        }
    }
}
