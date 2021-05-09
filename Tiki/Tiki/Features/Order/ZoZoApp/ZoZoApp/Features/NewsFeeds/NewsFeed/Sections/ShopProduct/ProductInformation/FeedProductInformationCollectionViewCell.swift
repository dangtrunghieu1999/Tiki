//
//  FeedProductInformationCollectionViewCell.swift
//  ZoZoApp
//
//  Created by LAP12852 on 10/27/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit
import HCSStarRatingView

class FeedProductInformationCollectionViewCell: BaseCollectionViewCell {

    // MARK: - UI Elements
    
    fileprivate var productNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.title.rawValue)
        label.numberOfLines = 0
        return label
    }()
    
    fileprivate var finalPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.headline.rawValue, weight: .medium)
        return label
    }()
    
    fileprivate var originalPriceLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    fileprivate var discountPercentLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.accentColor
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: FontSize.body.rawValue)
        return label
    }()
    
    fileprivate var ratingView: HCSStarRatingView = {
        let ratingView = HCSStarRatingView()
        ratingView.tintColor = UIColor.accentColor
        ratingView.allowsHalfStars = true
        ratingView.isUserInteractionEnabled = false
        return ratingView
    }()
    
    fileprivate var numberRatingLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.background
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        return label
    }()
    
    private lazy var buyNowButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.accentColor
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        button.setTitle(TextManager.buyNow.capitalized.localized(), for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        button.addTarget(self, action: #selector(touchInBuyNowButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var seeMoreButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.clear
        button.layer.borderColor = UIColor.primary.cgColor
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        button.setTitle(TextManager.seemore.capitalized.localized(), for: .normal)
        button.setTitleColor(UIColor.primary, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        button.addTarget(self, action: #selector(touchInBuyNowButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - LifeCycles
    
    override func initialize() {
        layoutProductNameLabel()
        layoutRatingView()
        layoutNumberRatingLabel()
        layoutFinalPriceLabel()
        layoutOriginalPriceLabel()
        layoutDiscountPercentLabel()
        layoutBuyNowButton()
        layoutSeeMoreButton()
    }
    
    // MARK: - Public Methods
    
    func configureData(_ product: Product) {
        productNameLabel.text = product.name
        
        if product.promoPrice != 0 {
            finalPriceLabel.text = product.promoPrice.currencyFormat
            originalPriceLabel.text = product.unitPrice.currencyFormat
            
            let attributed: [NSAttributedString.Key: Any]
                = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: FontSize.title.rawValue),
                   NSAttributedString.Key.strokeColor: UIColor.bodyText,
                   NSAttributedString.Key.foregroundColor: UIColor.lightBodyText,
                   NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue]
            
            let originalPriceAttr = NSAttributedString(string: "\(product.unitPrice.currencyFormat)", attributes: attributed)
            originalPriceLabel.attributedText = originalPriceAttr
        } else {
            finalPriceLabel.text = product.unitPrice.currencyFormat
            originalPriceLabel.text = ""
        }
        
        if product.unitPrice != 0 && product.promoPrice != 0 {
            let discountPercent = Int(CGFloat(product.unitPrice - product.promoPrice) / CGFloat(product.unitPrice) * 100)
            discountPercentLabel.text = "-\(discountPercent)%"
        } else {
            discountPercentLabel.text = ""
        }
        
        numberRatingLabel.text = "(\(product.countRating) \(TextManager.rating.localized()))"
    }
    
    static func estimateHeight(_ product: Product) -> CGFloat {
        let nameHeight = product.name.height(
            withConstrainedWidth: ScreenSize.SCREEN_WIDTH - 2 * Dimension.shared.mediumMargin,
            font: UIFont.systemFont(ofSize: FontSize.title.rawValue))
        
        return nameHeight + 110 + dimension.defaultHeightButton + dimension.mediumMargin
    }
    
    // MARK: - UI Actions
    
    @objc private func touchInBuyNowButton() {
        
    }
    
    @objc private func touchInSeeMoreButton() {
        
    }
    
    // MARK: - Layout
    
    private func layoutProductNameLabel() {
        addSubview(productNameLabel)
        productNameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Dimension.shared.mediumMargin)
            make.right.equalToSuperview().offset(-Dimension.shared.mediumMargin)
            make.top.equalToSuperview().offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutRatingView() {
        addSubview(ratingView)
        ratingView.snp.makeConstraints { (make) in
            make.left.equalTo(productNameLabel)
            make.top.equalTo(productNameLabel.snp.bottom).offset(Dimension.shared.mediumMargin)
            make.width.equalTo(80)
            make.height.equalTo(16)
        }
    }
    
    private func layoutNumberRatingLabel() {
        addSubview(numberRatingLabel)
        numberRatingLabel.snp.makeConstraints { (make) in
            make.left.equalTo(ratingView.snp.right).offset(4)
            make.centerY.equalTo(ratingView)
        }
    }
    
    private func layoutFinalPriceLabel() {
        addSubview(finalPriceLabel)
        finalPriceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(productNameLabel)
            make.top.equalTo(ratingView.snp.bottom).offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutOriginalPriceLabel() {
        addSubview(originalPriceLabel)
        originalPriceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(finalPriceLabel.snp.right).offset(10)
            make.centerY.equalTo(finalPriceLabel)
        }
    }
    
    private func layoutDiscountPercentLabel() {
        addSubview(discountPercentLabel)
        discountPercentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(originalPriceLabel.snp.right).offset(10)
            make.centerY.equalTo(finalPriceLabel)
        }
    }
    
    private func layoutBuyNowButton() {
        addSubview(buyNowButton)
        buyNowButton.snp.makeConstraints { (make) in
            make.height.equalTo(dimension.defaultHeightButton)
            make.leading.equalToSuperview().offset(dimension.mediumMargin)
            make.trailing.equalTo(snp.centerX).offset(-dimension.smallMargin)
            make.top.equalTo(discountPercentLabel.snp.bottom).offset(dimension.largeMargin)
        }
    }
    
    private func layoutSeeMoreButton() {
        addSubview(seeMoreButton)
        seeMoreButton.snp.makeConstraints { (make) in
            make.width.top.height.equalTo(buyNowButton)
            make.trailing.equalToSuperview().inset(dimension.mediumMargin)
        }
    }
    
}

extension FeedProductInformationCollectionViewCell {
    override func bindViewModel(_ viewModel: Any) {
        guard let feedProductInforModel = viewModel as? FeedProductInformationCellModel else {
            return
        }
        
        configureData(feedProductInforModel.product)
    }
}
