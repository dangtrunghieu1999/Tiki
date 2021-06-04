//
//  OrderBuyInfoView.swift
//  Tiki
//
//  Created by Bee_MacPro on 04/06/2021.
//

import UIKit

protocol OrderBuyInfoViewDelegate: class {
    func didSelectOrder()
}

class OrderBuyInfoView: BaseView {

    fileprivate lazy var intoMoneyTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = TextManager.totalMoney
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        return label
    }()
    
    fileprivate lazy var totalMoneyTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = CartManager.shared.totalMoney.currencyFormat
        label.font = UIFont.systemFont(ofSize: FontSize.body.rawValue)
        label.textColor = UIColor.primary
        return label
    }()
    
    private lazy var buyButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.processOrder, for: .normal)
        button.backgroundColor = UIColor.primary
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Dimension.shared.cornerRadiusSmall
        button.addTarget(self, action: #selector(tapOnBuyButton), for: .touchUpInside)
        return button
    }()
    
    override func initialize() {
        super.initialize()
        layoutBuyButton()
        layoutIntoMoneyTitleLabel()
        layoutTotalMoneyTitleLabel()
    }
    
    @objc private func tapOnBuyButton() {
        
    }
    
    func updateTotalMoney(_ money: String) {
        self.totalMoneyTitleLabel.text = money
    }
    
    private func layoutBuyButton() {
        addSubview(buyButton)
        buyButton.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
                .inset(dimension.normalMargin)
            make.height.equalTo(dimension.defaultHeightButton)
            make.bottom.equalToSuperview()
                .offset(-dimension.mediumMargin)
        }
    }
    
    private func layoutIntoMoneyTitleLabel() {
        addSubview(intoMoneyTitleLabel)
        intoMoneyTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(buyButton)
            make.top.equalToSuperview()
                .offset(dimension.normalMargin)
        }
    }
    
    private func layoutTotalMoneyTitleLabel() {
        addSubview(totalMoneyTitleLabel)
        totalMoneyTitleLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(buyButton.snp.top)
                .offset(-dimension.normalMargin)
            make.right.equalTo(buyButton)
        }
    }
    
}
