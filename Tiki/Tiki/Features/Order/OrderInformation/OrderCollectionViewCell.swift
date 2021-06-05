//
//  OrderInfomationCollectionViewCell.swift
//  ZoZoApp
//
//  Created by Dang Trung Hieu on 8/26/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class OrderCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - UI Elements
    
    private let borderView: BaseView = {
        let view = BaseView()
        view.layer.borderColor  = UIColor.separator.cgColor
        view.layer.borderWidth  = 2
        view.layer.cornerRadius = dimension.conerRadiusMedium
        view.layer.masksToBounds = true
        return view
    }()
    
    private let firstHeaderView: BaseView = {
        let view = BaseView()
        view.backgroundColor    = .lightGreenColor
        view.layer.borderColor  = UIColor.greenColor.cgColor
        view.layer.borderWidth  = 1
        view.layer.cornerRadius = dimension.conerRadiusMedium
        return view
    }()
    
    private let packImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.icon_pack
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
   private let packTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .greenColor
        label.text = TextManager.pack
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        return label
    }()
    
    private let secondHeaderView: BaseView = {
        let view = BaseView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    fileprivate lazy var intendTimeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .greenColor
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue,
                                       weight: .bold)
        label.text = "Giao vào Thứ Ba, 08/06"
        return label
    }()
    
    // MARK: - View LifeCycles
    
    override func initialize() {
        super.initialize()
        layoutBorderView()
        layoutFirstHeaderView()
        layoutPackImageView()
        layoutPackTitleLabel()
        layoutSecondHeaderView()
    }
    
    private func layoutBorderView() {
        addSubview(borderView)
        borderView.snp.makeConstraints { (make) in
            make.left.right
                .equalToSuperview()
                .inset(dimension.normalMargin)
            make.top
                .equalToSuperview()
            make.bottom
                .equalToSuperview()
                .inset(dimension.largeMargin)
        }
    }
    
    private func layoutFirstHeaderView() {
        addSubview(firstHeaderView)
        firstHeaderView.snp.makeConstraints { (make) in
            make.top
                .equalToSuperview()
                .offset(-dimension.largeMargin)
            make.height
                .equalTo(50)
            make.width
                .equalTo(80)
            make.left
                .equalToSuperview()
                .offset(dimension.largeMargin)
        }
    }
    
    private func layoutPackImageView() {
        firstHeaderView.addSubview(packImageView)
        packImageView.snp.makeConstraints { (make) in
            make.left
                .equalToSuperview()
                .offset(dimension.mediumMargin_12)
            make.centerY
                .equalToSuperview()
            make.width.height
                .equalTo(24)
        }
    }
    
    private func layoutPackTitleLabel() {
        firstHeaderView.addSubview(packTitleLabel)
        packTitleLabel.snp.makeConstraints { (make) in
            make.left
                .equalTo(packImageView.snp_right)
                .offset(dimension.mediumMargin)
            make.right
                .equalToSuperview()
                .inset(dimension.mediumMargin)
            make.centerY
                .equalTo(packImageView)
        }
    }
    
    private func layoutSecondHeaderView() {
        addSubview(secondHeaderView)
        secondHeaderView.snp.makeConstraints { (make) in
            make.top
                .equalToSuperview()
                .offset(-dimension.largeMargin)
            make.height
                .equalTo(50)
            make.width
                .equalTo(170)
            make.left
                .equalTo(firstHeaderView.snp.right)
        }
    }
    
    private func layoutIntendTimeLabel() {
        addSubview(intendTimeLabel)
        
    }
    
}
