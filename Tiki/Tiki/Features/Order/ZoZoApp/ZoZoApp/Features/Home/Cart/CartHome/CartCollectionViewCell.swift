//
//  CartCollectionViewCell.swift
//  ZoZoApp
//
//  Created by Dang Trung Hieu on 8/17/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

protocol CartProductCellDelegate: class {
    func didSelectIncreaseNumber(product : Product)
    func didSelectDecreaseNumber(product : Product)
    func didSelectDeleteProduct(product : Product)
    func didSelectEditProduct(product : Product)
    func didSelectShopAvatar(id: Int?)
}

class CartCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Variables
    
    weak var delegate: CartProductCellDelegate?
    private var shopId: Int?
    private var product = Product()
    
    // MARK: - UI Elements
    
    fileprivate lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnShopAvatar))
        imageView.addGestureRecognizer(tapGesture)
        return imageView
    }()
    
    fileprivate lazy var productNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .medium)
        label.textColor = UIColor.bodyText
        label.numberOfLines = 1
        return label
    }()
    
    fileprivate lazy var editButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.edit, for: .normal)
        button.backgroundColor = UIColor.clear
        button.setTitleColor(UIColor.lightBodyText, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        button.addTarget(self, action: #selector(touchInEditButton), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var productColorLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.color.localized()
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        return label
    }()
    
    fileprivate lazy var selectColorLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.layer.borderColor = UIColor.background.cgColor
        label.layer.borderWidth = 0.3
        label.layer.cornerRadius = 12.5
        label.leftInset = 10
        label.rightInset = 10
        label.textColor = UIColor.background
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        return label
    }()
    
    fileprivate lazy var productSizeLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.size.localized()
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        return label
    }()
    
    fileprivate lazy var selectSizeLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.layer.borderColor = UIColor.background.cgColor
        label.layer.borderWidth = 0.3
        label.layer.cornerRadius = 12.5
        label.leftInset = 10
        label.rightInset = 10
        label.textColor = UIColor.background
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        return label
    }()
    
    fileprivate lazy var decreaseButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.decrease, for: .normal)
        button.backgroundColor = UIColor.clear
        button.layer.masksToBounds = true
        button.layer.borderWidth = 0.3
        button.addTarget(self, action: #selector(decreaseFunc), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var increaseButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.increase, for: .normal)
        button.backgroundColor = UIColor.clear
        button.layer.masksToBounds = true
        button.layer.borderWidth = 0.3
        button.addTarget(self, action: #selector(increaseFunc), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var productQuantityLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.text = "1"
        label.textAlignment = .center
        label.leftInset = 10
        label.rightInset = 10
        label.layer.borderWidth = 0.3
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .medium)
        return label
    }()
    
    fileprivate lazy var orderQuantityLabel: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.isHidden = true
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        return label
    }()
    
    fileprivate lazy var productPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        return label
    }()
    
    fileprivate lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.delete, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(touchInDeleteButton), for: .touchUpInside)
      return button
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightSeparator
        return view
    }()

    // MARK: - View LifeCycles
    
    override func initialize() {
        super.initialize()
        
        layoutProductImageView()
        layoutProductNameLabel()
        layoutProductColorLabel()
        layoutSettingButton()
        layoutSelectColorLabel()
        layoutProductSizeLabel()
        layoutSelectSizeLabel()
        layoutDecreaseButton()
        layoutQuantilyLabel()
        layoutIncreaseButton()
        layoutProductPriceLabel()
        layoutDeleteButton()
        layoutLineView()
        
        layoutOrderQuantityLabel()
    }
    
    // MARK: - Public methods
    
    func configData(_ product: Product) {
        self.product = product
        shopId = product.shopId
        productImageView.loadImage(by: product.defaultImage,
                                   defaultImage: ImageManager.imagePlaceHolder)
        productNameLabel.text       = product.name
        selectSizeLabel.text        = product.selectedSize
        selectColorLabel.text       = product.selectedColor
        productPriceLabel.text      = product.finalPrice.currencyFormat
        productQuantityLabel.text   = product.quantity.description
    }

    func setupLayoutForCartButton() {
        editButton.isHidden             = true
        deleteButton.isHidden           = true
        productQuantityLabel.isHidden   = true
        decreaseButton.isHidden         = true
        increaseButton.isHidden         = true
        orderQuantityLabel.isHidden     = false
        orderQuantityLabel.text         = "\(TextManager.quantity.description): \(product.quantity)"
    }
    
    // MARK: - UI Action
    
    @objc private func tapOnShopAvatar() {
        delegate?.didSelectShopAvatar(id: shopId)
    }
    
    @objc private func decreaseFunc() {
        delegate?.didSelectDecreaseNumber(product: product)
    }
    
    @objc private func increaseFunc() {
        delegate?.didSelectIncreaseNumber(product: product)
    }
    
    @objc private func touchInDeleteButton() {
        delegate?.didSelectDeleteProduct(product: product)
    }
    
    @objc private func touchInEditButton() {
        delegate?.didSelectEditProduct(product: product)
    }
    
    // MARK: - Setup Layouts
    
    private func layoutProductImageView() {
        addSubview(productImageView)
        productImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Dimension.shared.smallMargin)
            make.height.width.equalTo(65)
            make.centerY.equalToSuperview()
        }
    }
    
    private func layoutSettingButton() {
        addSubview(editButton)
        editButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Dimension.shared.smallMargin)
            make.right.equalToSuperview().offset(-Dimension.shared.mediumMargin)
            make.height.equalTo(20)
        }
    }
    
    private func layoutProductNameLabel() {
        addSubview(productNameLabel)
        productNameLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Dimension.shared.largeMargin)
            make.left.equalTo(productImageView.snp.right).offset(Dimension.shared.mediumMargin)
            make.right.equalToSuperview().offset(-Dimension.shared.normalMargin)
        }
    }
    
    private func layoutProductColorLabel() {
        addSubview(productColorLabel)
        productColorLabel.snp.makeConstraints { (make) in
            make.top.equalTo(productNameLabel.snp.bottom).offset(Dimension.shared.normalMargin)
            make.left.equalTo(productNameLabel)
        }
    }
    
    private func layoutSelectColorLabel() {
        addSubview(selectColorLabel)
        selectColorLabel.snp.makeConstraints { (make) in
            make.left.equalTo(productColorLabel.snp.right).offset(Dimension.shared.smallMargin)
            make.centerY.equalTo(productColorLabel)
        }
    }
    
    private func layoutProductSizeLabel() {
        addSubview(productSizeLabel)
        productSizeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(productColorLabel)
            make.left.equalTo(selectColorLabel.snp.right).offset(Dimension.shared.mediumMargin)
        }
    }
    
    private func layoutSelectSizeLabel() {
        addSubview(selectSizeLabel)
        selectSizeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(selectColorLabel)
            make.left.equalTo(productSizeLabel.snp.right).offset(Dimension.shared.smallMargin)
        }
    }
    
    private func layoutDecreaseButton() {
        addSubview(decreaseButton)
        decreaseButton.snp.makeConstraints { (make) in
            make.top.equalTo(productColorLabel.snp.bottom).offset(Dimension.shared.normalMargin)
            make.left.equalTo(productColorLabel)
            make.height.width.equalTo(25)
        }
    }
    
    private func layoutQuantilyLabel() {
        addSubview(productQuantityLabel)
        productQuantityLabel.snp.makeConstraints { (make) in
            make.top.equalTo(decreaseButton)
            make.left.equalTo(decreaseButton.snp.right)
            make.width.equalTo(40)
            make.height.equalTo(25)
        }
    }
    
    private func layoutIncreaseButton() {
        addSubview(increaseButton)
        increaseButton.snp.makeConstraints { (make) in
            make.top.equalTo(decreaseButton)
            make.left.equalTo(productQuantityLabel.snp.right)
            make.height.width.equalTo(25)
        }
    }
    
    private func layoutOrderQuantityLabel() {
        addSubview(orderQuantityLabel)
        orderQuantityLabel.snp.makeConstraints { (make) in
            make.left.top.equalTo(decreaseButton)
        }
    }
    
    private func layoutProductPriceLabel() {
        addSubview(productPriceLabel)
        productPriceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(decreaseButton.snp.bottom).offset(Dimension.shared.mediumMargin)
            make.left.equalTo(decreaseButton)
            make.right.equalToSuperview().offset(-Dimension.shared.largeMargin_42)
        }
    }
    
    private func layoutDeleteButton() {
        addSubview(deleteButton)
        deleteButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-Dimension.shared.largeMargin)
            make.right.equalToSuperview().offset(-Dimension.shared.mediumMargin)
            make.width.height.equalTo(25)
        }
    }

    private func layoutLineView() {
        addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.width.bottom.centerX.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
}
