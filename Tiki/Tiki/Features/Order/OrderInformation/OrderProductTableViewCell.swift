//
//  OrderProductTableViewCell.swift
//  Tiki
//
//  Created by Bee_MacPro on 05/06/2021.
//

import UIKit

class OrderProductTableViewCell: BaseTableViewCell {
    
    
    fileprivate lazy var coverViewImage: BaseView = {
        let view = BaseView()
        view.layer.cornerRadius = dimension.cornerRadiusSmall
        view.layer.borderWidth  = 1
        view.layer.borderColor  = UIColor.separator.cgColor
        view.layer.masksToBounds = true
        return view
    }()
    
    fileprivate lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    fileprivate lazy var productNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue,
                                       weight: .medium)
        label.textColor = UIColor.lightBodyText
        label.numberOfLines = 1
        return label
    }()
    
    fileprivate lazy var productQuantityLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue,
                                       weight: .medium)
        return label
    }()
    
    fileprivate lazy var productPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue,
                                       weight: .semibold)
        label.textColor = UIColor.bodyText
        return label
    }()
    
    override func initialize() {
        super.initialize()
        layoutCoverView()
        layoutProductImageView()
        layoutProductNameLabel()
        layoutProductQuantityLabel()
        layoutProductPriceLabel()
    }
    
    func configData(product: Product) {
        self.productImageView.loadImage(by: product.defaultImage)
        self.productNameLabel.text = product.name
        self.productQuantityLabel.text = "SL:x \(product.quantity)"
        self.productPriceLabel.text    = product.finalPrice.currencyFormat
    }
    
    private func layoutCoverView() {
        addSubview(coverViewImage)
        coverViewImage.snp.makeConstraints { (make) in
            make.centerY
                .equalToSuperview()
            make.height
                .equalTo(60)
            make.width
                .equalTo(60)
            make.left
                .equalToSuperview()
        }
    }
    
    private func layoutProductImageView() {
        coverViewImage.addSubview(productImageView)
        productImageView.snp.makeConstraints { (make) in
            make.width.height
                .equalTo(50)
            make.centerY
                .equalToSuperview()
            make.centerX
                .equalToSuperview()
        }
    }
    
    private func layoutProductNameLabel() {
        addSubview(productNameLabel)
        productNameLabel.snp.makeConstraints { (make) in
            make.left
                .equalTo(coverViewImage.snp.right)
                .offset(dimension.mediumMargin)
            make.right
                .equalToSuperview()
                .inset(dimension.normalMargin)
            make.top
                .equalTo(productImageView)
        }
    }
    
    private func layoutProductQuantityLabel() {
        addSubview(productQuantityLabel)
        productQuantityLabel.snp.makeConstraints { (make) in
            make.left
                .equalTo(productNameLabel)
            make.bottom
                .equalTo(productImageView)
        }
    }
    
    private func layoutProductPriceLabel() {
        addSubview(productPriceLabel)
        productPriceLabel.snp.makeConstraints { (make) in
            make.right
                .equalToSuperview()
                .inset(dimension.normalMargin)
            make.bottom
                .equalTo(productImageView)
        }
    }
    
}
