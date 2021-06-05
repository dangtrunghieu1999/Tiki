//
//  PaymentMethodCollectionViewCell.swift
//  ZoZoApp
//
//  Created by Dang Trung Hieu on 8/25/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class PaymentCollectionViewCell: BaseCollectionViewCell {
    
    
    private let selectPaymentLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.paymentMethod.localized()
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue,
                                       weight: .bold)
        label.textColor = UIColor.bodyText
        label.textAlignment = .left
        return label
    }()
    
    private lazy var methodImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = ImageManager.icon_momo
        return imageView
    }()
    
    fileprivate lazy var methodTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Thanh toán bằng tiền mặt"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        return label
    }()

    fileprivate lazy var nextButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.setImage(ImageManager.more, for: .normal)
        button.backgroundColor = UIColor.clear
        return button
    }()

    // MARK: - View LifeCycles
    
    override func initialize() {
        super.initialize()
        layoutSelectPaymentLabel()
        layoutMethodImageView()
        layoutMethodTitleLabel()
        layoutNextButton()
    }
    
    private func layoutSelectPaymentLabel() {
        addSubview(selectPaymentLabel)
        selectPaymentLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
                .offset(dimension.normalMargin)
            make.left.equalToSuperview()
                .offset(dimension.normalMargin)
        }
    }
    
    private func layoutMethodImageView() {
        addSubview(methodImageView)
        methodImageView.snp.makeConstraints { (make) in
            make.top
                .equalTo(selectPaymentLabel.snp.bottom)
                .offset(dimension.largeMargin)
            make.width.height
                .equalTo(24)
            make.left
                .equalTo(selectPaymentLabel)
        }
    }
    
    private func layoutMethodTitleLabel() {
        addSubview(methodTitleLabel)
        methodTitleLabel.snp.makeConstraints { (make) in
            make.centerY
                .equalTo(methodImageView)
            make.left
                .equalTo(methodImageView.snp.right)
                .offset(dimension.normalMargin)
        }
    }
    
    private func layoutNextButton() {
        addSubview(nextButton)
        nextButton.snp.makeConstraints { (make) in
            make.right
                .equalToSuperview()
                .inset(dimension.normalMargin)
            make.centerY
                .equalToSuperview()
        }
    }
}
