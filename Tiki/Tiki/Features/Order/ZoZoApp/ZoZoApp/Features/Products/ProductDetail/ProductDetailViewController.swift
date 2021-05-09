//
//  ProductDetailViewController.swift
//  ZoZoApp
//
//  Created by MACOS on 7/20/19.
//  Copyright © 2019 MACOS. All rights reserved.
//


import UIKit

class ProductDetailViewController: BaseViewController {
    
    // MARK: - Helper Type
    
    fileprivate enum SectionType: Int {
        case infomation     = 0
        case shopInfo       = 1
        case size           = 2
        case color          = 3
        case description    = 4
        case comment        = 5
        case recommend      = 6
        
        static func numberSection() -> Int {
            return 7
        }
        
        func sizeForHeader() -> CGSize {
            switch self {
            case .infomation:
                return .zero
            default:
                return CGSize(width: ScreenSize.SCREEN_WIDTH, height: 50)
            }
        }
        
        var title: String {
            switch self {
            case .infomation:
                return ""
            case .shopInfo:
                return TextManager.shopInfo.localized()
            case .size:
                return TextManager.selectSize.localized()
            case .color:
                return TextManager.selectColor.localized()
            case .description:
                return TextManager.detailDes.localized()
            case .comment:
                return TextManager.comment.localized()
            case .recommend:
                return TextManager.recommendProduct.localized()
            }
        }
    }
    
    // MARK: - Variables
    
    fileprivate lazy var product = Product()
    fileprivate var suggestProduct: [Product] = []
    fileprivate var currentPage = 1
    fileprivate var isLoadMore = false
    fileprivate var canLoadMore = true
    
    fileprivate var productInfoCellHeight:  CGFloat?
    fileprivate var sizeCellHeight:         CGFloat?
    fileprivate var colorCellHeight:        CGFloat?
    fileprivate var desciptionCellHeight:   CGFloat?
    
    fileprivate var isExpandDescriptionCell = false
    
    var colapseDescriptionCellHeight: CGFloat {
        return ProductDetailDesciptionCollectionViewCell.esitmateColapseHeight(product)
    }
    
    var canExpendDescriptionCell: Bool {
        return (desciptionCellHeight ?? 0 > CGFloat(ProductDetailDesciptionCollectionViewCell.defaultHeightToExpand))
    }
    
    // MARK: - UI Elements
    
    fileprivate lazy var productCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.registerReusableCell(EmptyCollectionViewCell.self)
        collectionView.registerReusableCell(ProductDetailInfoCollectionViewCell.self)
        collectionView.registerReusableCell(ProductDetailSizeCollectionViewCell.self)
        collectionView.registerReusableCell(ProductDetailInfoCollectionViewCell.self)
        collectionView.registerReusableCell(ProductDetailDesciptionCollectionViewCell.self)
        collectionView.registerReusableCell(ProductDetailShopInfoCollectionViewCell.self)
        collectionView.registerReusableCell(ProductParentCommentCollectionViewCell.self)
        collectionView.registerReusableCell(ProductChildCommentCollectionViewCell.self)
        collectionView.registerReusableCell(ProductDetailRecommendCollectionViewCell.self)
        collectionView.registerReusableSupplementaryView(TitleCollectionViewHeaderCell.self,
                                                         forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        collectionView.registerReusableSupplementaryView(GrayCollectionViewFooterCell.self,
                                                          forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter)
        return collectionView
    }()
    
