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

        return view
    }()
    
    fileprivate lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = dimension.cornerRadiusSmall
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
    
    fileprivate lazy var productQuantityLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.textAlignment = .center
        label.leftInset = 10
        label.rightInset = 10
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue,
                                       weight: .medium)
        return label
    }()
    
    fileprivate lazy var productPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .semibold)
        label.textColor = UIColor.bodyText
        return label
    }()
    
    override func initialize() {
        super.initialize()
        layoutProductImageView()
        layoutProductNameLabel()
        layoutProductQuantityLabel()
    }
    
    func configData(product: Product) {
        self.productImageView.loadImage(by: product.defaultImage)
        self.productNameLabel.text = product.name
        self.productQuantityLabel.text = "SL:x \(product.quantity)"
    }
    
    private func layoutProductImageView() {
        addSubview(productImageView)
        productImageView.snp.makeConstraints { (make) in
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
    
    private func layoutProductNameLabel() {
        addSubview(productNameLabel)
        productNameLabel.snp.makeConstraints { (make) in
            make.left
                .equalTo(productImageView.snp.right)
                .offset(dimension.mediumMargin)
            make.right
                .equalToSuperview()
                .offset(dimension.normalMargin)
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
    
}
