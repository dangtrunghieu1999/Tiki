//
//  OrderConfirmCollectionViewCell.swift
//  Tiki
//
//  Created by Bee_MacPro on 16/06/2021.
//

import UIKit

class OrderConfirmCollectionViewCell: BaseCollectionViewCell {
    
    var products: [Product] = []
    
    private let infoOrderLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.orderInfomation.localized()
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue,
                                       weight: .bold)
        label.textColor = UIColor.bodyText
        label.textAlignment = .left
        return label
    }()
    
    fileprivate lazy var mainView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.separator.cgColor
        view.layer.cornerRadius = dimension.cornerRadiusSmall
        return view
    }()
    
    fileprivate lazy var intendTimeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .greenColor
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        label.text = "Giao vào Thứ Ba, 08/06"
        return label
    }()
    
    fileprivate lazy var paymentFormTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .bold)
        label.text = TextManager.paymentForm
        return label
    }()
    
    fileprivate lazy var paymentTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        label.text = PaymentMethodType.momo.name
        return label
    }()
    
    fileprivate lazy var transportFormTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .bold)
        label.text = TextManager.transportForm
        return label
    }()
    
    private let logoTransportImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = ImageManager.logoGHTK
        return imageView
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.separator
        return view
    }()
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = false
        tableView.isUserInteractionEnabled = false
        tableView.dataSource = self
        tableView.delegate   = self
        tableView.registerReusableCell(OrderProductTableViewCell.self)
        return tableView
    }()
    
    override func initialize() {
        super.initialize()
        layoutInfoOrderLabel()
        layoutMainView()
        layoutIntendTimeLabel()
        layoutPaymentFormTitleLabel()
        layoutPaymentTitleLabel()
        layoutTransportFormTitleLabel()
        layoutLogoTransportImageView()
        layoutLineView()
        layoutTableView()
    }
    
    private func layoutInfoOrderLabel() {
        addSubview(infoOrderLabel)
        infoOrderLabel.snp.makeConstraints { (make) in
            make.top
                .equalToSuperview()
                .offset(dimension.normalMargin)
            make.left
                .equalToSuperview()
                .offset(dimension.normalMargin)
        }
    }
    
    private func layoutMainView() {
        addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.top
                .equalTo(infoOrderLabel.snp.bottom)
                .offset(dimension.normalMargin)
            make.left
                .right
                .equalToSuperview()
                .inset(dimension.normalMargin)
            make.bottom
                .equalToSuperview()
                .inset(dimension.normalMargin)
        }
    }
    
    private func layoutIntendTimeLabel() {
        mainView.addSubview(intendTimeLabel)
        intendTimeLabel.snp.makeConstraints { (make) in
            make.left
                .equalToSuperview()
                .offset(dimension.normalMargin)
            make.top
                .equalToSuperview()
                .offset(dimension.normalMargin)
        }
    }
    
    private func layoutPaymentFormTitleLabel() {
        mainView.addSubview(paymentFormTitleLabel)
        paymentFormTitleLabel.snp.makeConstraints { (make) in
            make.left
                .equalTo(intendTimeLabel)
            make.top
                .equalTo(intendTimeLabel.snp.bottom)
                .offset(dimension.normalMargin)
        }
    }
    
    private func layoutPaymentTitleLabel() {
        mainView.addSubview(paymentTitleLabel)
        paymentTitleLabel.snp.makeConstraints { (make) in
            make.left
                .equalTo(intendTimeLabel)
            make.top
                .equalTo(paymentFormTitleLabel.snp.bottom)
                .offset(dimension.smallMargin)
        }
    }
    
    private func layoutTransportFormTitleLabel() {
        mainView.addSubview(transportFormTitleLabel)
        (transportFormTitleLabel).snp.makeConstraints { (make) in
            make.left
                .equalTo(intendTimeLabel)
            make.top
                .equalTo(paymentTitleLabel.snp.bottom)
                .offset(dimension.normalMargin)
        }
    }
    
    private func layoutLogoTransportImageView() {
        mainView.addSubview(logoTransportImageView)
        logoTransportImageView.snp.makeConstraints { (make) in
            make.left
                .equalTo(intendTimeLabel)
            make.top
                .equalTo(transportFormTitleLabel.snp.bottom)
                .offset(dimension.smallMargin)
            make.height.equalTo(50)
            make.width.equalTo(200)
        }
    }
    
    private func layoutLineView() {
        mainView.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left
                .right
                .equalToSuperview()
                .inset(dimension.normalMargin)
            make.height.equalTo(1)
            make.top
                .equalTo(logoTransportImageView.snp.bottom)
                .offset(dimension.normalMargin)
        }
    }
    
    private func layoutTableView() {
        mainView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top
                .equalTo(lineView.snp.bottom)
                .offset(dimension.normalMargin)
            make.left.right
                .equalToSuperview()
                .inset(dimension.normalMargin)
            make.bottom
                .equalToSuperview()
                .inset(dimension.largeMargin)
        }
    }
}


// MARK: - UITableViewDataSource

extension OrderConfirmCollectionViewCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: OrderProductTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        
        if let product = products[safe: indexPath.row] {
            cell.configData(product: product)
        }

        return cell
    }
}

extension OrderConfirmCollectionViewCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
