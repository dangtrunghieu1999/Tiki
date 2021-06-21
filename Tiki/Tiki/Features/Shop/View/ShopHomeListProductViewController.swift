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
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
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
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == SectionType.header.rawValue {
            return UICollectionViewCell()
        }
        
        if products.isEmpty && !isRequestingAPI {
            let cell: EmptyCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.message = TextManager.emptyProducts.localized()
            return cell
        } else {
            let cell: ProductCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader
            && indexPath.section == SectionType.header.rawValue {
            let header: ShopHomeProductListSearchHeaderView =
                collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                for: indexPath)
            return header
            
        } else if kind == UICollectionView.elementKindSectionFooter
                    && indexPath.section == SectionType.products.rawValue {
            let footer: LoadMoreCollectionViewCell =
                collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                for: indexPath)
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
        
        if indexPath.section == SectionType.products.rawValue
            && products.isEmpty && !isRequestingAPI {
            return CGSize(width: collectionView.frame.width, height: 300)
        } else if indexPath.section == SectionType.products.rawValue {
            return BaseProductView.guestUserSize
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
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == SectionType.header.rawValue {
            return CGSize(width: view.frame.width, height: 70)
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
        
        let collectionViewOffset = listProductCollectionView.contentSize.height -
            listProductCollectionView.frame.size.height - 50
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
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
        guard !isRequestingAPI && !products.isEmpty else { return }
        guard let product = products[safe: indexPath.row] else { return }
        AppRouter.pushToProductDetail(product)
    }
}

