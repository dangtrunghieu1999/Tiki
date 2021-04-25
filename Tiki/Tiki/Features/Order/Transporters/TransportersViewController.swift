//
//  TransportersViewController.swift
//  ZoZoApp
//
//  Created by LAP12852 on 8/25/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class TransportersViewController: BaseViewController {
    
    // MARK: - Variables
    
    fileprivate var selectedTransporter: TransportersType?
    fileprivate var selectedPaymentMethod: PaymentMethodType?
    
    // MARK: - UI Elements
    
    fileprivate lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    private let selectTransportLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.selectTransporter.localized()
        label.font = UIFont.systemFont(ofSize: FontSize.body.rawValue)
        label.textColor = UIColor.bodyText
        label.textAlignment = .left
        return label
    }()
    
    fileprivate lazy var transporterTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 10
        tableView.isScrollEnabled = false
        tableView.registerReusableCell(TransporterTableViewCell.self)
        return tableView
    }()
    
    private let methodPaymentLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.paymentMethod.localized()
        label.font = UIFont.systemFont(ofSize: FontSize.body.rawValue)
        label.textColor = UIColor.bodyText
        label.textAlignment = .left
        return label
    }()
    
    fileprivate lazy var paymentMethodCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.lightBackground
        collectionView.layer.cornerRadius = 10
        collectionView.registerReusableCell(PaymentMethodCollectionViewCell.self)
        return collectionView
    }()
    
    fileprivate lazy var nextButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.accentColor
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = Dimension.shared.defaultHeightButton / 2
        button.layer.masksToBounds = true
        button.setTitle(TextManager.next.localized(), for: .normal)
        button.isUserInteractionEnabled = false
        button.backgroundColor = UIColor.disable
        button.addTarget(self, action: #selector(touchInNextButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = TextManager.selectTransporter.localized()
        layoutScrollView()
        layoutContainerView()
        layoutSelectTransportLabel()
        layoutTransportTableView()
        layoutMethodPaymentLabel()
        layoutPaymentCollectionView()
        layoutNextButton()
    }
    
    // MARK: - Public Methods
    
    // MARK: - UI Actions
    
    @objc private func touchInNextButton() {
        OrderManager.shared.paymentMethod = selectedPaymentMethod ?? .cash
        OrderManager.shared.transporterType = selectedTransporter ?? .giaoHangTietKiem
        let viewController = OrderInformationViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    // MARK: - Helper Methods
    
    fileprivate func checkEnableNextButton() {
        if selectedPaymentMethod != nil && selectedTransporter != nil {
            nextButton.isUserInteractionEnabled = true
            nextButton.backgroundColor = UIColor.accentColor
        } else {
            nextButton.isUserInteractionEnabled = false
            nextButton.backgroundColor = UIColor.disable
        }
    }
    
    // MARK: - Layout
    
    private func layoutContainerView() {
        scrollView.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.width.equalTo(view)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-Dimension.shared.normalMargin)
        }
    }
    
    private func layoutSelectTransportLabel() {
        containerView.addSubview(selectTransportLabel)
        selectTransportLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Dimension.shared.largeMargin)
            make.left.equalToSuperview().offset(Dimension.shared.largeMargin)
        }
    }
    
    private func layoutTransportTableView() {
        containerView.addSubview(transporterTableView)
        transporterTableView.snp.makeConstraints { (make) in
            make.top.equalTo(selectTransportLabel.snp.bottom).offset(Dimension.shared.normalMargin)
            make.left.equalToSuperview().offset(Dimension.shared.normalMargin)
            make.right.equalToSuperview().offset(-Dimension.shared.normalMargin)
            make.height.equalTo(150)
        }
    }
    
    private func layoutMethodPaymentLabel() {
        containerView.addSubview(methodPaymentLabel)
        methodPaymentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(transporterTableView.snp.bottom).offset(Dimension.shared.normalMargin)
            make.left.equalTo(selectTransportLabel)
        }
    }
    
    private func layoutPaymentCollectionView() {
        containerView.addSubview(paymentMethodCollectionView)
        paymentMethodCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(methodPaymentLabel.snp.bottom).offset(Dimension.shared.normalMargin)
            make.left.right.equalTo(transporterTableView)
            make.height.equalTo(100)
            make.bottom.equalToSuperview().offset(-Dimension.shared.largeMargin_120)
        }
    }
    
    private func layoutNextButton() {
        containerView.addSubview(nextButton)
        nextButton.snp.makeConstraints { (make) in
            make.width.equalTo(Dimension.shared.mediumWidthButton)
            make.height.equalTo(Dimension.shared.defaultHeightButton)
            make.centerX.equalToSuperview()
            make.top.equalTo(paymentMethodCollectionView.snp.bottom)
                .offset(Dimension.shared.largeMargin_56)
        }
    }
    
}

// MARK: - UITableViewDelegate

extension TransportersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTransporter = TransportersType(rawValue: indexPath.row)
        checkEnableNextButton()
        transporterTableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension TransportersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TransporterTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.backgroundColor = UIColor.lightBackground
        if let transportersType = TransportersType(rawValue: indexPath.row) {
            cell.configData(transportersType)
        }
        
        cell.isSelected = (selectedTransporter == TransportersType(rawValue: indexPath.row))
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension TransportersViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedPaymentMethod = PaymentMethodType(rawValue: indexPath.row)
        checkEnableNextButton()
        paymentMethodCollectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TransportersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
}

// MARK: - UICollectionViewDataSource

extension TransportersViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PaymentMethodCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        
        if let paymentMethodType = PaymentMethodType(rawValue: indexPath.row) {
            cell.configData(paymentMethodType)
        }
        
        cell.isSelected = (selectedPaymentMethod == PaymentMethodType(rawValue: indexPath.row))
        
        return cell
    }
}
