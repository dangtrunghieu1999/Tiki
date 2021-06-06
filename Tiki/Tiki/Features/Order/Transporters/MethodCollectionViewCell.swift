//
//  MethodCollectionViewCell.swift
//  Tiki
//
//  Created by Bee_MacPro on 06/06/2021.
//

import UIKit

class MethodCollectionViewCell: BaseCollectionViewCell {
    fileprivate var selectedPayment: PaymentMethodType?
    
    private let selectPaymentLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.selctedMethod.localized()
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue,
                                       weight: .bold)
        label.textColor = UIColor.bodyText
        label.textAlignment = .left
        return label
    }()
    
    fileprivate lazy var methodTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.layer.masksToBounds = true
        tableView.registerReusableCell(MethodTableViewCell.self)
        return tableView
    }()
    
    override func initialize() {
        super.initialize()
        layoutSelectPaymentLabel()
        layoutMethodTableView()
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
    
    
    private func layoutMethodTableView() {
        addSubview(methodTableView)
        methodTableView.snp.makeConstraints { (make) in
            make.top.equalTo(selectPaymentLabel.snp.bottom)
                .offset(dimension.normalMargin)
            make.left.right.equalToSuperview()
                .inset(dimension.normalMargin)
            make.height.equalTo(150)
        }
    }
}

extension MethodCollectionViewCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPayment = PaymentMethodType(rawValue: indexPath.row)
        methodTableView.reloadData()
    }
}

extension MethodCollectionViewCell: UITableViewDataSource {
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
