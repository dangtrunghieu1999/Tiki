//
//  ProductDetailInfoCollectionViewCell.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 4/13/21.
//

import UIKit
import FSPagerView
import HCSStarRatingView

class ProductDetailInfoCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Variables
    
    var product: Product?
    
    // MARK: - UI Elements
    
    fileprivate lazy var pageView: FSPagerView = {
        let view = FSPagerView()
        view.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        view.itemSize = FSPagerView.automaticSize
        view.transformer = FSPagerViewTransformer(type: .overlap)
        view.isInfinite = true
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    fileprivate lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.backgroundColor = UIColor.grayBoder
        label.layer.cornerRadius = Dimension.shared.cornerRadiusSmall
        return label
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
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
        label.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        return label
    }()
    
    fileprivate var promotionPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.title.rawValue, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
    fileprivate var originalPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.bodyText
        label.layer.cornerRadius = 5
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        return label
    }()
    
    fileprivate var promotionPercentLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.bodyText
        label.layer.cornerRadius = 5
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        return label
    }()
    
    // MARK: - View LifeCycles
    
    override func initialize() {
        super.initialize()
        layoutPageView()
        layoutNumberLabel()
        layoutTitleLabel()
        layoutRatingView()
        layoutNumberReviewLabel()
        layoutPromotionPriceLabel()
        layoutOriginalPriceLabel()
        layoutPromotionPercentLabel()
    }
    
    // MARK: - Helper Method
    
    // MARK: - GET API
    
    // MARK: - Layout
    
    private func layoutPageView() {
        addSubview(pageView)
        pageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalToSuperview().offset(-Dimension.shared.largeMargin_32)
            make.left.equalToSuperview().offset(Dimension.shared.largeMargin_32)
            make.height.equalTo(320)
        }
    }
    
    private func layoutNumberLabel() {
        addSubview(numberLabel)
        numberLabel.snp.makeConstraints { (make) in
            make.top.equalTo(pageView.snp.bottom).offset(Dimension.shared.mediumMargin)
            make.width.equalTo(35)
            make.right.equalToSuperview().offset(-Dimension.shared.normalMargin)
            make.height.equalTo(20)
        }
    }
    
    private func layoutTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Dimension.shared.normalMargin)
            make.right.equalToSuperview().offset(-Dimension.shared.normalMargin)
            make.top.equalTo(numberLabel.snp.bottom).offset(Dimension.shared.mediumMargin)
        }
    }
    
    private func layoutRatingView() {
        addSubview(ratingView)
        ratingView.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(Dimension.shared.smallMargin)
            make.width.equalTo(100)
            make.height.equalTo(30)
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
    
    private func layoutPromotionPriceLabel() {
        addSubview(promotionPriceLabel)
        promotionPriceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(ratingView.snp.bottom).offset(Dimension.shared.smallMargin)
        }
    }
    
    private func layoutOriginalPriceLabel() {
        addSubview(originalPriceLabel)
        originalPriceLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(promotionPriceLabel)
            make.left.equalTo(promotionPriceLabel.snp.right).offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutPromotionPercentLabel() {
        addSubview(promotionPercentLabel)
        promotionPercentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(originalPriceLabel.snp.right).offset(Dimension.shared.mediumMargin)
            make.bottom.equalTo(originalPriceLabel)
        }
    }
}

// MARK: - FSPagerViewDataSource

extension ProductDetailInfoCollectionViewCell: FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return product?.photos.count ?? 0
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let imageURL = product?.photos[index].url
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.sd_setImage(with: imageURL?.url, completed: nil)
        cell.imageView?.contentMode = .scaleToFill
        cell.imageView?.clipsToBounds = true
        return cell
    }
}

// MARK: - FSPagerViewDelegate

extension ProductDetailInfoCollectionViewCell: FSPagerViewDelegate {
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        self.numberLabel.text = "\(targetIndex + 1)/\(product?.photos.count ?? 0)"
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        self.numberLabel.text = "\(pagerView.currentIndex)/\(product?.photos.count ?? 0)"
    }
}

// MARK: - ProductDetailProtocol

extension ProductDetailInfoCollectionViewCell: ProductDetailProtocol {
    func configDataInfomation(product: Product?) {
        self.product = product
        self.pageView.reloadData()
        self.numberLabel.text = "1/\(product?.photos.count ?? 0)"
        let productName = product?.name ?? ""
        self.titleLabel.attributedText = lineSpacingLabel(title: productName)
        self.ratingView.value = CGFloat(product?.rating ?? 0)
        self.numberReviewLabel.text = "(Xem \(product?.number_comment ?? 0) đánh giá)"
        self.promotionPriceLabel.text = product?.promoPrice.currencyFormat
        let originalPrice = product?.unitPrice
        self.originalPriceLabel.attributedText = drawLineBetween(price: originalPrice)
        let promotionPercent = product?.promotion_percent ?? 0
        self.promotionPercentLabel.text = "-\(promotionPercent)%"
    }
    
    func lineSpacingLabel(title: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: title)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        paragraphStyle.minimumLineHeight = 5
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                      value:paragraphStyle,
                                      range:NSMakeRange(0, attributedString.length))
        return attributedString
    }
    
    func drawLineBetween(price: Double?) -> NSMutableAttributedString  {
        let myString = price?.currencyFormat ?? ""
        let attributeString = NSMutableAttributedString(string: myString)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                     value: 1,
                                     range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
}