    private lazy var buyButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.selectToBuy.localized(), for: .normal)
        button.backgroundColor = UIColor.accentColor
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(tapOnBuyButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let target: Target = (target: self, selector: #selector(tapOnShareExternalButton))
        let shareExtenalButton = buildBarButton(from: BarButtonItemModel(ImageManager.shareExternal, target))
        navigationItem.rightBarButtonItems = [cartBarButtonItem, shareExtenalButton]
        navigationItem.title = TextManager.productDetail.localized()
        
        layoutBuyButton()
        layoutCollectionView()
        getSuggestProduct()
    }
    
    // MARK: - Public methods
    
    func configData(_ product: Product) {
        self.product = product
        calculateSizeAndColorHeight()
        productCollectionView.reloadData()
        getProductById(id: product.id ?? 0)
    }
    
    // MARK: - Request API
    
    func getProductById(id: Int) {
        let endPoint = ProductEndPoint.getProductById(parameters: ["Id": id])
        APIService.request(endPoint: endPoint, onSuccess: { [weak self] (apiResponse) in
            guard let self = self else { return }
            if let product = apiResponse.toObject(Product.self) {
                self.product = product
                self.calculateSizeAndColorHeight()
                self.productCollectionView.reloadData()
            }
        }, onFailure: { (apiError) in
            
        }) {
            
        }
    }
    
    func getSuggestProduct() {
        let params = ["pageNumber": currentPage, "pageSize": AppConfig.defaultProductPerPage]
        let endPoint = ProductEndPoint.getSuggestProduct(parameters: params)
        
        if !isLoadMore {
            isRequestingAPI = true
        }
        
        APIService.request(endPoint: endPoint, onSuccess: { [weak self] (apiResponse) in
            guard let self = self else { return }
            let products = apiResponse.toArray([Product.self])
            self.suggestProduct.append(contentsOf: products)
            self.isLoadMore = false
            self.isRequestingAPI = false
            self.productCollectionView.reloadData()
        }, onFailure: { (apiError) in
            
        }) {
            
        }
    }
    
    // MARK: - UIActions
    
    @objc private func tapOnBuyButton() {
        if !product.isSelectSize {
            AlertManager.shared.show(message: TextManager.errorDontSelectSize.localized())
            return
        }
        
        if !product.isSelectColor {
            AlertManager.shared.show(message: TextManager.errorDontSelectColor.localized())
            return
        }
        
        CartManager.shared.addProductToCart(product, completionHandler: { [weak self] in
            guard let self = self else { return }
            self.product.selectedColor = nil
            self.product.selectedSize = nil
            self.productCollectionView.reloadSections(IndexSet(integer: SectionType.size.rawValue))
            self.productCollectionView.reloadSections(IndexSet(integer: SectionType.color.rawValue))
            
            NotificationCenter.default.post(name: Notification.Name.reloadCartBadgeNumber, object: nil)
            AlertManager.shared.showToast(message: TextManager.addToCartSuccess.localized())
        }, error: {
            AlertManager.shared.showToast()
        })
    }
    
    @objc private func tapOnShareExternalButton() {
        AlertManager.shared.show(TextManager.shareProduct.localized(), message: TextManager.guideShareProduct, acceptMessage: TextManager.IUnderstand.localized()) {
            let urlString = "https://tiki.vn/dien-thoai-iphone-6s-plus-32gb-vn-a-hang-chinh-hang-p1823081.html?src=recently-viewed&spid=1823109"
            let viewController = UIActivityViewController(activityItems: [urlString], applicationActivities: [])
            self.present(viewController, animated: true)
        }
    }
    
    // MARK: - Helper methods
    
    private func calculateSizeAndColorHeight() {
        let layout = TagsStyleFlowLayout()
        layout.cellsPadding = ItemsPadding(horizontal: 15, vertical: 12)
        let cellWidth = ScreenSize.SCREEN_WIDTH - 2 * Dimension.shared.normalMargin
        self.sizeCellHeight = layout.caculateHeight(collectionViewWidth: cellWidth,
                                                    datas: product.sizeModels)
        self.colorCellHeight = layout.caculateHeight(collectionViewWidth: cellWidth,
                                                     datas: product.colorModels)
    }
    
    // MARK: - Layouts
    
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

// MARK: - UICollectionViewDelegate

extension ProductDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let sectionType = SectionType(rawValue: indexPath.section) else { return }
        
        switch sectionType {
        case .comment:
            let commentVC = ProductCommentViewController()
            commentVC.delegate = self
            commentVC.configData(comments: product.comments)
            commentVC.configData(productId: product.id)
            navigationController?.pushViewController(commentVC, animated: true)
            break
        case .shopInfo:
            AppRouter.pushToShopHome(product.shopId ?? 0)
            break
        default:
            break
        }
    }
}

// MARK: - UICollectionViewDataSource

