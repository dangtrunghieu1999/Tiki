//
//  ProductByCateogryViewController.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 5/16/21.
//

import UIKit
import RxSwift

class ProductByIdViewController: BaseViewController {
    
    fileprivate var products:       [Product]   = []
    fileprivate var cachedProducts: [Product]   = []
    fileprivate var productsResponse: [Product] = []
    fileprivate var isLoadMore                  = false
    fileprivate var canLoadMore                 = true
    var disposeBag                              = DisposeBag()
    var idProductByCategrory: Int?
    

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing      = 6
        layout.minimumInteritemSpacing = 0
        let collectionView             = UICollectionView(frame: .zero,
                                                          collectionViewLayout: layout)
        collectionView.backgroundColor = .lightBackground
        collectionView.frame           = view.bounds
        collectionView.dataSource      = self
        collectionView.delegate        = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.registerReusableCell(ProductCollectionViewCell.self)
        collectionView.registerReusableSupplementaryView(
            LoadMoreCollectionViewCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter)
        return collectionView
    }()
    
    let pulleyView: FilterCouponPulleyView = {
        let view = FilterCouponPulleyView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        layoutCollectionView()
        layoutPulleyView()
        requestAPIProducts()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.pulleyView.removeFromSuperview()
    }
    
    func setupNavigationBar() {
        let filterButton = UIButton(type: .custom)
        filterButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        filterButton.setImage(UIImage(named: "filter"), for: .normal)
        filterButton.rx.controlEvent(.touchUpInside).asObservable().subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            
            if self.pulleyView.isShow {
                self.pulleyView.hidePulley()
            } else {
                self.pulleyView.showPulley()
            }
        } ).disposed(by: self.disposeBag)
        let filterBarButtonItem = UIBarButtonItem(customView: filterButton)
        
        self.navigationItem.titleView = searchBar
        self.searchBar.delegate = self
        self.navigationItem.rightBarButtonItems = [cartBarButtonItem,filterBarButtonItem]
        searchBar.textColor = UIColor.bodyText
        searchBar.text = "Tivi"
    }
    
    private func layoutCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            if #available(iOS 11, *) {
                make.top
                    .equalTo(view.safeAreaLayoutGuide)
                    .offset(dimension.normalMargin)
            } else {
                make.top
                    .equalTo(topLayoutGuide.snp.bottom)
                    .offset(dimension.normalMargin)
            }
            make.left
                .right
                .bottom
                .equalToSuperview()
        }
    }
    
    private func layoutPulleyView() {
        let currentWindow: UIWindow? = UIApplication.shared.keyWindow
        currentWindow?.addSubview(self.pulleyView)
        self.pulleyView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

extension ProductByIdViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if isRequestingAPI {
            return 6
        } else if products.isEmpty {
            return 1
        } else {
            return self.products.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ProductCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        if let product = products[safe: indexPath.row] {
            cell.configCell(product)
        }
        if !isRequestingAPI {
            cell.stopShimmering()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionFooter {
            let footer: LoadMoreCollectionViewCell =
                collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)
            footer.animiate(isLoadMore)
            return footer
        } else {
            return UICollectionReusableView()
        }
    }
}

extension ProductByIdViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (ScreenSize.SCREEN_WIDTH - 4) / 2, height: 320)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 70)
    }
}

extension ProductByIdViewController: UICollectionViewDelegate {
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
}

extension ProductByIdViewController {
    
    private func reloadDataWhenFinishLoadAPI() {
        self.isRequestingAPI = false
        self.isLoadMore = false
        self.canLoadMore = true
        self.collectionView.reloadData()
    }
    
    func requestAPIProducts() {
        
        let params = ["pageNumber": 0,
                      "pageSize": 5,
                      "categoryId": idProductByCategrory ?? 0]
        
        let endPoint = ProductEndPoint.getAllCategoryById(parameters: params)
        
        if !isLoadMore {
            isRequestingAPI = true
        }
        
        APIService.request(endPoint: endPoint, onSuccess: { [weak self] (apiResponse) in
            guard let self = self else { return }
            let json       = apiResponse.data?["content"]
            self.productsResponse  = json?.arrayValue.map { Product(json: $0)} ?? []
            
            if self.isLoadMore {
                self.cachedProducts.append(contentsOf: self.productsResponse)
            } else {
                self.cachedProducts = self.productsResponse
            }
            
            if self.canLoadMore {
                self.canLoadMore = !self.productsResponse.isEmpty
            }
            
            self.isRequestingAPI = false
            
            if self.isLoadMore {
                self.isLoadMore = false
                var reloadIndexPaths: [IndexPath] = []
                let numberProducts = self.products.count
                
                for index in 0..<self.productsResponse.count {
                    reloadIndexPaths.append(
                        IndexPath(item: numberProducts + index,
                                  section: 0))
                }
                
                self.products = self.cachedProducts
                self.collectionView.insertItems(at: reloadIndexPaths)
            } else {
                self.products = self.cachedProducts
                self.collectionView.reloadData()
            }
            
            if self.products.count < 3 {
                self.collectionView.contentInset =
                    UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
            }
            
        }, onFailure: { [weak self] (apiError) in
            guard let self = self else { return }
            self.reloadDataWhenFinishLoadAPI()
            AlertManager.shared.showToast()
            
        }) { [weak self] in
            guard let self = self else { return }
            self.reloadDataWhenFinishLoadAPI()
            AlertManager.shared.showToast()
        }
    }
}
