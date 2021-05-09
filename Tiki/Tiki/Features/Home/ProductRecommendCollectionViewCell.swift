//
//  ProductRecommendCollectionViewCell.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 4/9/21.
//

import UIKit
import HCSStarRatingView

class ProductRecommendCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Variables

    var fontSize: UIFont? {
        didSet {
            titleLabel.font = fontSize
            finalPriceLabel.font = fontSize
            promotionPercentLabel.isHidden = true
        }
    }
    
    var colorCoverView: UIColor? = .white {
        didSet {
            coverView.backgroundColor = colorCoverView
        }
    }
        
    // MARK: - UI Elements
    
    fileprivate lazy var coverView: BaseView = {
        let view = BaseView()
        return view
    }()
    
    fileprivate lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .left
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .semibold)
        return label
    }()
    
    fileprivate lazy var ratingView: HCSStarRatingView = {
        let ratingView = HCSStarRatingView()
        ratingView.tintColor = UIColor.ratingColor
        ratingView.allowsHalfStars = true
        ratingView.isUserInteractionEnabled = false
        return ratingView
    }()
    
    fileprivate lazy var numberReviewLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h3.rawValue)
        return label
    }()
    
    fileprivate var finalPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.body.rawValue, weight: .medium)
        return label
    }()
    
    fileprivate var promotionPercentLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.red
        label.textColor = .white
        label.layer.cornerRadius = 5
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.layer.masksToBounds = true
        return label
    }()
    

    // MARK: - View LifeCycles
    
    override func initialize() {
        super.initialize()
        backgroundColor = UIColor.lightBackground
        layoutBaseView()
        layoutProductImageView()
        layoutTitleLabel()
        layoutRatingView()
        layoutNumberReviewLabel()
        layoutFinalPriceLabel()
        layoutPromotionPercentLabel()
    }
    
    // MARK: - Helper Method
    
    // MARK: - GET API
    
    // MARK: - Layout
    
    private func layoutBaseView() {
        addSubview(coverView)
        coverView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalToSuperview().offset(1)
        }
    }
    
    private func layoutProductImageView() {
        coverView.addSubview(productImageView)
        productImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Dimension.shared.smallMargin)
            make.left.equalToSuperview().offset(Dimension.shared.smallMargin)
            make.right.equalToSuperview().offset(-Dimension.shared.smallMargin)
            make.height.equalTo(self.snp.width).multipliedBy(Dimension.shared.productImageRatio)
        }
    }
    
    private func layoutTitleLabel() {
        coverView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(productImageView.snp.bottom).offset(Dimension.shared.normalMargin)
            make.left.equalToSuperview().offset(Dimension.shared.mediumMargin_12)
            make.right.equalToSuperview().offset(-Dimension.shared.mediumMargin_12)
        }
    }
    
    private func layoutRatingView() {
        coverView.addSubview(ratingView)
        ratingView.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(Dimension.shared.mediumMargin)
            make.width.equalTo(60)
            make.height.equalTo(10)
        }
    }
    
    private func layoutNumberReviewLabel() {
        coverView.addSubview(numberReviewLabel)
        numberReviewLabel.snp.makeConstraints { (make) in
            make.left.equalTo(ratingView.snp.right).offset(Dimension.shared.mediumMargin)
            make.top.equalTo(ratingView)
            make.centerY.equalTo(ratingView)
        }
    }
    
    private func layoutFinalPriceLabel() {
        coverView.addSubview(finalPriceLabel)
        finalPriceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(ratingView.snp.bottom).offset(Dimension.shared.mediumMargin)
        }
    }
    
    private func layoutPromotionPercentLabel() {
        coverView.addSubview(promotionPercentLabel)
        promotionPercentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(finalPriceLabel.snp.right).offset(Dimension.shared.mediumMargin)
            make.width.equalTo(40)
            make.top.equalTo(finalPriceLabel)
            make.bottom.equalTo(finalPriceLabel)
        }
    }
}

extension ProductRecommendCollectionViewCell: HomeViewProtocol {
    func configDataProductRecommend(product: [Product]?, at index: Int) {
        guard let product = product?[index] else { return }
        self.productImageView.sd_setImage(with: product.photos[0].url.url, completed: nil)
        self.titleLabel.text  = product.name.capitalized
        self.ratingView.value = CGFloat(product.rating)
        self.numberReviewLabel.text = "(\(product.number_comment))"
        self.finalPriceLabel.text = product.promoPrice.currencyFormat
        self.promotionPercentLabel.text = "-\(product.promotion_percent)%"
    }
}
