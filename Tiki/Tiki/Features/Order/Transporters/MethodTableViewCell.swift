//
//  MethodTableViewCell.swift
//  Tiki
//
//  Created by Bee_MacPro on 06/06/2021.
//

import UIKit

class MethodTableViewCell: BaseTableViewCell {
    
    // MARK: - UI Elements
    
    private lazy var checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = ImageManager.checkMarkUnCheck
        return imageView
    }()
    
    private let logoMethodImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let methodTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.bodyText
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        return label
    }()
    
    // MARK: - View LifeCycles
    
    override func initialize() {
        super.initialize()
        layoutCheckImageView()
        layoutLogoMethodImageView()
        layoutMethodTitleLabel()
    }
    
    // MARK: - Public methods
    
    func configData(_ paymentType: PaymentMethodType) {
        logoMethodImageView.image = paymentType.logo
        methodTitleLabel.text     = paymentType.name
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                checkImageView.image = ImageManager.checkMarkCheck
            } else {
                checkImageView.image = ImageManager.checkMarkUnCheck
            }
        }
    }
    
    // MARK: - Setup Layouts
    
    
    private func layoutCheckImageView() {
        addSubview(checkImageView)
        checkImageView.snp.makeConstraints { (make) in
            make.width.height
                .equalTo(18)
            make.left
                .equalToSuperview()
                .offset(dimension.largeMargin)
            make.centerY
                .equalToSuperview()
        }
    }
    
    private func layoutLogoMethodImageView() {
        addSubview(logoMethodImageView)
        logoMethodImageView.snp.makeConstraints { (make) in
            make.left
                .equalTo(checkImageView.snp.right)
                .offset(dimension.largeMargin)
            make.width.height
                .equalTo(24)
            make.top.equalTo(checkImageView)
        }
    }
    
    private func layoutMethodTitleLabel() {
        addSubview(methodTitleLabel)
        methodTitleLabel.snp.makeConstraints { (make) in
            make.left
                .equalTo(logoMethodImageView.snp.right)
                .offset(dimension.largeMargin)
            make.right
                .equalToSuperview()
            make.top.equalTo(checkImageView)
        }
    }
}
