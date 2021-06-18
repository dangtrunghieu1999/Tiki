//
//  OrderStatusCollectionViewCell.swift
//  Tiki
//
//  Created by Bee_MacPro on 17/06/2021.
//

import UIKit

class OrderStatusCollectionViewCell: BaseCollectionViewCell {
    
    let widthButton = ( ScreenSize.SCREEN_WIDTH -
                            dimension.normalMargin * 2 -
                            dimension.mediumMargin ) / 2
    
    fileprivate lazy var statusTitleLabel: ShimmerLabel = {
        let label = ShimmerLabel()
        label.textColor = UIColor.lightBodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue,
                                       weight: .semibold)
        return label
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.separator
        return view
    }()
    
    fileprivate lazy var coverViewImage: BaseView = {
        let view = BaseView()
        view.layer.cornerRadius = dimension.cornerRadiusSmall
        view.layer.borderWidth  = 1
        view.layer.borderColor  = UIColor.separator.cgColor
        view.layer.masksToBounds = true
        return view
    }()
    
    fileprivate lazy var productImageView: ShimmerImageView = {
        let imageView = ShimmerImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius  = dimension.cornerRadiusSmall
        return imageView
    }()
    
    fileprivate var productNameLabel: ShimmerLabel = {
        let label = ShimmerLabel()
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue,
                                       weight: .semibold)
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()
    
    fileprivate var productPriceLabel: ShimmerLabel = {
        let label = ShimmerLabel()
        label.textColor = UIColor.lightBodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue,
                                       weight: .medium)
        return label
    }()
    
    private var firstShimmerView: BaseShimmerView = {
        let view = BaseShimmerView()
        view.isHidden = true
        return view
    }()
    
    private var secondShimmerView: BaseShimmerView = {
        let view = BaseShimmerView()
        view.isHidden = true
        return view
    }()
    
    private let firstButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.viewDetail, for: .normal)
        button.titleLabel?.font =
            UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.primary, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        button.isUserInteractionEnabled = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.primary.cgColor
        return button
    }()
    
    private let secondButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.orderAgain, for: .normal)
        button.titleLabel?.font =
            UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.primary, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        button.isUserInteractionEnabled = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.primary.cgColor
        return button
    }()
    
    override func initialize() {
        super.initialize()
        layoutStatusTitleLabel()
        layoutLineView()
        layoutCoverView()
        layoutProductImageView()
        layoutProductNameLabel()
        layoutProductPriceLabel()
        layoutFirstButton()
        layoutSecondButton()
        layoutFistShimmerView()
        layoutSecondShimmerView()
        startShimmering()
    }
    
    func configCell(order: Order) {
        self.productImageView.loadImage(by: order.image,
                                        defaultImage: ImageManager.avatarDefault)
        self.productNameLabel.text = order.name
        self.productPriceLabel.text = order.bill
        self.statusTitleLabel.text = order.status.name
    }
    
    func startShimmering() {
        self.statusTitleLabel.startShimmer()
        self.productImageView.startShimmer()
        self.productNameLabel.startShimmer()
        self.productPriceLabel.startShimmer()
        self.firstShimmerView.startShimmer()
        self.secondShimmerView.startShimmer()
        self.firstButton.isHidden       = true
        self.secondButton.isHidden      = true
        self.lineView.isHidden          = true
        self.firstShimmerView.isHidden  = false
        self.secondShimmerView.isHidden = false
    }
    
    func stopShimmering() {
        self.statusTitleLabel.stopShimmer()
        self.productImageView.stopShimmer()
        self.productNameLabel.stopShimmer()
        self.productPriceLabel.stopShimmer()
        self.firstShimmerView.stopShimmer()
        self.secondShimmerView.stopShimmer()
        self.firstButton.isHidden       = false
        self.secondButton.isHidden      = false
        self.lineView.isHidden          = false
        self.firstShimmerView.isHidden  = true
        self.secondShimmerView.isHidden = true
    }
    
    private func layoutStatusTitleLabel() {
        addSubview(statusTitleLabel)
        statusTitleLabel.snp.makeConstraints { (make) in
            make.left
                .equalToSuperview()
                .offset(dimension.normalMargin)
            make.top
                .equalToSuperview()
                .offset(dimension.mediumMargin)
        }
    }
    
    private func layoutLineView() {
        addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left
                .right
                .equalToSuperview()
                .inset(dimension.normalMargin)
            make.top
                .equalTo(statusTitleLabel.snp.bottom)
                .offset(dimension.mediumMargin)
            make.height
                .equalTo(1)
        }
    }
    
    private func layoutCoverView() {
        addSubview(coverViewImage)
        coverViewImage.snp.makeConstraints { (make) in
            make.left
                .equalTo(lineView)
            make.width
                .height
                .equalTo(80)
            make.top
                .equalTo(lineView.snp.bottom)
                .offset(dimension.mediumMargin)
        }
    }
    
    private func layoutProductImageView() {
        coverViewImage.addSubview(productImageView)
        productImageView.snp.makeConstraints { (make) in
            make.centerX
                .centerY
                .equalToSuperview()
            make.width
                .height
                .equalTo(60)
        }
    }
    
    private func layoutProductNameLabel() {
        addSubview(productNameLabel)
        productNameLabel.snp.makeConstraints { (make) in
            make.top
                .equalTo(productImageView)
                .offset(dimension.mediumMargin)
            make.left
                .equalTo(productImageView.snp.right)
                .offset(dimension.largeMargin)
            make.right
                .equalToSuperview()
                .inset(dimension.largeMargin)
        }
    }
    
    private func layoutProductPriceLabel() {
        addSubview(productPriceLabel)
        productPriceLabel.snp.makeConstraints { (make) in
            make.left
                .equalTo(productNameLabel)
            make.top
                .equalTo(productNameLabel.snp.bottom)
                .offset(dimension.mediumMargin)
            make.right
                .equalTo(productNameLabel)
        }
    }
    
    private func layoutFirstButton() {
        addSubview(firstButton)
        firstButton.snp.makeConstraints { (make) in
            make.top
                .equalTo(coverViewImage.snp.bottom)
                .offset(dimension.normalMargin)
            make.height
                .equalTo(40)
            make.left
                .equalTo(coverViewImage)
            make.width
                .equalTo(widthButton)
        }
    }
    
    private func layoutSecondButton() {
        addSubview(secondButton)
        secondButton.snp.makeConstraints { (make) in
            make.top
                .equalTo(firstButton)
            make.height
                .equalTo(firstButton)
            make.right
                .equalToSuperview()
                .inset(dimension.normalMargin)
            make.width
                .equalTo(widthButton)
        }
    }
    
    private func layoutFistShimmerView() {
        addSubview(firstShimmerView)
        firstShimmerView.snp.makeConstraints { (make) in
            make.top
                .equalTo(coverViewImage.snp.bottom)
                .offset(dimension.normalMargin)
            make.height
                .equalTo(40)
            make.left
                .equalTo(coverViewImage)
            make.width
                .equalTo(widthButton)
        }
    }
    
    private func layoutSecondShimmerView() {
        addSubview(secondShimmerView)
        secondShimmerView.snp.makeConstraints { (make) in
            make.top
                .equalTo(firstButton)
            make.height
                .equalTo(firstButton)
            make.right
                .equalToSuperview()
                .inset(dimension.normalMargin)
            make.width
                .equalTo(widthButton)
        }
    }
}
