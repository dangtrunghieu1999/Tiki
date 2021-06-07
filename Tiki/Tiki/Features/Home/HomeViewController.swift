//
//  HomeViewController.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 2/28/21.
//

import UIKit
import IGListKit
import SwiftyJSON

enum HomeSection: Int {
    case banner     = 0
    case menu       = 1
    case seperator  = 2
    case header     = 3
    case product    = 4
    
    static func numberOfSection() -> Int {
        return 5
    }
}

class HomeViewController: BaseViewController {
    
    // MARK: - Variables
    
    fileprivate var viewModel                   = HomeViewModel()
    fileprivate var banners:        [Banner]    = []
    fileprivate var categorys:      [Categories]  = []
    fileprivate var products:       [Product]   = []
    fileprivate var cachedProducts: [Product]   = []
    fileprivate var isLoadMore                  = false
    fileprivate var canLoadMore                 = true
    
    // MARK: - UI Elements
    
    fileprivate lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.background
        refreshControl.addTarget(self, action: #selector(pullToRefresh),
                                 for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing      = 6
        layout.minimumInteritemSpacing = 0
        let collectionView             = UICollectionView(frame: .zero,
                                                          collectionViewLayout: layout)
        collectionView.backgroundColor = .lightBackground
        collectionView.refreshControl  = refreshControl
        collectionView.frame           = view.bounds
        collectionView.dataSource      = self
        collectionView.delegate        = self
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonNavBar()
        registerCell()
        configNavigationBar()
        layoutCollectionView()
        requestAPIBanners()
        requestAPIProducts()
    }
    
    // MARK: - Helper Method
    
    private func registerCell() {
        self.collectionView.registerReusableCell(BannerCollectionViewCell.self)
        self.collectionView.registerReusableCell(MenuCollectionViewCell.self)
        self.collectionView.registerReusableCell(FooterCollectionViewCell.self)
        self.collectionView.registerReusableCell(HeaderCollectionViewCell.self)
        self.collectionView.registerReusableCell(ProductCollectionViewCell.self)
        self.collectionView.registerReusableSupplementaryView(
            LoadMoreCollectionViewCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter)
    }
    
    private func configNavigationBar() {
        let height = self.tabBarController?.tabBar.frame.height ?? 0
        self.collectionView.contentInset.bottom     = height
        self.tabBarController?.tabBar.isTranslucent = false
    }
    
    private func setButtonNavBar() {
        self.navigationItem.titleView      = searchBar
        navigationItem.rightBarButtonItems = [cartBarButtonItem,
                                              notifiBarButtonItem]
    }
    
    // MARK: = UIAction
    
    override func touchInSearchBar() {
        AppRouter.pushViewToSearchBar(viewController: self)
        searchBar.endEditing(true)
    }
    
    @objc private func pullToRefresh() {
        canLoadMore = true
        requestAPIBanners()
        requestAPIProducts()
    }
    
    // MARK: - Layout
    
