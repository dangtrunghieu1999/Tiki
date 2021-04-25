//
//  ShopInfoListProductViewController.swift
//  ZoZoApp
//
//  Created by MACOS on 6/29/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class ShopHomeListProductViewController: BaseViewController {
    
    // MARK: - Helper Type
    
    fileprivate enum SectionType: Int {
        case header     = 0
        case products   = 1
    }
    
    // MARK: - Variables
    
    var shop                                    = Shop()
    fileprivate var products: [Product]         = []
    fileprivate var cachedProducts: [Product]   = []
    private var currentPage                     = 1
    private let numberProductPerPage            = AppConfig.defaultProductPerPage
    fileprivate var isLoadMore                  = false
    fileprivate var canLoadMore                 = true
    
    // MARK: - UI Elements
    
    fileprivate lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.background
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    fileprivate lazy var listProductCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = BaseProductView.itemSpacing
        layout.minimumInteritemSpacing = BaseProductView.itemSpacing
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.lightBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView.refreshControl = refreshControl
        collectionView.registerReusableCell(EmptyCollectionViewCell.self)
        collectionView.registerReusableCell(ProductCollectionViewCell.self)
        
        collectionView.registerReusableSupplementaryView(
            ShopHomeProductListSearchHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        
        collectionView.registerReusableSupplementaryView(
            LoadMoreCollectionViewCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter)
        
        return collectionView
    }()
    
    // MARK: - LifeCycles
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.lightBackground
        layoutListProductCollectionView()
        
        requestAPIProducts()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = true
    }
    
    // MARK: - UI Actions
    
    @objc private func pullToRefresh() {
        currentPage = 1
        canLoadMore = true
        requestAPIProducts()
    }
    
    // MARK: - API Helper
    
    func requestAPIProducts() {
        let params: [String: Any] = ["shopId": shop.id ?? 0,
                                     "pageSize": numberProductPerPage,
                                     "pageNumber": currentPage]
        let endPoint = ProductEndPoint.getAllProductByShopId(parameters: params)
        if !isLoadMore {
            isRequestingAPI = true
        }
        
        APIService.request(endPoint: endPoint, onSuccess: { [weak self] (apiResponse) in
            guard let self = self else { return }
            let productsResponse = apiResponse.toArray([Product.self])
            
            if self.isLoadMore {
                self.cachedProducts.append(contentsOf: productsResponse)
            } else {
                self.cachedProducts = productsResponse
            }
            
            if self.canLoadMore {
                self.canLoadMore = !productsResponse.isEmpty
            }
            
            self.isRequestingAPI = false
            
            if self.isLoadMore {
                self.isLoadMore = false
                var reloadIndexPaths: [IndexPath] = []
                let numberProducts = self.products.count;
                
                for index in 0..<productsResponse.count {
                    reloadIndexPaths.append(IndexPath(item: numberProducts + index, section: SectionType.products.rawValue))
                }
                
                self.products = self.cachedProducts
                self.listProductCollectionView.insertItems(at: reloadIndexPaths)
            } else {
                self.products = self.cachedProducts
                self.listProductCollectionView.reloadData()
            }
            
            self.refreshControl.endRefreshing()
            
            if self.products.count < 3 {
                self.listProductCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
            }
            
        }, onFailure: { [weak self] (apiError) in
            guard let self = self else { return }
            self.isRequestingAPI = false
            self.isLoadMore = false
            self.canLoadMore = true
            self.listProductCollectionView.reloadData()
            self.refreshControl.endRefreshing()
            AlertManager.shared.showToast()
            
        }) { [weak self] in
            guard let self = self else { return }
            self.isRequestingAPI = false
            self.isLoadMore = false
            self.canLoadMore = true
            self.listProductCollectionView.reloadData()
            self.refreshControl.endRefreshing()
            AlertManager.shared.showToast()
        }
    }
    
    // MARK: - Layouts
    
    private func layoutListProductCollectionView() {
        view.addSubview(listProductCollectionView)
        listProductCollectionView.snp.makeConstraints { (make) in
            make.height.centerX.centerY.equalToSuperview()
            make.width.equalToSuperview().offset(-10)
        }
    }
    
}

// MARK: - UICollectionViewDataSource

