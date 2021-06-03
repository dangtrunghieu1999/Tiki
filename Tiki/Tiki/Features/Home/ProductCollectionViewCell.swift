//
//  ProductRecommendCollectionViewCell.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 4/9/21.
//

import UIKit
import HCSStarRatingView

class ProductCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Variables
    
    var fontSize: UIFont? {
        didSet {
            productTitleLabel.font = fontSize ??
                .systemFont(ofSize: FontSize.h1.rawValue)
            
            finalPriceLabel.font = fontSize ??
                .systemFont(ofSize: FontSize.h1.rawValue)
            
            promoPercentLabel.isHidden = true
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
    
    fileprivate lazy var productImageView: ShimmerImageView = {
        let imageView = ShimmerImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    fileprivate lazy var productTitleLabel: ShimmerLabel = {
        let label = ShimmerLabel()
        label.numberOfLines = 2
        label.textAlignment = .left
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .semibold)
        return label
    }()
    
    
    fileprivate lazy var productRatingView: HCSStarRatingView = {
        let ratingView = HCSStarRatingView()
        ratingView.tintColor = UIColor.ratingColor
        ratingView.allowsHalfStars = true
        ratingView.isUserInteractionEnabled = false
        return ratingView
    }()
    
    private var ratingShimmerView: BaseShimmerView = {
        let view = BaseShimmerView()
        view.isHidden = true
        return view
    }()
    
    fileprivate lazy var numberReviewLabel: ShimmerLabel = {
        let label = ShimmerLabel()
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h3.rawValue)
        return label
    }()
    
    fileprivate var finalPriceLabel: ShimmerLabel = {
        let label = ShimmerLabel()
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.body.rawValue, weight: .medium)
        return label
    }()
    
    fileprivate var promoPercentLabel: ShimmerLabel = {
        let label = ShimmerLabel()
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
        layoutRatingShimmerView()
        layoutNumberReviewLabel()
        layoutFinalPriceLabel()
        layoutPromotionPercentLabel()
        self.startShimmering()
    }
    
    // MARK: - Helper Method
    
    func startShimmering() {
        productImageView.startShimmer()
        productTitleLabel.startShimmer()
        numberReviewLabel.startShimmer()
        finalPriceLabel.startShimmer()
        promoPercentLabel.startShimmer()
        ratingShimmerView.startShimmer()
        productRatingView.isHidden = true
        ratingShimmerView.isHidden = false
    }
    
    func stopShimmering() {
        productImageView.stopShimmer()
        productTitleLabel.stopShimmer()
        numberReviewLabel.stopShimmer()
        finalPriceLabel.stopShimmer()
        promoPercentLabel.stopShimmer()
        ratingShimmerView.stopShimmer()
        productRatingView.isHidden = false
        ratingShimmerView.isHidden = true
    }
    
    func configCell(_ product: Product) {
        self.productImageView.loadImage(by: ""
                                        , defaultImage: UIImage(named: "temp1"))
        self.productTitleLabel.text  = product.name
        self.numberReviewLabel.text  = "(\(product.number_comment))"
        self.productRatingView.value = CGFloat(product.rating)
        self.finalPriceLabel.text    = product.promoPrice.currencyFormat
        self.promoPercentLabel.text  = "-\(product.promotion_percent)%"
    }
    
    // MARK: - GET API
    
    // MARK: - Layout
    
    private func layoutBaseView() {
        addSubview(coverView)
        coverView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalToSuperview()
        }
    }
    
    private func layoutProductImageView() {
        coverView.addSubview(productImageView)
        productImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
                .inset(dimension.smallMargin)
            make.height.equalTo(self.snp.width)
                .multipliedBy(dimension.productImageRatio)
        }
    }
    
    private func layoutTitleLabel() {
        coverView.addSubview(productTitleLabel)
        productTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(productImageView.snp.bottom)
                .offset(Dimension.shared.normalMargin)
            make.left.right.equalToSuperview()
                .inset(dimension.mediumMargin_12)
        }
    }
    
    private func layoutRatingView() {
        coverView.addSubview(productRatingView)
        productRatingView.snp.makeConstraints { (make) in
            make.left.equalTo(productTitleLabel)
            make.top.equalTo(productTitleLabel.snp.bottom)
                .offset(dimension.mediumMargin)
            make.width.equalTo(60)
            make.height.equalTo(10)
        }
    }
    
    private func layoutRatingShimmerView() {
        coverView.addSubview(ratingShimmerView)
        ratingShimmerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func layoutNumberReviewLabel() {
        coverView.addSubview(numberReviewLabel)
        numberReviewLabel.snp.makeConstraints { (make) in
            make.left.equalTo(productRatingView.snp.right)
                .offset(dimension.mediumMargin)
            make.top.equalTo(productRatingView)
            make.centerY.equalTo(productRatingView)
        }
    }
    
    private func layoutFinalPriceLabel() {
        coverView.addSubview(finalPriceLabel)
        finalPriceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(productTitleLabel)
            make.top.equalTo(productRatingView.snp.bottom)
                .offset(dimension.mediumMargin)
        }
    }
    
    private func layoutPromotionPercentLabel() {
        coverView.addSubview(promoPercentLabel)
        promoPercentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(finalPriceLabel.snp.right)
                .offset(dimension.mediumMargin)
            make.width.equalTo(40)
            make.top.equalTo(finalPriceLabel)
            make.bottom.equalTo(finalPriceLabel)
        }
    }
}

