//
//  ListShopViewController.swift
//  ZoZoApp
//
//  Created by MACOS on 6/9/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class ListShopViewController: BaseViewController {
    
    // MARK: - Variables
    
    fileprivate lazy var shops: [Shop]      = []
    fileprivate lazy var cacheShops: [Shop] = []
    fileprivate let defaultNumberOfShop     = 5
    
    /// When create shop will back to ShopListVC and requestAPIShopList.
    /// When request API finish will find shop and go to ShopInfoVC
    fileprivate var createdShopCode: String?
    
    // MARK: - UI Elements
    
    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.tintColor = UIColor.background
        control.addTarget(self, action: #selector(requestAPIGetShops), for: .valueChanged)
        return control
    }()
    
    fileprivate lazy var listShopCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.tableBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.refreshControl = refreshControl
        collectionView.registerReusableCell(ListShopCollectionViewCell.self)
        collectionView.registerReusableCell(EmptyCollectionViewCell.self)
        
        collectionView.registerReusableSupplementaryView(
            AddShopCollectionViewHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader
        )
        return collectionView
    }()
    
    // MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = cartBarButtonItem
        navigationItem.titleView = searchBar
        addBackButtonIfNeeded()
        layoutCollectionView()
        requestAPIGetShops()
    }
    
    // MARK: - Override
    
    override func searchBarValueChange(_ textField: UITextField) {
        guard var searchText = textField.text, searchText != "" else {
            shops = cacheShops
            listShopCollectionView.reloadData()
            return
        }
        searchText = searchText.normalizeSearchText
        shops = cacheShops.filter { $0.name.normalizeSearchText.contains(searchText) }
        listShopCollectionView.reloadData()
    }
    
    // MARK: - Private
    
    @objc fileprivate func requestAPIGetShops() {
        let endPoint = ShopEndPoint.getShopsByUser
        
        APIService.request(endPoint: endPoint, onSuccess: { [weak self] (apiResponse) in
            self?.shops = apiResponse.toArray([Shop.self])
            self?.cacheShops = self?.shops ?? []
            self?.reloadDataWhenFinishLoadAPI()
            self?.gotoShopInfoIfNeeded()
            
            }, onFailure: { [weak self] (apiError) in
                self?.reloadDataWhenFinishLoadAPI()
                AlertManager.shared.show(message: TextManager.errorMessage.localized())
        }) { [weak self] in
            self?.reloadDataWhenFinishLoadAPI()
            AlertManager.shared.show(message: TextManager.errorMessage.localized())
        }
    }
    
    private func reloadDataWhenFinishLoadAPI() {
        self.hideLoading()
        self.isRequestingAPI = false
        self.listShopCollectionView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    private func gotoShopInfoIfNeeded() {
        guard let shopCode = createdShopCode else { return }
        var shop = shops.filter { $0.code == shopCode }.first
        if shop != nil {
            shop = shops.first
        }
        createdShopCode = nil
        guard let createdShop = shop else { return }
        let vc = ShopHomeViewController()
        vc.setShopInfo(createdShop)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Layouts
    
    private func layoutCollectionView() {
        view.addSubview(listShopCollectionView)
        listShopCollectionView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
    }
    
}

// MARK: - UICollectionViewDelegate

extension ListShopViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !isRequestingAPI && !shops.isEmpty else { return }
        
        let viewController = ShopHomeViewController()
        if let shop = shops[safe: indexPath.row] {
            viewController.setShopInfo(shop)
        }
        viewController.shopInfoDelegate = self
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension ListShopViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if shops.isEmpty && isRequestingAPI {
            return defaultNumberOfShop
        } else if shops.isEmpty && !isRequestingAPI {
            return 1
        } else {
            return shops.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if shops.isEmpty && !isRequestingAPI {
            let cell: EmptyCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.message = TextManager.emptyShop.localized()
            return cell
            
        } else {
            let cell: ListShopCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            if let shop = shops[safe: indexPath.row] {
                cell.configCell(by: shop)
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
        let header: AddShopCollectionViewHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, for: indexPath)
        header.delegate = self
        return header
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ListShopViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if shops.isEmpty && !isRequestingAPI {
            return CGSize(width: collectionView.frame.width,
                          height: collectionView.frame.height - 110)
        } else {
            return CGSize(width: collectionView.frame.width - 2 * Dimension.shared.mediumMargin,
                          height: 100)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return Dimension.shared.mediumMargin
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return Dimension.shared.smallMargin
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: 110)
    }
}

// MARK: - AddShopCollectionViewHeaderDelegate

extension ListShopViewController: AddShopCollectionViewHeaderDelegate {
    func didSelectAddShop() {
        guard !isRequestingAPI else { return }
        let viewController = CreateShopViewController()
        viewController.delegate = self
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - CreateShopViewControllerDelegate

extension ListShopViewController: CreateShopViewControllerDelegate {
    func didCreateShopSuccess(with shopCode: String) {
        showLoading()
        createdShopCode = shopCode
        requestAPIGetShops()
    }
}

// MARK: - ShopHomeViewControllerDelegate

extension ListShopViewController: ShopHomeViewControllerDelegate {
    func didUpdateInfoSuccess() {
        requestAPIGetShops()
    }
}
