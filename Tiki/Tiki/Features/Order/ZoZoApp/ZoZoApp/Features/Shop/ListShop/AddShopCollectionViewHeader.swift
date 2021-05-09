//
//  AddShopCollectionViewHeader.swift
//  ZoZoApp
//
//  Created by MACOS on 6/9/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

protocol AddShopCollectionViewHeaderDelegate: class {
    func didSelectAddShop()
}

class AddShopCollectionViewHeader: BaseCollectionViewHeaderFooterCell {
    
    // MARK: - Variables
    
    weak var delegate: AddShopCollectionViewHeaderDelegate?
    
    // MARK: - UI Elements
    
    private lazy var addShopButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.addCircle, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(tapOnAddShopButton), for: .touchUpInside)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.addNewShop.localized()
        label.textAlignment = .center
        label.textColor = UIColor.lightBodyText
        label.font = UIFont.systemFont(ofSize: FontSize.body.rawValue)
        label.numberOfLines = 1
        return label
    }()
    
    // MARK: - LifeCycles
    
    override func initialize() {
        layoutAddShopButton()
        layoutTitleLabel()
    }
    
    // MARK: - UIActions
    
    @objc private func tapOnAddShopButton() {
        delegate?.didSelectAddShop()
    }
    
    // MARK: - Layouts
    
    private func layoutAddShopButton() {
        addSubview(addShopButton)
        addShopButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(60)
            make.centerY.equalToSuperview().offset(-8)
            make.centerX.equalToSuperview()
        }
    }
    
    private func layoutTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(addShopButton.snp.bottom).offset(4)
        }
    }
    
}
