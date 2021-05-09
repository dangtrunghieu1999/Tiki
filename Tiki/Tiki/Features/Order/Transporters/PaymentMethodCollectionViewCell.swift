//
//  PaymentMethodCollectionViewCell.swift
//  ZoZoApp
//
//  Created by Dang Trung Hieu on 8/25/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class PaymentMethodCollectionViewCell: BaseCollectionViewCell {
    
    
    // MARK: - UI Elements
    
    fileprivate lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightBackground
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.checkMarkUnCheck
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor.titleText
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - View LifeCycles
    
    override func initialize() {
        super.initialize()
        layoutContainerView()
        layoutImageView()
        layoutTitleLabel()
    }
    
    // MARK: - Public methods
    
    func configData(_ paymentMethodType: PaymentMethodType) {
        titleLabel.text = paymentMethodType.name
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                imageView.image = ImageManager.checkMarkCheck
            } else {
                 imageView.image = ImageManager.checkMarkUnCheck
            }
        }
    }
    
    // MARK: - Setup Layouts
    
    private func layoutContainerView() {
        addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func layoutImageView() {
        containerView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(18)
            make.left.equalToSuperview().offset(Dimension.shared.largeMargin)
            make.centerY.equalToSuperview()
        }
    }
    
    private func layoutTitleLabel() {
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(imageView.snp.right).offset(Dimension.shared.normalMargin)
            make.right.equalToSuperview().offset(-Dimension.shared.normalMargin)
        }
    }
    
}
