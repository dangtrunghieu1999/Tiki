//
//  CartViewController.swift
//  ZoZoApp
//
//  Created by MACOS on 6/8/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class CartViewController: BaseViewController {
    
    // MARK: - UI Elements
    
    fileprivate lazy var topView: BaseView = {
        let view = BaseView()
        return view
    }()
    
    fileprivate lazy var cartCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.tableBackground
        collectionView.showsVerticalScrollIndicator = false
        collectionView.registerReusableCell(CartCollectionViewCell.self)
        collectionView.registerReusableCell(EmptyCollectionViewCell.self)
        return collectionView
    }()
    
    fileprivate lazy var bottomView: BaseView = {
        let view = BaseView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.separator.cgColor
        view.layer.masksToBounds = true
        return view
    }()
    
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
        label.text = 479000.currencyFormat
        label.font = UIFont.systemFont(ofSize: FontSize.body.rawValue)
        label.textColor = UIColor.primary
        return label
    }()
    
    private lazy var buyButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.processOrder.localized(), for: .normal)
        button.backgroundColor = UIColor.primary
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(tapOnBuyButton), for: .touchUpInside)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Dimension.shared.cornerRadiusSmall
        button.addTarget(self, action: #selector(tapOnBuyButton), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = TextManager.cart.localized()
        layoutBottomView()
        layoutBuyButton()
        layoutIntoMoneyTitleLabel()
        layoutTotalMoneyTitleLabel()
        layoutCartCollectionView()
    }
    
    
    @objc private func tapOnBuyButton() {
        
    }
    
    
    // MARK: - Layouts
    
    private func layoutBottomView() {
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(100)
        }
    }
    
    private func layoutBuyButton() {
        bottomView.addSubview(buyButton)
        buyButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Dimension.shared.normalMargin)
            make.right.equalToSuperview().offset(-Dimension.shared.normalMargin)
            make.height.equalTo(Dimension.shared.defaultHeightButton)
            make.bottom.equalToSuperview().offset(-Dimension.shared.mediumMargin)
        }
    }
    
    private func layoutIntoMoneyTitleLabel() {
        bottomView.addSubview(intoMoneyTitleLabel)
        intoMoneyTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(buyButton)
            make.top.equalToSuperview().offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutTotalMoneyTitleLabel() {
        bottomView.addSubview(totalMoneyTitleLabel)
        totalMoneyTitleLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(buyButton.snp.top).offset(-Dimension.shared.normalMargin)
            make.right.equalTo(buyButton)
        }
    }
    
    private func layoutCartCollectionView() {
        view.addSubview(cartCollectionView)
        cartCollectionView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(bottomView.snp.top)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CartViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthItem = cartCollectionView.bounds.width
        return CGSize(width: widthItem, height: 200)
    }
}

// MARK: - UICollectionViewDataSource

extension CartViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if CartManager.shared.cartShopInfos.isEmpty {
            return 1
        } else {
            return CartManager.shared.cartShopInfos.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if CartManager.shared.cartShopInfos.isEmpty {
            return 1
        } else {
            return CartManager.shared.cartShopInfos[section].products.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if CartManager.shared.cartShopInfos.isEmpty {
            let cell: EmptyCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.message = TextManager.emptyCart
            cell.image = ImageManager.empty
            cartCollectionView.backgroundColor = UIColor.clear
            bottomView.isHidden = true
            return cell
        } else {
            let cell: CartCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            if let cartShop = CartManager.shared.cartShopInfos[safe: indexPath.row],
               let product = cartShop.products[safe: indexPath.row] {
                cell.configData(product)
                if let cartShop = CartManager.shared.cartShopInfos[safe: indexPath.row] {
                    cell.configData(cartShop)
                }
            }
            return cell
        }
    }
}

// MARK: - CartProductCellDelegate

extension CartViewController: CartProductCellDelegate {
    func didSelectShopAvatar(id: Int?) {
        guard let shopId = id else { return }
        AppRouter.pushToShopHome(shopId)
    }
    
    func didSelectIncreaseNumber(product: Product) {
        CartManager.shared.increaseProductQuantity(product, completionHandler: {
            self.cartCollectionView.reloadData()
            NotificationCenter.default.post(name: NSNotification.Name.reloadCartBadgeNumber,
                                            object: nil)
        }) {
            AlertManager.shared.showToast()
        }
    }
    
    func didSelectDecreaseNumber(product: Product) {
        guard product.quantity > 1 else {
            AlertManager.shared.showToast(message: TextManager.youCantDecreaseQuantity)
            return
        }
        
        CartManager.shared.decreaseProductQuantity(product, completionHandler: {
            self.cartCollectionView.reloadData()
            NotificationCenter.default.post(name: NSNotification.Name.reloadCartBadgeNumber,
                                            object: nil)
        }) {
            AlertManager.shared.showToast()
        }
    }
    
    func didSelectDeleteProduct(product: Product) {
        AlertManager.shared.showConfirmMessage(mesage: TextManager.deleteProduct) { (action) in
            CartManager.shared.deleteProduct(product, completionHandler: {
                self.cartCollectionView.reloadData()
                self.emptyView.isHidden = !CartManager.shared.cartShopInfos.isEmpty
                NotificationCenter.default.post(name: NSNotification.Name.reloadCartBadgeNumber,
                                                object: nil)
                AlertManager.shared.showToast(message: TextManager.deleteProductSuccess.localized())
            }) {
                AlertManager.shared.showToast()
            }
        }
    }
    
}

