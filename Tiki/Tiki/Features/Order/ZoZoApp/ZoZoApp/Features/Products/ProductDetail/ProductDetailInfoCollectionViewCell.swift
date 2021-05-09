//
//  ProductDetailInfoCollectionViewCell.swift
//  ZoZoApp
//
//  Created by MACOS on 7/20/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit
import HCSStarRatingView

protocol ProductDetailInfoCollectionViewCellDelegate: class {
    func didSelectLike()
    func didSelectShareInternal()
    func didSelectFolow()
    func didSelectGetLink()
}

class ProductDetailInfoCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Variables
    
    weak var delegate: ProductDetailInfoCollectionViewCellDelegate?
    fileprivate var product = Product()
    
    // MARK: - UI Elements
    
    fileprivate lazy var imagesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: ScreenSize.SCREEN_WIDTH, height: ScreenSize.SCREEN_WIDTH)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = UIColor.white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerReusableCell(ImageCollectionViewCell.self)
        return collectionView
    }()
    
    fileprivate let pageIndicator: UIPageControl = {
        let pageIndicator = UIPageControl()
        pageIndicator.pageIndicatorTintColor = UIColor.gray
        pageIndicator.currentPageIndicatorTintColor = UIColor.accentColor
        return pageIndicator
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.likeDisable, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(tapOnLikeButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var shareInternalButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.shareInternal, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(tapOnShareInternalButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var folowButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.productFolowDisable, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(tapOnFolowButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var getLinkButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.getLinkDisable, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(tapOnGetLink), for: .touchUpInside)
        return button
    }()
    
    fileprivate var productNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.title.rawValue)
        label.numberOfLines = 0
        label.text = "Bình Giữ Nhiệt Lock&Lock Colorful Tumbler LHC32222BLU (390ml) Ruột Bằng Thép Không Gỉ Inox304 - Màu Xanh"
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
    
    // MARK: - LifeCycles
    
    override func initialize() {
        layoutImagesCollectionView()
        layoutPageIndicator()
        layoutLikeButton()
        layoutShareInternalButton()
        layoutFolowButton()
        layoutGetLinkButton()
        layoutProductNameLabel()
        layoutRatingView()
        layoutNumberRatingLabel()
        layoutFinalPriceLabel()
        layoutOriginalPriceLabel()
        layoutDiscountPercentLabel()
    }
    
    // MARK: - Public Method
    
    static func estimateHeight(_ product: Product) -> CGFloat {
        let nameHeight = product.name.height(
            withConstrainedWidth: ScreenSize.SCREEN_WIDTH - 2 * Dimension.shared.mediumMargin,
            font: UIFont.systemFont(ofSize: FontSize.title.rawValue))
        
        return ScreenSize.SCREEN_WIDTH + nameHeight + 110
    }
    
    func configData(_ product: Product) {
        self.product = product
        imagesCollectionView.reloadData()
        pageIndicator.numberOfPages = product.photos.count
        
        let likeImage = product.userLike ? ImageManager.likeEnable : ImageManager.likeDisable
        likeButton.setImage(likeImage, for: .normal)
        let folowImage = product.userFollow ? ImageManager.productFolowEnable : ImageManager.productFolowDisable
        folowButton.setImage(folowImage, for: .normal)
        
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
    
    // MARK: - UI Actions
    
    @objc fileprivate func tapOnLikeButton() {
        delegate?.didSelectLike()
    }
    
    @objc fileprivate func tapOnShareInternalButton() {
        delegate?.didSelectShareInternal()
    }
    
    @objc fileprivate func tapOnFolowButton() {
        delegate?.didSelectFolow()
    }
    
    @objc fileprivate func tapOnGetLink() {
        delegate?.didSelectGetLink()
    }

    // MARK: - Layouts
    
    private func layoutImagesCollectionView() {
        addSubview(imagesCollectionView)
        imagesCollectionView.snp.makeConstraints { (make) in
            make.width.centerX.top.equalToSuperview()
            make.height.equalTo(ScreenSize.SCREEN_WIDTH)
        }
    }
    
    private func layoutPageIndicator() {
        addSubview(pageIndicator)
        pageIndicator.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(16)
            make.width.equalTo(100)
            make.bottom.equalTo(imagesCollectionView)
        }
    }
    
    private func layoutLikeButton() {
        addSubview(likeButton)
        likeButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(40)
            make.bottom.equalTo(imagesCollectionView).offset(-Dimension.shared.normalMargin)
            make.right.equalToSuperview().offset(-Dimension.shared.normalMargin)
        }
    }
    
    private func layoutShareInternalButton() {
        addSubview(shareInternalButton)
        shareInternalButton.snp.makeConstraints { (make) in
            make.width.height.bottom.equalTo(likeButton)
            make.right.equalTo(likeButton.snp.left).offset(-8)
        }
    }
    
    private func layoutFolowButton() {
        addSubview(folowButton)
        folowButton.snp.makeConstraints { (make) in
            make.width.height.bottom.equalTo(likeButton)
            make.right.equalTo(shareInternalButton.snp.left).offset(-8)
        }
    }
    
    private func layoutGetLinkButton() {
        addSubview(getLinkButton)
        getLinkButton.snp.makeConstraints { (make) in
            make.width.height.bottom.equalTo(likeButton)
            make.right.equalTo(folowButton.snp.left).offset(-8)
        }
    }
    
    private func layoutProductNameLabel() {
        addSubview(productNameLabel)
        productNameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Dimension.shared.mediumMargin)
            make.right.equalToSuperview().offset(-Dimension.shared.mediumMargin)
            make.top.equalTo(imagesCollectionView.snp.bottom).offset(Dimension.shared.normalMargin)
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
    
}

// MARK: - UICollectionViewDelegate

extension ProductDetailInfoCollectionViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageURLs = product.photos.map { $0.url }
        AppRouter.presentPopupImage(urls: imageURLs, selectedIndexPath: indexPath, productName: "")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x / imagesCollectionView.frame.width)
        pageIndicator.currentPage = currentPage
    }
}

// MARK: - UICollectionViewDataSource

extension ProductDetailInfoCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return product.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ImageCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.setupData(product.photos[indexPath.row])
        cell.imageContentMode = .scaleAspectFill
        return cell
    }
}
