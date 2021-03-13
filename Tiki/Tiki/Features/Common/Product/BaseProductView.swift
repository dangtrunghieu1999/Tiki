//
//  BaseProductView.swift
//  ZoZoApp
//
//  Created by MACOS on 6/7/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit
import HCSStarRatingView

protocol BaseProductViewDelegate: class {
    func didSelectOption(_ product: Product)
    func didSelectAddToCart(_ product: Product)
    func didSelectRefresh(_ product: Product)
}

class BaseProductView: BaseView {
    
    // MARK: - Variables
    
    weak var delegate: BaseProductViewDelegate?
    
    var isOnwer = false {
        didSet {
            optionImageView.isHidden = !isOnwer
        }
    }
    
    private (set) var product = Product()
    
    static let itemSpacing: CGFloat         = 6
    
    /// Ratio = H / W
    static let productImageRatio: CGFloat   = 0.76
    
    static var estimatedWidth: CGFloat {
        return (ScreenSize.SCREEN_WIDTH - 3 * itemSpacing) / 2
    }
    
    static var guestUserHeight: CGFloat {
        return estimatedWidth + 78
    }
    
    static var shopOwnerHeight: CGFloat {
        return estimatedWidth + 120
    }
    
    static var earnMoneyHeight: CGFloat {
        return estimatedWidth + 165
    }
    
    static var guestUserSize: CGSize {
        return CGSize(width: estimatedWidth, height: guestUserHeight)
    }
    
    static var shopOwnerSize: CGSize {
        return CGSize(width: estimatedWidth, height: shopOwnerHeight)
    }
    
    static var earnMoneySize: CGSize {
        return CGSize(width: estimatedWidth, height: earnMoneyHeight)
    }
    
    // MARK: - UI Elements
    
    var productImageView: ShimmerImageView = {
        let imageView = ShimmerImageView()
        imageView.imageContentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.image = ImageManager.imagePlaceHolder
        return imageView
    }()
    