extension ProductDetailViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SectionType.numberSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sectionType = SectionType(rawValue: section) else { return 0 }
        switch sectionType {
        case .infomation, .size, .color, .description, .shopInfo, .recommend:
            return 1
        case .comment:
            if (product.comments.isEmpty) {
                return 1
            } else {
                return product.numberCommentInProductDetail
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sectionType = SectionType(rawValue: indexPath.section) else {
            return UICollectionViewCell()
        }
        
        switch sectionType {
        case .infomation:
            let infoCell: ProductDetailInfoCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            infoCell.configData(product)
            infoCell.delegate = self
            return infoCell
            
        case .size:
            let sizeCell: ProductDetailSizeCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            sizeCell.configData(product.sizeModels, type: .size, selectedData: product.selectedSize)
            sizeCell.delegate = self
            return sizeCell
            
        case .color:
            let colorCell: ProductDetailSizeCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            colorCell.configData(product.colorModels, type: .color, selectedData: product.selectedColor)
            colorCell.delegate = self
            return colorCell
            
        case .description:
            let desciptionCell: ProductDetailDesciptionCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            desciptionCell.configData(product, canExpand: canExpendDescriptionCell, isExpand: isExpandDescriptionCell)
            desciptionCell.delegate = self
            return desciptionCell
            
        case .shopInfo:
            let shopInfoCell: ProductDetailShopInfoCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            shopInfoCell.configData(product)
            return shopInfoCell
            
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
            let recommendCell: ProductDetailRecommendCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            if !isRequestingAPI {
                recommendCell.configData(suggestProduct)
            }
            recommendCell.delegate = self
            return recommendCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard let sectionType = SectionType(rawValue: indexPath.section) else {
            return UICollectionReusableView()
        }
        
        if kind == UICollectionView.elementKindSectionHeader {
            let header: TitleCollectionViewHeaderCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)
            header.title = sectionType.title
            return header
        } else {
            let footer: GrayCollectionViewFooterCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)
            return footer
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProductDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let sectionType = SectionType(rawValue: indexPath.section) else {
            return .zero
        }
        
        switch sectionType {
        case .infomation:
            if let productInfoCellHeight = productInfoCellHeight {
                return CGSize(width: collectionView.frame.width, height: productInfoCellHeight)
            } else {
                productInfoCellHeight = ProductDetailInfoCollectionViewCell.estimateHeight(product)
                return CGSize(width: collectionView.frame.width, height: productInfoCellHeight ?? 0)
            }
            
        case .size:
            if let height = sizeCellHeight {
                return CGSize(width: collectionView.frame.width, height: height)
            } else {
                return CGSize(width: collectionView.frame.width, height: 0)
            }
            
        case .color:
            if let height = colorCellHeight {
                return CGSize(width: collectionView.frame.width, height: height)
            } else {
                return CGSize(width: collectionView.frame.width, height: 0)
            }
        
        case .description:
            if canExpendDescriptionCell && !isExpandDescriptionCell {
                return CGSize(width: collectionView.frame.width, height: colapseDescriptionCellHeight)
            }
            
            if let desciptionCellHeight = desciptionCellHeight {
                return CGSize(width: collectionView.frame.width, height: desciptionCellHeight)
            } else {
                desciptionCellHeight = ProductDetailDesciptionCollectionViewCell.estimateHeight(product)
                return CGSize(width: collectionView.frame.width, height: desciptionCellHeight ?? 0)
            }
            
        case .shopInfo:
            return CGSize(width: collectionView.frame.width, height: 100)
            
        case .comment:
            if product.comments.isEmpty {
                return CGSize(width: collectionView.frame.width, height: 140)
            } else {
                guard let comment = product.commentInProductDetail[safe: indexPath.row] else { return .zero }
                return CGSize(width: collectionView.frame.width,
                              height: ProductParentCommentCollectionViewCell.estimateHeight(comment))
            }
            
        case .recommend:
            return CGSize(width: collectionView.frame.width,
                          height: BaseProductView.guestUserSize.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let sectionType = SectionType(rawValue: section) else {
            return .zero
        }
        return sectionType.sizeForHeader()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: 10)
    }
}

// MARK: - ProductDetailSizeCollectionViewCellDelegate

extension ProductDetailViewController: ProductDetailSizeCollectionViewCellDelegate {
    func didSelectSize(_ size: String) {
        if product.selectedSize == size {
            product.selectedSize = nil
        } else {
            product.selectedSize = size
        }
        
        productCollectionView.reloadSections(IndexSet(integer: SectionType.size.rawValue))
    }
    
    func didSelectColor(_ color: String) {
        if product.selectedColor == color {
            product.selectedColor = nil
        } else {
            product.selectedColor = color
        }
        
        productCollectionView.reloadSections(IndexSet(integer: SectionType.color.rawValue))
    }
}

// MARK: - ProductDetailRecommendCollectionViewCellDelegate

extension ProductDetailViewController: ProductDetailRecommendCollectionViewCellDelegate {
    func loadMoreSuggestProducts() {
        if !isLoadMore {
            isLoadMore = true
            currentPage += 1
            getSuggestProduct()
        }
    }
}

// MARK: - ProductCommentViewControllerDelegate

extension ProductDetailViewController: ProductCommentViewControllerDelegate {
    func updateNewComments(_ comments: [Comment]) {
        product.comments = comments
        productCollectionView.reloadData()
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

// MARK: - ProductDetailInfoCollectionViewCellDelegate

extension ProductDetailViewController: ProductDetailInfoCollectionViewCellDelegate {
    func didSelectGetLink() {
        AlertManager.shared.showToast(message: TextManager.featureInDev.localized())
    }
    
    func didSelectLike() {
        let endPoint = ProductEndPoint.likeProduct(parameters: ["ProductId": product.id ?? -1])
        APIService.request(endPoint: endPoint, onSuccess: { [weak self] (apiResponse) in
            guard let self = self else { return }
            self.product.userLike = !self.product.userLike
            self.productCollectionView.reloadData()
        }, onFailure: { (apiError) in
            AlertManager.shared.showToast()
        }) {
            AlertManager.shared.showToast()
        }
    }
    
    func didSelectShareInternal() {
        AlertManager.shared.showToast(message: TextManager.featureInDev.localized())
    }
    
    func didSelectFolow() {
        let endPoint = ProductEndPoint.folowProduct(parameters: ["ProductId": product.id ?? -1])
        APIService.request(endPoint: endPoint, onSuccess: { [weak self] (apiResponse) in
            guard let self = self else { return }
            self.product.userFollow = !self.product.userFollow
            self.productCollectionView.reloadData()
            }, onFailure: { (apiError) in
                AlertManager.shared.showToast()
        }) {
            AlertManager.shared.showToast()
        }
    }
}

// MARK: - ProductDetailDesciptionCollectionViewCellDelegate

extension ProductDetailViewController: ProductDetailDesciptionCollectionViewCellDelegate {
    func didSelectSeeMore() {
        isExpandDescriptionCell = !isExpandDescriptionCell
        productCollectionView.reloadSections(IndexSet(integer: SectionType.description.rawValue))
    }
}