    private func layoutCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            if #available(iOS 11, *) {
                make.top.equalTo(view.safeAreaInsets)
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom)
            }
            make.left.right.bottom.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = ScreenSize.SCREEN_WIDTH
        let type  = HomeSection(rawValue: indexPath.section)
        switch type {
        case .banner:
            return CGSize(width: width, height: 140)
        case .menu:
            return CGSize(width: width, height: 225)
        case .seperator:
            return CGSize(width: width, height: 8)
        case .header:
            return CGSize(width: width, height: 40)
        case .product:
            return CGSize(width: (width - 4) / 2, height: 320)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        
        if isLoadMore && section == HomeSection.product.rawValue {
            return CGSize(width: collectionView.frame.width, height: 70)
        } else {
            return CGSize(width: collectionView.frame.width, height: 0)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension HomeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return HomeSection.numberOfSection()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        let type = HomeSection(rawValue: section)
        switch type {
        case .banner, .menu, .seperator, .header:
            return 1
        case .product:
            if isRequestingAPI {
                return 6
            } else if products.isEmpty {
                return 1
            } else {
                return products.count
            }
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = HomeSection(rawValue: indexPath.section)
        switch type {
        case .banner:
            let cell: BannerCollectionViewCell  = collectionView.dequeueReusableCell(for: indexPath)
            cell.configCell(banners: banners)
            if !isRequestingAPI {
                cell.stopShimmering()
            }
            return cell
        case .menu:
            let cell: MenuCollectionViewCell    = collectionView.dequeueReusableCell(for: indexPath)
            cell.configCell(categorys)
            return cell
        case .seperator:
            let cell: FooterCollectionViewCell  = collectionView.dequeueReusableCell(for: indexPath)
            return cell
        case .header:
            let cell: HeaderCollectionViewCell  = collectionView.dequeueReusableCell(for: indexPath)
            if !isRequestingAPI {
                cell.stopShimmering()
            }
            cell.configTitle(title: TextManager.recommendProduct)
            return cell
        case .product:
            let cell: ProductCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            if let product = products[safe: indexPath.row] {
                cell.configCell(product)
            }
            if !isRequestingAPI {
                cell.stopShimmering()
            }
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionFooter
            && indexPath.section == HomeSection.product.rawValue {
            let footer: LoadMoreCollectionViewCell =
                collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)
            footer.animiate(isLoadMore)
            return footer
        } else {
            return UICollectionReusableView()
        }
    }
    
}

// MARK: - Request API

extension HomeViewController {
    
    private func reloadDataWhenFinishLoadAPI() {
        self.isRequestingAPI = false
        self.collectionView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    func requestAPIBanners() {
        let endPoint = HomeEndPoint.getBannerHome
        
        APIService.request(endPoint: endPoint) { [weak self] (apiResponse) in
            guard let self = self else { return }
            self.banners = apiResponse.toArray([Banner.self])
            self.requestAPIMenu()
        } onFailure: { [weak self] (apiError) in
            self?.reloadDataWhenFinishLoadAPI()
            AlertManager.shared.show(message:
                                        TextManager.errorMessage.localized())
        } onRequestFail: {
            self.reloadDataWhenFinishLoadAPI()
            AlertManager.shared.show(message:
                                        TextManager.errorMessage.localized())
        }
    }

    func requestAPIMenu() {
        let endPoint = HomeEndPoint.getCateogoryMenu

        APIService.request(endPoint: endPoint) { [weak self] (apiResponse) in
            guard let self = self else { return }
            self.categorys = apiResponse.toArray([Categories.self])
            self.reloadDataWhenFinishLoadAPI()
        } onFailure: {  [weak self] (apiError) in
            self?.reloadDataWhenFinishLoadAPI()
            AlertManager.shared.show(message:
                                        TextManager.errorMessage.localized())
        } onRequestFail: {
            self.reloadDataWhenFinishLoadAPI()
            AlertManager.shared.show(message:
                                        TextManager.errorMessage.localized())
        }

    }
    func requestAPIProducts() {
    
        let endPoint = ProductEndPoint.getAllProduct
        
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
                let numberProducts = self.products.count
                
                for index in 0..<productsResponse.count {
                    reloadIndexPaths.append(
                        IndexPath(item: numberProducts + index,
                        section: HomeSection.product.rawValue))
                }
                
                self.products = self.cachedProducts
                self.collectionView.insertItems(at: reloadIndexPaths)
            } else {
                self.products = self.cachedProducts
                self.collectionView.reloadData()
            }
            
            self.refreshControl.endRefreshing()
            
            if self.products.count < 3 {
                self.collectionView.contentInset =
                    UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
            }
            
        }, onFailure: { [weak self] (apiError) in
            guard let self = self else { return }
            self.isRequestingAPI = false
            self.isLoadMore = false
            self.canLoadMore = true
            self.collectionView.reloadData()
            self.refreshControl.endRefreshing()
            AlertManager.shared.showToast()
            
        }) { [weak self] in
            guard let self = self else { return }
            self.isRequestingAPI = false
            self.isLoadMore = false
            self.canLoadMore = true
            self.collectionView.reloadData()
            self.refreshControl.endRefreshing()
            AlertManager.shared.showToast()
        }
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let scrollDelegate = scrollDelegateFunc {
            scrollDelegate(scrollView)
        }
        
        let collectionViewOffset = collectionView.contentSize.height - collectionView.frame.size.height - 50
        if scrollView.contentOffset.y >= collectionViewOffset
            && !isLoadMore
            && !isRequestingAPI
            && canLoadMore {
            
            isLoadMore = true
            collectionView.reloadData()
            requestAPIProducts()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !isRequestingAPI && !products.isEmpty else { return }
        guard let product = products[safe: indexPath.row] else { return }
        AppRouter.pushToProductDetail(product)
    }
}
