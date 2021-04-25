//
//  OrderInformationViewController.swift
//  ZoZoApp
//
//  Created by LAP12852 on 8/25/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class OrderInformationViewController: BaseViewController {
    
    // MARK: - Variables
    
    fileprivate var rootVC = TKTabBarViewController()
    
    // MARK: - UI Elements
    
    fileprivate lazy var orderCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.tableBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerReusableCell(CartCollectionViewCell.self)
        collectionView.registerReusableCell(OrderInfomationCollectionViewCell.self)
        collectionView.registerReusableSupplementaryView(CartCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        return collectionView
    }()
    
    private lazy var orderNowButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.accentColor
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 3
        button.layer.masksToBounds = true
        button.setTitle(TextManager.orderNow.localized(), for: .normal)
        button.addTarget(self, action: #selector(tapOnOrderNow), for: .touchUpInside)
        return button
    }()
    
    // MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = TextManager.orderInfomation.localized()
        layoutOrderCollectionView()
        layoutOrderNowButton()
        getShipingFee()
    }
    
    // MARK: - UI Actions
    
    @objc private func tapOnOrderNow() {
        OrderManager.shared.submitOrder(completion: {
            
            guard OrderManager.shared.orderCode != nil else {
                AlertManager.shared.showDefaultError()
                return
            }
            
            switch OrderManager.shared.paymentMethod {
            case .cash:
                self.processOrderSuccess()
                break
                
            case .VTCPay:
                AlertManager.shared.show(TextManager.alertTitle.localized(), message: TextManager.VTCPayPaymentGuideMessage.localized(), acceptMessage: "OK", acceptBlock: {
                    self.goToVTCPay()
                })
                break
            }
        }) {
            AlertManager.shared.showDefaultError()
        }
    }
    
    // MARK: - APIs Request
    
    fileprivate func getShipingFee() {
        showLoading()
        OrderManager.shared.getAPIShippingFee(completion: { [weak self] in
            guard let self = self else { return }
            self.orderCollectionView.reloadData()
            self.hideLoading()
        }) { [weak self] in
            self?.hideLoading()
            AlertManager.shared.showDefaultError()
        }
    }
    
    // MARK: - Helper Methods
    
    fileprivate func goToVTCPay() {
      
    }
    
    fileprivate func processOrderSuccess() {
        AlertManager.shared.show(TextManager.alertTitle.localized(), message: TextManager.orderSuccess.localized(), acceptMessage: "OK", acceptBlock: {
            if let cartShopInfo = OrderManager.shared.selectedCartShopInfo {
                CartManager.shared.removeCartShopInfo(cartShopInfo)
            }
            self.navigationController?.popToRootViewController(animated: true)
        })
    }
    
    // MARK: - Layout
    private func layoutOrderCollectionView() {
        view.addSubview(orderCollectionView)
        orderCollectionView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-Dimension.shared.largeMargin_60)
        }
    }
    
    private func layoutOrderNowButton() {
        view.addSubview(orderNowButton)
        orderNowButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-Dimension.shared.mediumMargin)
            make.width.equalToSuperview().offset(-10)
            make.height.equalTo(Dimension.shared.defaultHeightButton)
            make.centerX.equalToSuperview()
        }
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension OrderInformationViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let widthSection = orderCollectionView.frame.width
        if indexPath.section == 0 {
            return CGSize(width: widthSection, height: 150)
        }
        else {
            return CGSize(width: widthSection - 2 * Dimension.shared.mediumMargin, height: 200)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if section == 0 {
            return CGSize(width: collectionView.frame.width, height: 50)
        }
        else {
            return .zero
        }
    }
}

// MARK: - UICollectionViewDataSource

extension OrderInformationViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return OrderManager.shared.selectedCartShopInfo?.products.count ?? 1
        }
        else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell: CartCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            if let cartShop = CartManager.shared.cartShopInfos[safe: indexPath.section],
                let product = cartShop.products[safe: indexPath.row] {
                cell.configData(product)
            }
            cell.setupLayoutForCartButton()
            return cell
        }
        else {
            let cell: OrderInfomationCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.setupData()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header: CartCollectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, for: indexPath)
        if let cartShop = CartManager.shared.cartShopInfos[safe: indexPath.section] {
            header.configData(cartShop)
        }
        return header
    }
}

// MARK: - VTCPaySDKWapManagerPaymentDelegate


