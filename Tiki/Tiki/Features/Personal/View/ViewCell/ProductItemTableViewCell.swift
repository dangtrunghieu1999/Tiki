//
//  ProductItemTableViewCell.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 5/16/21.
//

import UIKit
import HCSStarRatingView

class ProductItemTableViewCell: BaseTableViewCell {
    
    fileprivate lazy var bottomView: BaseView = {
        let view = BaseView()
        view.backgroundColor = UIColor.separator
        return view
    }()
    
    fileprivate lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "temp1")
        return imageView
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .left
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .semibold)
        label.text = "Hộp Cơm Giữ Nhiệt INOX304 Màu Sắc Hiện Đại Kèm Muỗng Đũa INOX"
        return label
    }()
    
    fileprivate lazy var shopTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .left
        label.textColor = UIColor.lightBodyText
        label.text = "Cung cấp bởi Ghế Nam Việt"
        label.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        return label
    }()
    
    fileprivate lazy var finalPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.bodyText
        label.text = 269000.currencyFormat
        label.font = UIFont.systemFont(ofSize: FontSize.body.rawValue, weight: .bold)
        return label
    }()
        
    fileprivate lazy var ratingView: HCSStarRatingView = {
        let ratingView = HCSStarRatingView()
        ratingView.tintColor = UIColor.ratingColor
        ratingView.allowsHalfStars = true
        ratingView.isUserInteractionEnabled = false
        ratingView.value = 5
        return ratingView
    }()
    
    fileprivate lazy var numberReviewLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h3.rawValue)
        label.text = "600"
        return label
    }()
    
    fileprivate lazy var soldOutTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Hết hàng"
        label.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        label.textColor = UIColor.primary
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
        label.text = "-25%"
        return label
    }()


    // MARK: - View LifeCycles
    
    override func initialize() {
        super.initialize()
        layoutProductImageView()
        layoutTitleLabel()
        layoutShopTitleLabel()
        layoutFinalPriceLabel()
        layoutPromotionPercentLabel()
        layoutRatingView()
        layoutNumberReviewLabel()
        layoutBottomView()
        layoutSoldOutTitleLabel()
    }
    
    // MARK: - Helper Method
    
    // MARK: - GET API
    
    // MARK: - Layout
    
    private func layoutProductImageView() {
        addSubview(productImageView)
        productImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
                .offset(Dimension.shared.normalMargin)
            make.left.equalToSuperview()
                .offset(Dimension.shared.normalMargin)
            make.width.height.equalTo(150)
        }
    }
    
    private func layoutTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(productImageView.snp.top)
                .offset(Dimension.shared.mediumMargin)
            make.left.equalTo(productImageView.snp.right)
                .offset(Dimension.shared.mediumMargin)
            make.right.equalToSuperview()
                .offset(-Dimension.shared.normalMargin)
        }
    }
    
    private func layoutShopTitleLabel() {
        addSubview(shopTitleLabel)
        shopTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
                .offset(Dimension.shared.mediumMargin)
            make.left.equalTo(titleLabel)
        }
    }
    
    private func layoutFinalPriceLabel() {
        addSubview(finalPriceLabel)
        finalPriceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(shopTitleLabel.snp.bottom)
                .offset(Dimension.shared.mediumMargin)
        }
    }
    
    private func layoutPromotionPercentLabel() {
        addSubview(promotionPercentLabel)
        promotionPercentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(finalPriceLabel.snp.right).offset(Dimension.shared.mediumMargin)
            make.width.equalTo(40)
            make.top.equalTo(finalPriceLabel)
            make.bottom.equalTo(finalPriceLabel)
        }
    }

        
    private func layoutRatingView() {
        addSubview(ratingView)
        ratingView.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(finalPriceLabel.snp.bottom)
                .offset(Dimension.shared.mediumMargin)
            make.width.equalTo(60)
            make.height.equalTo(10)
        }
    }
    
    private func layoutNumberReviewLabel() {
        addSubview(numberReviewLabel)
        numberReviewLabel.snp.makeConstraints { (make) in
            make.left.equalTo(ratingView.snp.right).offset(Dimension.shared.mediumMargin)
            make.top.equalTo(ratingView)
            make.centerY.equalTo(ratingView)
        }
    }
    
    private func layoutSoldOutTitleLabel() {
        addSubview(soldOutTitleLabel)
        soldOutTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(ratingView.snp.bottom)
                .offset(Dimension.shared.mediumMargin)
        }
    }

    
    private func layoutBottomView() {
        addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}

extension ProductItemTableViewCell {
    
    func configCell(_ product: Product, isBought: Bool) {
        
        if isBought {
            self.promotionPercentLabel.isHidden = true
        } else {
            self.soldOutTitleLabel.isHidden = true
        }
        self.productImageView.sd_setImage(with: product.photos[0].url.url, completed: nil)
        self.titleLabel.text  = product.name.capitalized
        self.shopTitleLabel.text = product.shopName
        self.soldOutTitleLabel.text = "Hết hàng"
        self.ratingView.value = CGFloat(product.rating)
        self.numberReviewLabel.text = "(\(product.number_comment))"
        self.finalPriceLabel.text = product.promoPrice.currencyFormat
        self.promotionPercentLabel.text = "-\(product.promotion_percent)%"
    }
}
