//
//  ShoppingViewController.swift
//  ZoZoApp
//
//  Created by Dang Trung Hieu on 8/29/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class ShoppingViewController: BaseViewController {
    
    // MARK: - Help Type
    
    enum ShoppingOptions:Int {
        case popular            = 0
        case megaSale           = 1
        case shopRecomend       = 2
        case authentic          = 3
        case productRecommend   = 4
        
        static func numberOfItems() -> Int{
            return 5
        }
        
        var title: String {
            switch self {
            case .popular:
                return TextManager.popular.localized()
            case .megaSale:
                return TextManager.megaSale.localized()
            case .shopRecomend:
                return TextManager.shopRecomend.localized()
            case .authentic:
                return TextManager.authentic.localized()
            case .productRecommend:
                return TextManager.suggest.localized()
            }
        }
    }
    
    enum PageType: Int {
        case shopping  = 0
        case earnMoney = 1
    }
    
    // MARK: - Variables
    
    fileprivate var popularProducts:   [Product] = []
    fileprivate var megaSaleProducts:  [Product] = []
    fileprivate var authenticProducts: [Product] = []
    fileprivate var recommendProducts: [Product] = []
    fileprivate var categories:        [Category] = []
    fileprivate var shopsRecommend:    [Shop]    = []
    
    fileprivate var popularLoadMore             = LoadMoreModel()
    fileprivate var megaSaleLoadMore            = LoadMoreModel()
    fileprivate var authenticLoadMore           = LoadMoreModel()
    fileprivate var recommendLoadMore           = LoadMoreModel()
    fileprivate var shopRecommendLoadMore       = LoadMoreModel()
    
    fileprivate var isFirstLoadAPIPopular       = false
    fileprivate var isFirstLoadAPIMegaSale      = false
    fileprivate var isFirstLoadAPIAuthentic     = false
    fileprivate var isFirstLoadAPIRecommend     = false
    fileprivate var isFirstLoadShopRecommend    = false
    
    private var pageType: PageType              = .shopping
    
    var isEarnMoneyLayout: Bool {
        return pageType == .earnMoney
    }
    
    // MARK: - UI Elements
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = BaseProductView.itemSpacing
        layout.minimumInteritemSpacing = BaseProductView.itemSpacing
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.lightBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.registerReusableCell(ShoppingCollectionViewCell.self)
        collectionView.registerReusableCell(ProductCollectionViewCell.self)
        collectionView.registerReusableCell(ShoppingMegaSaleCollectionViewCell.self)
        collectionView.registerReusableCell(RecommendShopCollectionViewCell.self)
        collectionView.isScrollEnabled = false
        
        collectionView.registerReusableSupplementaryView(
            TitleCollectionViewHeaderCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        collectionView.registerReusableSupplementaryView(
            GrayCollectionViewFooterCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter)
        collectionView.registerReusableSupplementaryView(
            LoadMoreCollectionViewCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter)
        
        return collectionView
    }()
    
    private let listCategoryView = ListCategoryView()
    
    // MARK: - View LifeCycles
    
    init(pageType: PageType) {
        self.pageType = pageType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isEarnMoneyLayout {
            navigationItem.title = TextManager.earnMoney.localized()
        } else {
            navigationItem.title = TextManager.shopping.localized()
        }
        
        view.backgroundColor = UIColor.lightBackground
        layoutListCategoryView()
        layoutCollectionView()
        
        getAllCategories()
        getPopularProducts()
        getMegaSaleProducts()
        getShopsRecommend()
        getAuthenticProducts()
        getRecommendProducts()
    }
    
    // MARK: - Request API
    
    func getPopularProducts() {
        let params = ["pageNumber": popularLoadMore.currentPage,
                      "pageSize": AppConfig.defaultProductPerPage]
        let endPoint = ShoppingEndPoint.getPopularProduct(parameters: params)
        
        if !recommendLoadMore.isLoadMore {
            isFirstLoadAPIPopular = true
        }
        
        APIService.request(endPoint: endPoint, onSuccess: { [weak self] (apiResponse) in
            guard let self = self else { return }
            self.collectionView.isScrollEnabled = true
            let products = apiResponse.toArray([Product.self])
            self.popularLoadMore.isLoadMore = false
            
            if !products.isEmpty || self.isFirstLoadAPIAuthentic {
                self.isFirstLoadAPIPopular = false
                self.popularProducts.append(contentsOf: products)
                self.collectionView.reloadData()
            } else if products.isEmpty {
                self.popularLoadMore.canLoadMore = false
            }
            }, onFailure: { [weak self] (apiError) in
                self?.reloadPoplarProductWhenFail()
        }) { [weak self] in
            self?.reloadPoplarProductWhenFail()
        }
    }
    
    private func reloadPoplarProductWhenFail() {
        self.popularLoadMore.isLoadMore = false
        self.isFirstLoadAPIPopular = false
        self.collectionView.reloadData()
    }
    
    func getMegaSaleProducts() {
        let params = ["pageNumber": megaSaleLoadMore.currentPage, "pageSize": AppConfig.defaultProductPerPage]
        let endPoint = ShoppingEndPoint.getAuthenticProduct(parameters: params)
        
        if !megaSaleLoadMore.isLoadMore {
            isFirstLoadAPIMegaSale = true
        }
        
        APIService.request(endPoint: endPoint, onSuccess: { [weak self] (apiResponse) in
            guard let self = self else { return }
            let products = apiResponse.toArray([Product.self])
            self.megaSaleLoadMore.isLoadMore = false
            self.collectionView.isScrollEnabled = true
            
            if !products.isEmpty || self.isFirstLoadAPIMegaSale {
                self.isFirstLoadAPIMegaSale = false
                self.megaSaleProducts.append(contentsOf: products)
                self.collectionView.reloadData()
            } else if products.isEmpty {
                self.megaSaleLoadMore.canLoadMore = false
            }
            }, onFailure: { [weak self] (apiError) in
                self?.reloadMegaSaleProductsWhenFail()
        }) { [weak self] in
            self?.reloadMegaSaleProductsWhenFail()
        }
    }
    
    private func reloadMegaSaleProductsWhenFail() {
        self.megaSaleLoadMore.isLoadMore = false
        self.isFirstLoadAPIMegaSale = false
        self.collectionView.reloadData()
    }
    
    func getAuthenticProducts() {
        let params = ["pageNumber": authenticLoadMore.currentPage, "pageSize": AppConfig.defaultProductPerPage]
        let endPoint = ShoppingEndPoint.getAuthenticProduct(parameters: params)
        
        if !authenticLoadMore.isLoadMore {
            isFirstLoadAPIAuthentic = true
        }
        
        APIService.request(endPoint: endPoint, onSuccess: { [weak self] (apiResponse) in
            guard let self = self else { return }
            let products = apiResponse.toArray([Product.self])
            self.authenticLoadMore.isLoadMore = false
            self.collectionView.isScrollEnabled = true
            
            if !products.isEmpty || self.isFirstLoadAPIAuthentic {
                self.isFirstLoadAPIAuthentic = false
                self.authenticProducts.append(contentsOf: products)
                self.collectionView.reloadData()
            } else if products.isEmpty {
                self.authenticLoadMore.canLoadMore = false
            }
            }, onFailure: { [weak self] (apiError) in
                self?.reloadAutheticProductsWhenFail()
        }) { [weak self] in
            self?.reloadAutheticProductsWhenFail()
        }
    }
    
    private func reloadAutheticProductsWhenFail() {
        self.authenticLoadMore.isLoadMore = false
        self.isFirstLoadAPIAuthentic = false
        self.collectionView.reloadData()
    }
    
    func getRecommendProducts() {
        let params = ["pageNumber": recommendLoadMore.currentPage, "pageSize": AppConfig.defaultProductPerPage]
        let endPoint = ShoppingEndPoint.getSuggestProduct(parameters: params)
        
        if !recommendLoadMore.isLoadMore {
            isFirstLoadAPIRecommend = true
        }
        
        APIService.request(endPoint: endPoint, onSuccess: { [weak self] (apiResponse) in
            guard let self = self else { return }
            let products = apiResponse.toArray([Product.self])
            self.recommendProducts.append(contentsOf: products)
            self.collectionView.isScrollEnabled = true
            self.recommendLoadMore.isLoadMore = false
            self.isFirstLoadAPIRecommend = false
            self.collectionView.reloadData()
            }, onFailure: { (apiError) in
                self.recommendLoadMore.isLoadMore = false
                self.isFirstLoadAPIRecommend = false
                self.collectionView.reloadData()
        }) {
            self.recommendLoadMore.isLoadMore = false
            self.isFirstLoadAPIRecommend = false
            self.collectionView.reloadData()
        }
    }
    
    fileprivate func getAllCategories() {
        let endPoint = ShopEndPoint.getAllCategory
        
        APIService.request(endPoint: endPoint, onSuccess: { [weak self] (apiResponse) in
            guard let self = self else { return }
            self.categories = apiResponse.toArray([Category.self])
            self.listCategoryView.setupData(self.categories)
            }, onFailure: { (apiError) in
                AlertManager.shared.show(message: TextManager.errorMessage.localized())
        }) {
            AlertManager.shared.show(message: TextManager.errorMessage.localized())
        }
    }
    
    fileprivate func getShopsRecommend() {
        let _ = ["pageNumber": shopRecommendLoadMore.currentPage, "pageSize": AppConfig.defaultProductPerPage]
        let endPoint = ShopEndPoint.getAll
        
        if !shopRecommendLoadMore.isLoadMore {
            isFirstLoadShopRecommend = true
        }
        
        APIService.request(endPoint: endPoint, onSuccess: { [weak self] (apiResponse) in
            guard let self = self else { return }
            let shops = apiResponse.toArray([Shop.self])
            
            if !shops.isEmpty || self.isFirstLoadShopRecommend {
                self.isFirstLoadShopRecommend = false
                self.shopsRecommend.append(contentsOf: shops)
                self.collectionView.reloadData()
            } else if shops.isEmpty {
                self.shopRecommendLoadMore.canLoadMore = false
            }
            
            }, onFailure: { [weak self] (apiError) in
                self?.reloadDataWhenFinishLoadAPI()
                AlertManager.shared.show(message: TextManager.errorMessage.localized())
        }) { [weak self] in
            self?.reloadDataWhenFinishLoadAPI()
            AlertManager.shared.show(message: TextManager.errorMessage.localized())
        }
    }
    
    private func reloadDataWhenFinishLoadAPI() {
        isFirstLoadShopRecommend = true
        collectionView.reloadData()
    }

    // MARK: - Setup layouts
    
    private func layoutListCategoryView() {
        view.addSubview(listCategoryView)
        listCategoryView.snp.makeConstraints { (make) in
            if #available(iOS 11, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom)
            }
            
            make.width.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    
    private func layoutCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.bottom.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-10)
            make.top.equalTo(listCategoryView.snp.bottom).offset(6)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ShoppingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let shoppingType = ShoppingOptions(rawValue: indexPath.section)
        if shoppingType == .productRecommend {
            if isEarnMoneyLayout {
                return BaseProductView.earnMoneySize
            } else {
                return BaseProductView.guestUserSize
            }
        } else if shoppingType == .shopRecomend {
            return CGSize(width: collectionView.frame.width, height: 100)
        } else {
            if isEarnMoneyLayout {
                return CGSize(width: collectionView.frame.width,
                              height: BaseProductView.earnMoneyHeight + 16)
            } else {
                return CGSize(width: collectionView.frame.width,
                              height: BaseProductView.guestUserHeight + 16)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == ShoppingOptions.productRecommend.rawValue {
            return CGSize(width: ScreenSize.SCREEN_WIDTH, height: 70)
        } else {
            return CGSize(width: collectionView.frame.width, height: 50)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        
        guard let shoppingType = ShoppingOptions(rawValue: section) else { return .zero }
        
        if shoppingType == .productRecommend {
            return CGSize(width: collectionView.frame.width, height: 40)
        } else if shoppingType == .shopRecomend {
            return CGSize(width: collectionView.frame.width, height: 10)
        } else {
            return CGSize(width: collectionView.frame.width, height: 0)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension ShoppingViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return ShoppingOptions.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == ShoppingOptions.productRecommend.rawValue {
            if recommendProducts.isEmpty && isFirstLoadAPIRecommend {
                return 6
            } else {
                return recommendProducts.count
            }
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let shoppingType = ShoppingOptions(rawValue: indexPath.section) else {
            return UICollectionViewCell()
        }
        
        switch shoppingType {
        case .popular:
            let cell: ShoppingCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            if !isFirstLoadAPIPopular {
                cell.configData(popularProducts, isEarnMoneyLayout: isEarnMoneyLayout)
                cell.shoppingCellType = shoppingType
            }
            cell.delegate = self
            return cell
            
        case .megaSale:
            let cell: ShoppingMegaSaleCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            if !isFirstLoadAPIMegaSale {
                cell.configData(megaSaleProducts, isEarnMoneyLayout: isEarnMoneyLayout)
                cell.shoppingCellType = shoppingType
            }
            cell.delegate = self
            return cell
            
        case .shopRecomend:
            let cell: RecommendShopCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            if !isFirstLoadShopRecommend {
                cell.setupData(shopsRecommend)
            }
            cell.delegate = self
            return cell
            
        case .authentic:
            let cell: ShoppingCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            if !isFirstLoadAPIAuthentic {
                cell.configData(authenticProducts, isEarnMoneyLayout: isEarnMoneyLayout)
                cell.shoppingCellType = shoppingType
            }
            cell.delegate = self
            return cell
            
        case .productRecommend:
            let cell: ProductCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            
            if !isFirstLoadAPIRecommend {
                if let product = recommendProducts[safe: indexPath.row] {
                    cell.configData(product, isEarnMoneyLayout: isEarnMoneyLayout)
                }
                
                cell.stopShimmer()
            }
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let shoppingType = ShoppingOptions(rawValue: indexPath.section) else {
            return UICollectionReusableView()
        }
        
        if kind == UICollectionView.elementKindSectionHeader {
            let header: TitleCollectionViewHeaderCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)
            
            header.title = ShoppingOptions(rawValue: indexPath.section)?.title
            header.font = UIFont.systemFont(ofSize: FontSize.title.rawValue, weight: .bold)
            header.textColor = UIColor.accentColor
            return header
        } else {
            if shoppingType == .productRecommend {
                let loadMore: LoadMoreCollectionViewCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)
                loadMore.animiate(recommendLoadMore.isLoadMore)
                return loadMore
                
            } else {
                let footer: GrayCollectionViewFooterCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)
                footer.backgroundColor = UIColor.lightBackground
                return footer
            }
        }
    }
}

// MARK: - ShoppingCollectionViewCellDelegate
extension ShoppingViewController: ShoppingCollectionViewCellDelegate {
    func loadMoreProducts(_ type: ShoppingViewController.ShoppingOptions) {
        switch type {
        case .popular:
            if !popularLoadMore.isLoadMore && !isFirstLoadAPIPopular && popularLoadMore.canLoadMore {
                popularLoadMore.currentPage += 1
                popularLoadMore.isLoadMore = true
                getPopularProducts()
            }
            
            break
        case .megaSale:
            if !megaSaleLoadMore.isLoadMore && !isFirstLoadAPIMegaSale && megaSaleLoadMore.canLoadMore {
                megaSaleLoadMore.currentPage += 1
                megaSaleLoadMore.isLoadMore = true
                getMegaSaleProducts()
            }
            
            break
        case .authentic:
            if !authenticLoadMore.isLoadMore && !isFirstLoadAPIAuthentic && authenticLoadMore.canLoadMore {
                authenticLoadMore.currentPage += 1
                authenticLoadMore.isLoadMore = true
                getAuthenticProducts()
            }
            
            break
            
        case .shopRecomend:
            if !shopRecommendLoadMore.isLoadMore && !isFirstLoadShopRecommend && shopRecommendLoadMore.canLoadMore {
                shopRecommendLoadMore.currentPage += 1
                shopRecommendLoadMore.isLoadMore = true
                getShopsRecommend()
            }
            
            break
            
        default:
            break
        }
    }
}

// MARK: - UICollectionViewDelegate

extension ShoppingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let product = recommendProducts[safe: indexPath.row] {
            AppRouter.pushToProductDetail(product)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let collectionViewOffset = collectionView.contentSize.height - collectionView.frame.size.height - 50
        if scrollView.contentOffset.y >= collectionViewOffset
            && !recommendLoadMore.isLoadMore
            && !isFirstLoadAPIRecommend
            && recommendLoadMore.canLoadMore {
            
            recommendLoadMore.currentPage += 1
            recommendLoadMore.isLoadMore = true
            collectionView.reloadData()
            getRecommendProducts()
        }
    }
}
