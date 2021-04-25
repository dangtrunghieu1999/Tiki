//
//  ProductListViewController.swift
//  ZoZoApp
//
//  Created by LAP12852 on 8/30/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class ProductListViewController: BaseViewController {
    
    // MARK: - Helper type
    
    enum ProductListType: Int {
        case searchResult     = 0
        case productCategory  = 1
    }
    
    // MARK: - Variables
    
    fileprivate var products: [Product]              = []
    fileprivate var currentPage                      = 1
    fileprivate var isLoadMore                       = false
    fileprivate var canLoadMore                      = true
    fileprivate var productListType: ProductListType = .searchResult
    fileprivate var addtionalTitle: String?          = nil
    
    var categoryId: Int? {
        didSet {
            loadProducts()
        }
    }
    
    // MARK: - UI Elements
    
    fileprivate lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.background
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    fileprivate lazy var resultProductCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = BaseProductView.itemSpacing
        layout.minimumInteritemSpacing = BaseProductView.itemSpacing
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        collectionView.backgroundColor = UIColor.clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.registerReusableCell(ProductCollectionViewCell.self)
        collectionView.registerReusableSupplementaryView(
            LoadMoreCollectionViewCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter)
        return collectionView
    }()
    
    // MARK: - View LifeCycles
    
    init(type: ProductListType, addtionalTitle: String? = nil) {
        super.init(nibName: nil, bundle: nil)
        productListType = type
        self.addtionalTitle = addtionalTitle
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let title = addtionalTitle {
            navigationItem.title = title
        } else {
            navigationItem.title = TextManager.productCategory
        }
        
        view.backgroundColor = UIColor.lightBackground
        layoutResultProductCollectionView()
        addEmptyView()
        emptyView.backgroundColor = UIColor.clear
        emptyView.message = TextManager.emptyProducts.localized()
        
        loadProducts()
    }
    
    // MARK: - UI Actions
    
    @objc private func pullToRefresh() {
        currentPage = 1
        canLoadMore = true
        loadProducts()
    }
    
    // MARK: - APIs Request
    
    func getAPIProducts<T: EndPointType>(with endPoint: T) {
        if !isLoadMore {
            isRequestingAPI = true
        }
        
        APIService.request(endPoint: endPoint, onSuccess: { [weak self] (apiResponse) in
            guard let self = self else { return }
            let products = apiResponse.toArray([Product.self])
            if products.isEmpty {
                self.canLoadMore = false
            }
            self.products.append(contentsOf: products)
            self.emptyView.isHidden = !self.products.isEmpty
            self.isLoadMore = false
            self.isRequestingAPI = false
            self.resultProductCollectionView.reloadData()
            }, onFailure: { (apiError) in
                AlertManager.shared.showDefaultError()
        }) {
        }
    }
    
    // MARK: - Helper methods
    
    private func loadProducts() {
        var params = ["pageNumber": currentPage, "pageSize": AppConfig.defaultProductPerPage]
        
        switch productListType {
        case .searchResult:
            let endPoint = ShoppingEndPoint.getSuggestProduct(parameters: params)
            getAPIProducts(with: endPoint)
            break
            
        case .productCategory:
            guard let categoryId = categoryId else { return }
            params["categoryId"] = categoryId
            let endPoint = ProductEndPoint.getAllProductByCategoryId(parameters: params)
            getAPIProducts(with: endPoint)
            break
            
        }
    }
    
    // MARK: - Layout
    
    private func layoutResultProductCollectionView() {
        view.addSubview(resultProductCollectionView)
        resultProductCollectionView.snp.makeConstraints { (make) in
            make.centerY.centerX.height.equalToSuperview()
            make.width.equalToSuperview().offset(-10)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProductListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return BaseProductView.guestUserSize
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: 50)
    }
}

// MARK: - UICollectionViewDataSource

extension ProductListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isRequestingAPI && productListType == .productCategory {
            return 6
        } else {
            return products.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ProductCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        if !isRequestingAPI {
            cell.configData(products[indexPath.row], isOwner: false)
            cell.stopShimmer()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionFooter {
            let footer: LoadMoreCollectionViewCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)
            footer.animiate(isLoadMore && !isRequestingAPI)
            return footer
        } else {
            return UICollectionReusableView()
        }
    }
}

// MARK: - UICollectionViewDelegate

extension ProductListViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let collectionViewOffset = resultProductCollectionView.contentSize.height - resultProductCollectionView.frame.size.height - 50
        if scrollView.contentOffset.y >= collectionViewOffset
            && !isLoadMore
            && !isRequestingAPI
            && canLoadMore {
            
            currentPage += 1
            isLoadMore = true
            resultProductCollectionView.reloadData()
            loadProducts()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let products = products[safe: indexPath.row] {
            AppRouter.pushToProductDetail(products)
        }
    }
}
