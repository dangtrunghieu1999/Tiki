//
//  ProductViewController.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 4/12/21.
//

import UIKit
import IGListKit
import SwiftyJSON
import Alamofire

class ProductDetailViewController: BaseViewController {
    
    // MARK: - Variables
    
    fileprivate lazy var product = Product()
    fileprivate lazy var productSame: [Product] = []
    
    // MARK: - UI Elements
    
    private lazy var productCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    private lazy var buyButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.selectToBuy.localized(), for: .normal)
        button.backgroundColor = UIColor.primary
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(tapOnBuyButton), for: .touchUpInside)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Dimension.shared.cornerRadiusSmall
        return button
    }()
    
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerReusableCell()
        layoutBuyButton()
        layoutCollectionView()
        requestProductDetailAPI()
        requestProductSameAPI()
    }
    
    // MARK: - UI Action
    
    @objc private func tapOnBuyButton() {
        
    }
    
    // MARK: - Helper Method
    
    private func registerReusableCell() {
        productCollectionView.registerReusableCell(ProductDetailInfoCollectionViewCell.self)
        productCollectionView.registerReusableCell(ProductSameProductCollectionViewCell.self)
        productCollectionView.registerReusableCell(ProductStallShopCollectionViewCell.self)
        productCollectionView.registerReusableCell(ProductAdvanedShopCollectionViewCell.self)
        productCollectionView.registerReusableCell(ProductDetailsCollectionViewCell.self)
        productCollectionView.registerReusableCell(ProductParentCommentCollectionViewCell.self)
        productCollectionView.registerReusableCell(ProductChildCommentCollectionViewCell.self)
        productCollectionView.registerReusableCell(ProductDetailRecommendCollectionViewCell.self)
        productCollectionView.registerReusableCell(ProductDetailDescriptionCollectionViewCell.self)
        productCollectionView.registerReusableCell(BaseCollectionViewCell.self)
    }
    
    func requestProductDetailAPI() {
        guard let path = Bundle.main.path(forResource: "ProductDetail", ofType: "json") else {
            fatalError("Not available json")
        }
        let url = URL(fileURLWithPath: path)
        Alamofire.request(url).responseJSON { (response) in
            switch response.result {
            case.success(let value):
                let json = JSON(value)
                let data = json["data"]
                self.product = Product(json: data)
                self.productCollectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func requestProductSameAPI() {
        guard let path = Bundle.main.path(forResource: "ProductRecommend", ofType: "json") else {
            fatalError("Not available json")
        }
        let url = URL(fileURLWithPath: path)
        Alamofire.request(url).responseJSON { (response) in
            switch response.result {
            case.success(let value):
                let json = JSON(value)
                self.productSame = json.arrayValue.map{Product(json: $0)}
                self.productCollectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    // MARK: - GET API
    
    // MARK: - Layout
    
    private func layoutBuyButton() {
        view.addSubview(buyButton)
        buyButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Dimension.shared.normalMargin)
            make.right.equalToSuperview().offset(-Dimension.shared.normalMargin)
            make.height.equalTo(Dimension.shared.defaultHeightButton)
            if #available(iOS 11, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-Dimension.shared.mediumMargin)
            } else {
                make.bottom.equalToSuperview().offset(-Dimension.shared.mediumMargin)
            }
        }
    }
    
    private func layoutCollectionView() {
        view.addSubview(productCollectionView)
        productCollectionView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(buyButton.snp.top).offset(-Dimension.shared.mediumMargin)
        }
    }
    
}

extension ProductDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let sectionType = ProductDetailType(rawValue: indexPath.row) else {
            return .zero
        }
        
        switch sectionType {
        case .infomation:
            return CGSize(width: collectionView.frame.width, height: 470)
        case .sameProduct:
            return CGSize(width: collectionView.frame.width, height: 313)
        case .stallShop:
            return CGSize(width: collectionView.frame.width, height: 200)
        case .advanedShop:
            return CGSize(width: collectionView.frame.width, height: 200)
        case .infoDetail:
            return CGSize(width: collectionView.frame.width, height: 200)
        case .description:
            return CGSize(width: collectionView.frame.width, height: 200)
        case .comment:
            return CGSize(width: collectionView.frame.width, height: 200)
        case .recomment:
            return CGSize(width: collectionView.frame.width, height: 200)
        case .recommend:
            return CGSize(width: collectionView.frame.width, height: 200)
        default:
            return CGSize(width: collectionView.frame.width, height: 8)
        }
    }
}

extension ProductDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ProductDetailType.numberSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sectionType = ProductDetailType(rawValue: indexPath.row) else {
            return UICollectionViewCell()
        }
        
        switch sectionType {
        case .infomation:
            let cell: ProductDetailInfoCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configDataInfomation(product: product)
            return cell
        case .sameProduct:
            let cell: ProductSameProductCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configDataCell(productSame)
            return cell
        case .stallShop:
            let cell: ProductStallShopCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            return cell
        case .advanedShop:
            let cell: ProductAdvanedShopCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            return cell
        case .infoDetail:
            let cell: ProductDetailsCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            return cell
        case .description:
            let cell: ProductDetailDescriptionCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            return cell
        case .comment:
            let cell: ProductParentCommentCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            return cell
        case .recomment:
            let cell: ProductDetailRecommendCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            return cell
        case .recommend:
            let cell: ProductDetailRecommendCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            return cell
        default:
            let cell: BaseCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.backgroundColor = UIColor.separator
            return cell
        }
    }
}
