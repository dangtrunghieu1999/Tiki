//
//  CartCollectionReusableFooterView.swift
//  ZoZoApp
//
//  Created by Dang Trung Hieu on 8/17/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

protocol CartCollectionFooterViewDelegate: class {
    func didSelectOrder(cartShopInfo: CartShopInfo)
}

class CartCollectionFooterView: BaseCollectionViewHeaderFooterCell {
    
    weak var delegate: CartCollectionFooterViewDelegate?
    
    private var cartShopInfo = CartShopInfo()
    
    // MARK: - UI Elements
    
    private lazy var orderButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.accentColor
        button.setTitle(TextManager.orderNow.localized(), for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 15
        button.titleLabel?.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        button.addTarget(self, action: #selector(touchInOrderButton), for: .touchUpInside)
        return button
    }()
    
    private var titleTotalMoneyLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.totalMoney.localized()
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .medium)
        return label
    }()
    
    private var moneyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        label.textColor = UIColor.bodyText
        return label
    }()
    
    // MARK: - View LifeCycles

    override func initialize() {
        super.initialize()
        
        backgroundColor = UIColor.lightBackground
        layoutOrderButton()
        layoutTitleTotalMoneyLabel()
        layoutMoneyLabel()
        
    }
    
    //MARK: - Public methods
    
    func configData(_ cartShopInfo: CartShopInfo) {
        self.cartShopInfo = cartShopInfo
        moneyLabel.text = cartShopInfo.totalMoney.currencyFormat
    }
    
    // MARK: - UI Actions
    
    @objc private func touchInOrderButton() {
        delegate?.didSelectOrder(cartShopInfo: cartShopInfo)
    }
    
    // MARK: - Setup Layouts
    
    private func layoutOrderButton() {
        addSubview(orderButton)
        orderButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-Dimension.shared.smallMargin)
            make.height.equalTo(30)
            make.width.equalTo(120)
        }
    }
    private func layoutTitleTotalMoneyLabel() {
        addSubview(titleTotalMoneyLabel)
        titleTotalMoneyLabel.snp.makeConstraints { (make) in
           make.left.equalToSuperview().offset(Dimension.shared.smallMargin)
           make.centerY.equalToSuperview()
           make.width.equalTo(80)
        }
    }
    
    private func layoutMoneyLabel() {
        addSubview(moneyLabel)
        moneyLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleTotalMoneyLabel.snp.right).offset(Dimension.shared.mediumMargin)
            make.right.equalTo(orderButton.snp.left).offset(-Dimension.shared.mediumMargin)
            make.centerY.equalTo(titleTotalMoneyLabel)
        }
    }

}

