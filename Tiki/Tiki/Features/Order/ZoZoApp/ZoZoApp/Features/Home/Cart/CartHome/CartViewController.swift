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
    
    fileprivate lazy var cartCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.tableBackground
        collectionView.showsVerticalScrollIndicator = false
        collectionView.registerReusableCell(CartCollectionViewCell.self)
        collectionView.registerReusableSupplementaryView(CartCollectionHeaderView.self,     forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        collectionView.registerReusableSupplementaryView(CartCollectionFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter)
        return collectionView
    }()
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = TextManager.cart.localized()
        emptyView.backgroundColor = UIColor.clear
        emptyView.message = TextManager.emptyCart.localized()
        layoutCartCollectionView()
        addEmptyView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emptyView.isHidden = !CartManager.shared.cartShopInfos.isEmpty
        cartCollectionView.reloadData()
    }
    
    // MARK: - Setup Layouts
    
    private func layoutCartCollectionView() {
        view.addSubview(cartCollectionView)
        cartCollectionView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CartViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthItem = cartCollectionView.bounds.width
        return CGSize(width: widthItem, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
}

// MARK: - UICollectionViewDataSource

extension CartViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return CartManager.shared.cartShopInfos.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return CartManager.shared.cartShopInfos[section].products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CartCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.delegate = self
        if let cartShop = CartManager.shared.cartShopInfos[safe: indexPath.section],
            let product = cartShop.products[safe: indexPath.row] {
            cell.configData(product)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            let header: CartCollectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, for: indexPath)
            if let cartShop = CartManager.shared.cartShopInfos[safe: indexPath.section] {
                header.configData(cartShop)
            }
            return header
        } else if kind == UICollectionView.elementKindSectionFooter {
            let footer: CartCollectionFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, for: indexPath)
            footer.delegate = self
            if let cartShop = CartManager.shared.cartShopInfos[safe: indexPath.section] {
                footer.configData(cartShop)
            }
            return footer
        } else {
            return UICollectionReusableView()
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
    
    func didSelectEditProduct(product: Product) {
        let viewController = CartEditPropertyViewController()
        viewController.configData(product)
        viewController.delegate = self
        present(viewController, animated: true, completion: nil)
    }
}

// MARK: - CartCollectionFooterViewDelegate

extension CartViewController: CartCollectionFooterViewDelegate {
    func didSelectOrder(cartShopInfo: CartShopInfo) {
        OrderManager.shared.selectedCartShopInfo = cartShopInfo
        let viewController = DeliveryInfomationViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - CartEditPropertyViewControllerDelegate

extension CartViewController: CartEditPropertyViewControllerDelegate {
    func didSelectCofirmEditProperties(for product: Product, size: String?, color: String?) {
        if size != nil && size != "" {
            product.selectedSize = size
        }
        
        if color != nil && color != "" {
            product.selectedColor = color
        }
        
        cartCollectionView.reloadData()
    }
}
