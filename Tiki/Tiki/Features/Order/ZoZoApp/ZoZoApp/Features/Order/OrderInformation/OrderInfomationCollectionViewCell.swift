//
//  OrderInfomationCollectionViewCell.swift
//  ZoZoApp
//
//  Created by Dang Trung Hieu on 8/26/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class OrderInfomationCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - UI Elements
    
    fileprivate lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.addShadow()
        view.layer.cornerRadius = 10
        return view
    }()
    
    fileprivate lazy var expectDeliveryLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.expectDelivery.localized()
        label.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        label.textColor = UIColor.titleText
        return label
    }()
    
    fileprivate lazy var dateReceiptLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        label.textColor = UIColor.titleText
        label.numberOfLines = 0
        return label
    }()
    
    fileprivate lazy var shippingFeeLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.shippingFee.localized()
        label.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        label.textColor = UIColor.titleText
        return label
    }()
    
    fileprivate lazy var moneyShipLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        label.textColor = UIColor.titleText
        return label
    }()
    
    fileprivate lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.separator
        return view
    }()
    
    fileprivate lazy var titleTotalMoneyLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.titleTotalMoney.localized()
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .medium)
        label.textColor = UIColor.titleText
        return label
    }()
    
    fileprivate lazy var totalMoneyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .medium)
        label.textColor = UIColor.titleText
        return label
    }()
    
    
    // MARK: - View LifeCycles
    
    override func initialize() {
        super.initialize()
        backgroundColor = UIColor.clear
        layoutContainerView()
        layoutExpectDeliveryLabel()
        layoutDateReceiptLabel()
        layoutShippingFeeLabel()
        layoutMoneyShipLabel()
        layoutLineView()
        layoutTitleTotalMoneyLabel()
        layoutTotalMoneyLabel()
        
        setupData()
    }
    
    // MARK: - Config data
    
    func setupData() {
        totalMoneyLabel.text    = OrderManager.shared.totalPaymentMoney.currencyFormat
        moneyShipLabel.text     = OrderManager.shared.shippingFeeInfo.fee.currencyFormat
        dateReceiptLabel.text   = OrderManager.shared.deliveryDate.pretyDesciption
    }
    
    // MARK: - Setup Layouts
    
    private func layoutContainerView() {
        addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Dimension.shared.largeMargin)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-Dimension.shared.largeMargin)
        }
    }
    
    private func layoutExpectDeliveryLabel() {
        containerView.addSubview(expectDeliveryLabel)
        expectDeliveryLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Dimension.shared.normalMargin)
            make.left.equalToSuperview().offset(Dimension.shared.mediumMargin)
        }
    }
    
    private func layoutDateReceiptLabel() {
        containerView.addSubview(dateReceiptLabel)
        dateReceiptLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(expectDeliveryLabel)
            make.left.equalTo(expectDeliveryLabel.snp.right).offset(Dimension.shared.smallMargin)
            make.right.equalToSuperview().offset(-Dimension.shared.smallMargin)
        }
    }
    
    private func layoutShippingFeeLabel() {
        containerView.addSubview(shippingFeeLabel)
        shippingFeeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(expectDeliveryLabel.snp.bottom).offset(Dimension.shared.normalMargin)
            make.left.equalTo(expectDeliveryLabel)
        }
    }
    
    private func layoutMoneyShipLabel() {
        containerView.addSubview(moneyShipLabel)
        moneyShipLabel.snp.makeConstraints { (make) in
            make.left.equalTo(shippingFeeLabel.snp.right).offset(Dimension.shared.largeMargin)
            make.centerY.equalTo(shippingFeeLabel)
        }
    }
    
    private func layoutLineView() {
        containerView.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(shippingFeeLabel.snp.bottom).offset(Dimension.shared.normalMargin)
            make.left.equalToSuperview().offset(Dimension.shared.normalMargin)
            make.right.equalToSuperview().offset(-Dimension.shared.normalMargin)
            make.height.equalTo(1)
        }
    }
    
    private func layoutTitleTotalMoneyLabel() {
        containerView.addSubview(titleTotalMoneyLabel)
        titleTotalMoneyLabel.snp.makeConstraints { (make) in
            make.top.equalTo(lineView.snp.bottom).offset(Dimension.shared.normalMargin)
            make.left.equalTo(shippingFeeLabel)
        }
    }
    
    private func layoutTotalMoneyLabel() {
        containerView.addSubview(totalMoneyLabel)
        totalMoneyLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-Dimension.shared.normalMargin)
            make.centerY.equalTo(titleTotalMoneyLabel)
        }
    }
    
}
