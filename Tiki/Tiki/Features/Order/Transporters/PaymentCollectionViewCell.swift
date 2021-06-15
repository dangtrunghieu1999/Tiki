//
//  PaymentMethodCollectionViewCell.swift
//  ZoZoApp
//
//  Created by Dang Trung Hieu on 8/25/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class PaymentCollectionViewCell: BaseCollectionViewCell {
    
    fileprivate var selectedPayment: PaymentMethodType?
    
    private let selectPaymentLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.paymentMethod.localized()
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue,
                                       weight: .bold)
        label.textColor = UIColor.bodyText
        label.textAlignment = .left
        return label
    }()
    
    fileprivate lazy var paymentTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.layer.masksToBounds = true
        tableView.registerReusableCell(MethodTableViewCell.self)
        return tableView
    }()

    // MARK: - View LifeCycles
    
    override func initialize() {
        super.initialize()
        layoutSelectPaymentLabel()
        layoutTableView()
    }
    
    
    private func layoutSelectPaymentLabel() {
        addSubview(selectPaymentLabel)
        selectPaymentLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
                .offset(dimension.normalMargin)
            make.left.equalToSuperview()
                .offset(dimension.normalMargin)
        }
    }
    
    private func layoutTableView() {
        addSubview(paymentTableView)
        paymentTableView.snp.makeConstraints { (make) in
            make.top.equalTo(selectPaymentLabel.snp.bottom)
            make.left.right.equalToSuperview()
                .inset(dimension.normalMargin)
            make.height.equalTo(150)
        }
    }
}

extension PaymentCollectionViewCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MethodTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        if let paymentType = PaymentMethodType(rawValue: indexPath.row) {
            cell.configData(paymentType)
        }
        cell.isSelected = (selectedPayment == PaymentMethodType(rawValue: indexPath.row))
        cell.backgroundColor = UIColor.white
        return cell
    }
}

extension PaymentCollectionViewCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPayment = PaymentMethodType(rawValue: indexPath.row)
        paymentTableView.reloadData()
    }
}
