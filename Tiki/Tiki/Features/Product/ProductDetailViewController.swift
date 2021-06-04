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
    fileprivate lazy var comments:    [Comment] = []
    fileprivate var productInfoCellHeight:  CGFloat?
    fileprivate var desciptionCellHeight:   CGFloat?
    
    fileprivate var isExpandDescriptionCell = false
    
    var canExpendDescriptionCell: Bool {
        return (desciptionCellHeight ?? 0 > CGFloat(ProductDescribeCollectionViewCell.defaultHeightToExpand))
    }
    
    var colapseDescriptionCellHeight: CGFloat {
        return ProductDescribeCollectionViewCell.esitmateColapseHeight(product)
    }
    
    // MARK: - UI Elements
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    fileprivate lazy var bottomView: BaseView = {
        let view = BaseView()
        view.addTopBorder(with: UIColor.separator, andWidth: 1)
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var buyButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.selectToBuy, for: .normal)
        button.backgroundColor = UIColor.primary
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Dimension.shared.cornerRadiusSmall
        button.addTarget(self, action: #selector(tapOnBuyButton),
                         for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerReusableCell()
        layoutBottomView()
        layoutBuyButton()
        layoutCollectionView()
        requestProductSameAPI()
        requestProductCart()
        
        let target: Target = (target: self, selector: #selector(tapOnShareExternalButton))
        let shareExtenalButton = buildBarButton(from: BarButtonItemModel(ImageManager.shareExternal, target))
        navigationItem.rightBarButtonItems = [cartBarButtonItem, shareExtenalButton]
        navigationItem.title = TextManager.productDetail.localized()
    }
    
    func requestProductCart() {
        guard let path = Bundle.main.path(forResource: "ProductCart", ofType: "json") else {
            fatalError("Not available json")
        }
        
        let url = URL(fileURLWithPath: path)
        Alamofire.request(url).responseJSON { (response) in
            switch response.result {
            case.success(let value):
                let json = JSON(value)
                let data = json["data"]
                let products = data.arrayValue.map{Product(json: $0)}
                for product in products {
                    CartManager.shared.addProductToCart(product) {
                        NotificationCenter.default.post(name: Notification.Name.reloadCartBadgeNumber, object: nil)
                        AlertManager.shared.showToast(message: TextManager.addToCartSuccess.localized())
                    } error: {
                        AlertManager.shared.showToast()
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - UI Action
    
    @objc private func tapOnBuyButton() {
        
        CartManager.shared.addProductToCart(product) {
            NotificationCenter.default.post(name: Notification.Name.reloadCartBadgeNumber, object: nil)
            AlertManager.shared.showToast(message: TextManager.addToCartSuccess.localized())
        } error: {
            AlertManager.shared.showToast()
        }
    }
    
    @objc private func tapOnShareExternalButton() {
        AlertManager.shared.show(TextManager.shareProduct.localized(),
                                 message: TextManager.guideShareProduct,
                                 acceptMessage: TextManager.IUnderstand.localized()) {
            let urlString = "https://tiki.vn/dien-thoai-iphone-6s-plus-32gb-vn-a-hang-chinh-hang-p1823081.html?src=recently-viewed&spid=1823109"
            let viewController = UIActivityViewController(activityItems: [urlString], applicationActivities: [])
            self.present(viewController, animated: true)
        }
    }
    
    // MARK: - Helper Method
    
    private func registerReusableCell() {
        collectionView.registerReusableCell(ProductInfoCollectionViewCell.self)
        collectionView.registerReusableCell(ProductSameCollectionViewCell.self)
        collectionView.registerReusableCell(ProductStallCollectionViewCell.self)
        collectionView.registerReusableCell(ProductAdvanedCollectionViewCell.self)
        collectionView.registerReusableCell(ProductDetailsCollectionViewCell.self)
        collectionView.registerReusableCell(ProductParentCommentCollectionViewCell.self)
        collectionView.registerReusableCell(ProductChildCommentCollectionViewCell.self)
        collectionView.registerReusableCell(ProductDetailRecommendCollectionViewCell.self)
        collectionView.registerReusableCell(ProductDescribeCollectionViewCell.self)
        collectionView.registerReusableCell(BaseCollectionViewCell.self)
        collectionView.registerReusableCell(EmptyCollectionViewCell.self)
        collectionView
            .registerReusableSupplementaryView(TitleCollectionViewHeaderCell.self,
             forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
    }
    

    func configData(_ product: Product) {
        self.product = product
        collectionView.reloadData()
        getProductById(id: product.id ?? 0)
    }

    // MARK: - Request API
    
    func getProductById(id: Int) {
        let endPoint = ProductEndPoint.getProductById(parameters: ["id": id])
        APIService.request(endPoint: endPoint, onSuccess: { [weak self] (apiResponse) in
            guard let self = self else { return }
            if let product = apiResponse.toObject(Product.self) {
                self.product = product
                self.collectionView.reloadData()
            }
        }, onFailure: { (apiError) in
            AlertManager.shared.show(message:
                                        TextManager.errorMessage.localized())
        }) {
            AlertManager.shared.show(message:
                                        TextManager.errorMessage.localized())
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
                self.collectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - GET API
    
    // MARK: - Layout
    
    private func layoutBottomView() {
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            if #available(iOS 11, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalTo(bottomLayoutGuide.snp.top)
            }
            make.height.equalTo(70)
            make.left.right.equalToSuperview()
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
    
    private func layoutCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(bottomView.snp.top)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProductDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let sectionType = ProductDetailType(rawValue: indexPath.section) else {
            return .zero
        }
        
        switch sectionType {
        case .infomation:
            if let productInfoCellHeight = productInfoCellHeight {
                return CGSize(width: collectionView.frame.width, height: productInfoCellHeight)
            } else {
                productInfoCellHeight = ProductInfoCollectionViewCell.estimateHeight(product)
                return CGSize(width: collectionView.frame.width, height: productInfoCellHeight ?? 0)
            }
        case .sameProduct:
            return CGSize(width: collectionView.frame.width, height: 230)
        case .stallShop:
            return CGSize(width: collectionView.frame.width, height: 135)
        case .advanedShop:
            return CGSize(width: collectionView.frame.width, height: 140)
        case .infoDetail:
            return CGSize(width: collectionView.frame.width, height: 250)
        case .description:
            if canExpendDescriptionCell && !isExpandDescriptionCell {
                return CGSize(width: collectionView.frame.width, height: colapseDescriptionCellHeight)
            }
            
            if let desciptionCellHeight = desciptionCellHeight {
                return CGSize(width: collectionView.frame.width, height: desciptionCellHeight)
            } else {
                desciptionCellHeight = ProductDescribeCollectionViewCell.estimateHeight(product)
                return CGSize(width: collectionView.frame.width, height: desciptionCellHeight ?? 0)
            }
        case .comment:
            if product.comments.isEmpty {
                return CGSize(width: collectionView.frame.width, height: 140)
            } else {
                guard let comment = product.commentInProductDetail[safe: indexPath.row] else { return .zero }
                return CGSize(width: collectionView.frame.width,
                              height: ProductParentCommentCollectionViewCell.estimateHeight(comment))
            }
            
        case .recommend:
            return CGSize(width: collectionView.frame.width, height: 200)
        default:
            return CGSize(width: collectionView.frame.width, height: 8)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let sectionType = ProductDetailType(rawValue: section) else {
            return .zero
        }
        return sectionType.sizeForHeader()
    }
}

// MARK: - UICollectionViewDataSource

extension ProductDetailViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return ProductDetailType.numberSection()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sectionType = ProductDetailType(rawValue: section) else { return 0 }
        switch sectionType {
        case .comment:
            if (product.comments.isEmpty) {
                return 1
            } else {
                return product.numberCommentInProductDetail
            }
        default:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sectionType = ProductDetailType(rawValue: indexPath.section) else {
            return UICollectionViewCell()
        }
        
        switch sectionType {
        case .infomation:
            let cell: ProductInfoCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configDataInfomation(product: product)
            return cell
        case .sameProduct:
            let cell: ProductSameCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configDataCell(productSame)
            return cell
        case .stallShop:
            let cell: ProductStallCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configDataShop(product)
            return cell
        case .advanedShop:
            let cell: ProductAdvanedCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            return cell
        case .infoDetail:
            let cell: ProductDetailsCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            cell.configValueTitle(values: product.parameter)
            return cell
        case .description:
            let cell: ProductDescribeCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configData(product, canExpand: canExpendDescriptionCell, isExpand: isExpandDescriptionCell)
            cell.delegate = self
            return cell
        case .comment:
            if product.comments.isEmpty {
                let emptyCell: EmptyCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
                emptyCell.imageSize = CGSize(width: 40, height: 40)
                emptyCell.messageFont = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
                emptyCell.image = ImageManager.comment
                emptyCell.message = TextManager.emptyComment.localized()
                return emptyCell
            } else {
                let comment = product.commentInProductDetail[indexPath.row]
                
                if comment.isParrentComment {
                    let cell: ProductParentCommentCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
                    cell.configData(comment: comment)
                    cell.delegate = self
                    return cell
                } else {
                    let cell: ProductChildCommentCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
                    cell.configData(comment: comment)
                    cell.delegate = self
                    return cell
                }
            }
        case .recommend:
            let cell: ProductDetailRecommendCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            return cell
        default:
            let cell: BaseCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.backgroundColor = UIColor.separator
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard let sectionType = ProductDetailType(rawValue: indexPath.section) else {
            return UICollectionReusableView()
        }
        
        if kind == UICollectionView.elementKindSectionHeader {
            let header: TitleCollectionViewHeaderCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)
            header.title = sectionType.title
            return header
        } else {
            return UICollectionReusableView()
        }
    }
}

extension ProductDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let sectionType = ProductDetailType(rawValue: indexPath.section) else { return }
        
        switch sectionType {
        case .comment:
            let commentVC = ProductCommentViewController()
            commentVC.delegate = self
            commentVC.configData(comments: product.comments)
            commentVC.configData(productId: product.id)
            navigationController?.pushViewController(commentVC, animated: true)
            break
        case .infomation:
            AppRouter.pushToShopHome(product.shopId ?? 0)
            break
        default:
            break
        }
    }
}

// MARK: - ProductDetailsDelegate

extension ProductDetailViewController: ProductDetailsDelegate {
    func didTapSeemoreParamter(values: [String]) {
        AppRouter.presentViewParameterProduct(viewController: self, values: values)
    }
}

// MARK: - ProductDetailDesciptionCollectionViewCellDelegate

extension ProductDetailViewController: ProductDetailDesciptionCollectionViewCellDelegate {
    func didSelectSeeMore() {
        isExpandDescriptionCell = !isExpandDescriptionCell
        collectionView.reloadSections(IndexSet(integer: ProductDetailType.description.rawValue))
    }
}

// MARK: - ProductCommentViewControllerDelegate

extension ProductDetailViewController: ProductCommentViewControllerDelegate {
    func updateNewComments(_ comments: [Comment]) {
        product.comments = comments
        collectionView.reloadData()
    }
}

// MARK: - ProductDetailCommentCollectionViewCellDelegate

extension ProductDetailViewController: ProductDetailCommentCollectionViewCellDelegate {
    func didSelectLikeComment(_ comment: Comment) {
        
    }
    
    func didSelectReplyComment(_ comment: Comment) {
        let commentVC = ProductCommentViewController()
        commentVC.delegate = self
        commentVC.configData(comments: product.comments)
        commentVC.configData(productId: product.id, replyComment: comment)
        navigationController?.pushViewController(commentVC, animated: true)
    }
}