    var isAuthenticsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true
        imageView.image = ImageManager.checkMarkCheck
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var optionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true
        imageView.image = ImageManager.optionIcon
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnOptionImageView))
        imageView.addGestureRecognizer(tapGesture)
        return imageView
    }()
    
    var productNameLabel: ShimmerLabel = {
        let label = ShimmerLabel()
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .medium)
        label.numberOfLines = 2
        return label
    }()
    
    var finalPriceLabel: ShimmerLabel = {
        let label = ShimmerLabel()
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        return label
    }()
    
    var originalPriceLabel: ShimmerLabel = {
        let label = ShimmerLabel()
        label.text = "            "
        return label
    }()
    
    var discountPercentLabel: ShimmerLabel = {
        let label = ShimmerLabel()
        label.textColor = UIColor.accentColor
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: FontSize.h3.rawValue)
        return label
    }()
    
    var ratingView: HCSStarRatingView = {
        let ratingView = HCSStarRatingView()
        ratingView.tintColor = UIColor.accentColor
        ratingView.allowsHalfStars = true
        ratingView.isUserInteractionEnabled = false
        return ratingView
    }()
    
    private var ratingShimmerView: BaseShimmerView = {
        let view = BaseShimmerView()
        view.isHidden = true
        return view
    }()
    
    var numberRatingLabel: ShimmerLabel = {
        let label = ShimmerLabel()
        label.textColor = UIColor.lightBodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h3.rawValue)
        return label
    }()
    
    var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightBackground
        view.isHidden = true
        return view
    }()
    
    // MARK: - LifeCycles
    
    override func initialize() {
        layoutProductImageView()
        layoutIsWarrantyImageView()
        layoutOptionImageView()
        layoutProductNameLabel()
        layoutFinalPriceLabel()
        layoutOriginalPriceLabel()
        layoutDiscountPercentLabel()
        layoutRatingView()
        layoutRatingShimmerView()
        layoutNumberRatingLabel()
        layoutSeparatorView()
    }
    
    // MARK: - Public method
    
    func configData(product: Product) {
        self.product = product
        
        if let image = product.photos.first?.currentImage {
           productImageView.image = image
        } else {
            productImageView.loadImage(by: product.defaultImage,
                                       defaultImage: ImageManager.imagePlaceHolder)
        }
    
        isAuthenticsImageView.isHidden = !product.authentics
        productNameLabel.text = product.name
        
        if product.promoPrice != 0 {
            finalPriceLabel.text = product.promoPrice.currencyFormat
            originalPriceLabel.text = product.unitPrice.currencyFormat
            
            let attributed: [NSAttributedString.Key: Any]
                = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: FontSize.h2.rawValue),
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
            discountPercentLabel.text = "-\(product.discount)%"
        } else {
            discountPercentLabel.text = ""
        }
        
        numberRatingLabel.text = "(\(product.countRating) \(TextManager.rating.localized()))"
    }
    
    func startShimmering() {
        productImageView.startShimmer()
        productNameLabel.startShimmer()
        finalPriceLabel.startShimmer()
        originalPriceLabel.startShimmer()
        numberRatingLabel.startShimmer()
        ratingShimmerView.startShimmer()
        ratingView.isHidden = true
        ratingShimmerView.isHidden = false
    }
    
    func stopShimmering() {
        productImageView.stopShimmer()
        productNameLabel.stopShimmer()
        finalPriceLabel.stopShimmer()
        originalPriceLabel.stopShimmer()
        numberRatingLabel.stopShimmer()
        ratingShimmerView.stopShimmer()
        ratingView.isHidden = false
        ratingShimmerView.isHidden = true
    }
    
    // MARK: - UI Actions
    
    @objc func tapOnOptionImageView() {
        delegate?.didSelectOption(product)
    }
    
    // MARK: - Setup Layouts
    
    private func layoutProductImageView() {
        addSubview(productImageView)
        productImageView.snp.makeConstraints { (make) in
            make.width.top.left.equalToSuperview()
            make.height.equalTo(self.snp.width).multipliedBy(BaseProductView.productImageRatio)
        }
    }
    
    private func layoutIsWarrantyImageView() {
        addSubview(isAuthenticsImageView)
        isAuthenticsImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(20)
            make.left.top.equalToSuperview().offset(8)
        }
    }
    
    private func layoutOptionImageView() {
        addSubview(optionImageView)
        optionImageView.snp.makeConstraints { (make) in
            make.top.equalTo(isAuthenticsImageView)
            make.width.equalTo(25)
            make.height.equalTo(25)
            make.right.equalToSuperview().offset(-8)
        }
    }
    
    private func layoutProductNameLabel() {
        addSubview(productNameLabel)
        productNameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Dimension.shared.smallMargin)
            make.right.equalToSuperview().offset(-Dimension.shared.smallMargin)
            make.top.equalTo(productImageView.snp.bottom).offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutFinalPriceLabel() {
        addSubview(finalPriceLabel)
        finalPriceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(productNameLabel)
            make.top.equalTo(productNameLabel.snp.bottom).offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutOriginalPriceLabel() {
        addSubview(originalPriceLabel)
        originalPriceLabel.snp.makeConstraints { (make) in
            make.right.equalTo(productNameLabel)
            make.centerY.equalTo(finalPriceLabel)
        }
    }
    
    private func layoutDiscountPercentLabel() {
        addSubview(discountPercentLabel)
        discountPercentLabel.snp.makeConstraints { (make) in
            make.right.equalTo(originalPriceLabel)
            make.bottom.equalTo(originalPriceLabel.snp.top)
        }
    }
    
    private func layoutRatingView() {
        addSubview(ratingView)
        ratingView.snp.makeConstraints { (make) in
            make.left.equalTo(productNameLabel)
            make.top.equalTo(finalPriceLabel.snp.bottom).offset(Dimension.shared.smallMargin)
            make.width.equalTo(80)
            make.height.equalTo(16)
        }
    }
    
    private func layoutRatingShimmerView() {
        addSubview(ratingShimmerView)
        ratingShimmerView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(ratingView)
        }
    }
    
    private func layoutNumberRatingLabel() {
        addSubview(numberRatingLabel)
        numberRatingLabel.snp.makeConstraints { (make) in
            make.left.equalTo(ratingView.snp.right).offset(4)
            make.centerY.equalTo(ratingView)
        }
    }
    
    private func layoutSeparatorView() {
        addSubview(separatorView)
        separatorView.snp.makeConstraints { (make) in
            make.width.bottom.centerX.equalToSuperview()
            make.height.equalTo(BaseProductView.itemSpacing)
        }
    }
    
}