extension ShopHomeListProductViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == SectionType.header.rawValue {
            return 0
        } else {
            if isRequestingAPI {
                return 6
            } else if products.isEmpty {
                return 1
            } else {
                return products.count
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == SectionType.header.rawValue {
            return UICollectionViewCell()
        }
        
        if products.isEmpty && !isRequestingAPI {
            let cell: EmptyCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.message = TextManager.emptyProducts.localized()
            return cell
        } else {
            let cell: ProductCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            
            let isOwner = (shop.isOwner || ShopRoleManager.shared.isShopAdmin) ? true : false
            
            if let product = products[safe: indexPath.row] {
                cell.configData(product, isOwner: isOwner)
            }
            if !isRequestingAPI {
                cell.stopShimmer()
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader
            && indexPath.section == SectionType.header.rawValue {
            let header: ShopHomeProductListSearchHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)
            header.delegate = self
            
            let isOwner = (shop.isOwner || ShopRoleManager.shared.isShopAdmin) ? true : false
            header.configLayout(isOwnerShop: isOwner)
            return header
            
        } else if kind == UICollectionView.elementKindSectionFooter
            && indexPath.section == SectionType.products.rawValue {
            let footer: LoadMoreCollectionViewCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)
            footer.animiate(isLoadMore)
            return footer
        } else {
            return UICollectionReusableView()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ShopHomeListProductViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == SectionType.products.rawValue && products.isEmpty && !isRequestingAPI {
            return CGSize(width: collectionView.frame.width, height: 300)
        } else if indexPath.section == SectionType.products.rawValue {
            if (shop.isOwner || ShopRoleManager.shared.isShopAdmin) {
                return BaseProductView.shopOwnerSize
            } else {
                return BaseProductView.guestUserSize
            }
            
        } else {
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        
        if isLoadMore && section == SectionType.products.rawValue {
            return CGSize(width: collectionView.frame.width, height: 70)
        } else {
            return CGSize(width: collectionView.frame.width, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == SectionType.header.rawValue {
            if shop.isOwner || ShopRoleManager.shared.isShopAdmin {
                return CGSize(width: view.frame.width, height: 200)
            } else {
                return CGSize(width: view.frame.width, height: 70)
            }
        } else {
            return .zero
        }
    }
}

// MARK: - UICollectionViewDelegate

extension ShopHomeListProductViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let scrollDelegate = scrollDelegateFunc {
            scrollDelegate(scrollView)
        }
        
        let collectionViewOffset = listProductCollectionView.contentSize.height - listProductCollectionView.frame.size.height - 50
        if scrollView.contentOffset.y >= collectionViewOffset
            && !isLoadMore
            && !isRequestingAPI
            && canLoadMore {
            
            currentPage += 1
            isLoadMore = true
            listProductCollectionView.reloadData()
            requestAPIProducts()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !isRequestingAPI && !products.isEmpty else { return }
        guard let product = products[safe: indexPath.row] else { return }
        AppRouter.pushToProductDetail(product)
    }
}

// MARK: - ShopSearchViewDelegate

extension ShopHomeListProductViewController: ShopSearchViewDelegate {
    func didEndSearch() {
        canLoadMore = true
    }
    
    func didSearch(text: String?) {
        guard var searchText = text, searchText != "" else {
            canLoadMore = true
            products = cachedProducts
            listProductCollectionView.reloadSections(IndexSet(integer: SectionType.products.rawValue))
            return
        }
        
        canLoadMore = false
        searchText = searchText.normalizeSearchText
        products = cachedProducts.filter { $0.name.normalizeSearchText.contains(searchText) }
        listProductCollectionView.reloadSections(IndexSet(integer: SectionType.products.rawValue))
    }
    
    func didSelectAddNewProduct() {
        guard shop.isOwner || ShopRoleManager.shared.hasRole(roleType: .createProduct) else {
            AlertManager.shared.showToast(message: TextManager.messageNotHasShopRole.localized())
            return
        }
        
        let viewController = CreateProductViewController()
        viewController.shopId = shop.id
        viewController.delegate = self
        UIViewController.topNavigationVC?.pushViewController(viewController, animated: true)
    }
}

// MARK: - CreateShopViewControllerDelegate

extension ShopHomeListProductViewController: CreateProductViewControllerDelegate {
    func didCreateProductSuccess(_ product: Product?) {
        let params: [String: Any] = ["shopId": shop.id ?? 0,
                                     "pageSize": numberProductPerPage,
                                     "pageNumber": 1]
        let endPoint = ProductEndPoint.getAllProductByShopId(parameters: params)
        
        APIService.request(endPoint: endPoint, onSuccess: { [weak self] (apiResponse) in
            guard let self = self else { return }
            guard let newProduct = apiResponse.toArray([Product.self]).first else { return }
            self.cachedProducts.insert(newProduct, at: 0)
            self.products.insert(newProduct, at: 0)
            self.listProductCollectionView.insertItems(at: [IndexPath(item: 0, section: SectionType.products.rawValue)])
            }, onFailure: { (apiError) in
                
        }) {
            
        }
    }
    
    func didUpdateProductSuccess(_ product: Product) {
        if let index = products.firstIndex(where: { $0.id == product.id }),
            let cacheProductIndex = cachedProducts.firstIndex(where: { $0.id == product.id }) {
            products[index] = product
            cachedProducts[cacheProductIndex] = product
            listProductCollectionView .reloadItems(at: [IndexPath(item: index, section: SectionType.products.rawValue)])
        } else {
            requestAPIProducts()
        }
    }
}

// MARK: - BaseProductViewDelegate

extension ShopHomeListProductViewController: BaseProductViewDelegate {
    func didSelectOption(_ product: Product) {
        AlertManager.shared.show(style: .actionSheet, buttons: [TextManager.editProduct.localized(), TextManager.deleteProduct.localized()]) { [weak self] (action, index) in
            
            guard let self = self else { return }
            
            if index == 0 {
                if self.shop.isOwner || ShopRoleManager.shared.hasRole(roleType: .updateProduct) {
                    let viewController = CreateProductViewController()
                    viewController.shopId = self.shop.id
                    viewController.product = product
                    viewController.delegate = self
                    UIViewController.topNavigationVC?.pushViewController(viewController, animated: true)
                } else {
                    AlertManager.shared.showToast(message: TextManager.messageNotHasShopRole.localized())
                }
                
            } else if index == 1 {
        
                if self.shop.isOwner || ShopRoleManager.shared.hasRole(roleType: .updateProduct) {
                    
                    AlertManager.shared.showConfirmMessage(mesage: TextManager.confirmDeleteProduct.localized(), confirmBlock: { (action) in
                        let endPoint = ProductEndPoint.deleteProduct(id: product.id ?? 0)
                        
                        APIService.request(endPoint: endPoint, onSuccess: { (apiResponse) in
                            if let index = self.products.firstIndex(where: { $0.id == product.id }),
                                let cacheProductIndex = self.cachedProducts.firstIndex(where: { $0.id == product.id }) {
                                
                                AlertManager.shared.showToast(message: TextManager.deleteProductSuccess.localized())
                                self.products.remove(at: index)
                                self.cachedProducts.remove(at: cacheProductIndex)
                                self.listProductCollectionView.deleteItems(at: [IndexPath(row: index,
                                                                                          section: SectionType.products.rawValue)])
                            }
                            
                        }, onFailure: { (apiErrpr) in
                            AlertManager.shared.showDefaultError()
                        }, onRequestFail: {
                            AlertManager.shared.showDefaultError()
                        });
                    })
                    
                } else {
                    AlertManager.shared.showToast(message: TextManager.messageNotHasShopRole.localized())
                }
            }
                
                
        }
    }
    
    func didSelectAddToCart(_ product: Product) {
        
    }
    
    func didSelectRefresh(_ product: Product) {
        guard shop.isOwner || ShopRoleManager.shared.hasRole(roleType: .updateProduct) else {
            AlertManager.shared.showToast(message: TextManager.messageNotHasShopRole.localized())
            return
        }
        
        let endPoint = ProductEndPoint.refreshProduct(id: product.id ?? -1)
        APIService.request(endPoint: endPoint, onSuccess: { (apiResponse) in
            AlertManager.shared.showToast(message: TextManager.refreshProductSuccess.localized())
        }, onFailure: { (apiError) in
            AlertManager.shared.showToast()
        }) {
            AlertManager.shared.showToast()
        }
    }
}
