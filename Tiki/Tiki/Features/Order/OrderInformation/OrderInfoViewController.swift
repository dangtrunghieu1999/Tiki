//
//  OrderInformationViewController.swift
//  ZoZoApp
//
//  Created by LAP12852 on 8/25/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

enum OrderSection: Int {
    case address      = 0
    case section1     = 1
    case transport    = 2
    case orderInfo    = 3
    case section2     = 4
    case payment      = 5
    case section3     = 6
    case bill         = 7

    static func numberOfSections() -> Int {
        return 8
    }
}

class OrderInfoViewController: BaseViewController {
    
    // MARK: - UI Elements
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor.separator
        collectionView.dataSource = self
        collectionView.delegate   = self
        return collectionView
    }()
    
    private let bottomView: BaseView = {
        let view = BaseView()
        view.addTopBorder(with: UIColor.separator, andWidth: 1)
        view.layer.masksToBounds = true
        return view
    }()
    
    fileprivate lazy var intoMoneyTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = TextManager.titleTotalMoney
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        return label
    }()
    
    fileprivate lazy var totalMoneyTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = CartManager.shared.totalMoney.currencyFormat
        label.font = UIFont.systemFont(ofSize: FontSize.body.rawValue)
        label.textColor = UIColor.primary
        return label
    }()
    
    private lazy var buyButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.buyNow, for: .normal)
        button.backgroundColor = UIColor.primary
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Dimension.shared.cornerRadiusSmall
        return button
    }()
    
    // MARK -  Variables
    
    private var products: [Product]?    = []
    private var estimateHeight: CGFloat = 0.0
    
    convenience init(products: [Product]) {
        self.init()
        self.products = products
        self.estimateHeight = CGFloat(products.count) * 100.0
    }
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = TextManager.confirmOrder
        layoutBottomView()
        layoutBuyButton()
        layoutSumMoneyTitleLabel()
        layoutTotalMoneyTitleLabel()
        layoutCollectionView()
        registerCell()
    }
    
    private func registerCell() {
        self.collectionView.registerReusableCell(AddressCollectionViewCell.self)
        self.collectionView.registerReusableCell(FooterCollectionViewCell.self)
        self.collectionView.registerReusableCell(TransportCollectionViewCell.self)
        self.collectionView.registerReusableCell(OrderCollectionViewCell.self)
        self.collectionView.registerReusableCell(PaymentCollectionViewCell.self)
        self.collectionView.registerReusableCell(BillerCollectionViewCell.self)
    }
    
    // MARK: - Layout
    
    private func layoutBottomView() {
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            if #available(iOS 11, *) {
                make.bottom
                    .equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom
                    .equalTo(bottomLayoutGuide.snp.top)
            }
            make.left.right.equalToSuperview()
            make.height.equalTo(120)
        }
    }
    
    private func layoutBuyButton() {
        bottomView.addSubview(buyButton)
        buyButton.snp.makeConstraints { (make) in
            make.right
                .equalToSuperview()
                .inset(dimension.normalMargin)
            make.height
                .equalTo(dimension.largeHeightButton)
            make.width
                .equalTo(150)
            make.top
                .equalToSuperview()
                .offset(dimension.normalMargin)
        }
    }
    
    private func layoutSumMoneyTitleLabel() {
        bottomView.addSubview(intoMoneyTitleLabel)
        intoMoneyTitleLabel.snp.makeConstraints { (make) in
            make.left
                .equalToSuperview()
                .offset(dimension.normalMargin)
            make.top
                .equalToSuperview()
                .offset(dimension.normalMargin)
        }
    }
    
    private func layoutTotalMoneyTitleLabel() {
        bottomView.addSubview(totalMoneyTitleLabel)
        totalMoneyTitleLabel.snp.makeConstraints { (make) in
            make.left
                .equalTo(intoMoneyTitleLabel)
            make.top
                .equalTo(intoMoneyTitleLabel.snp.bottom)
                .offset(dimension.mediumMargin)
        }
    }
    
    private func layoutCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            if #available(iOS 11, *) {
                make.top.equalTo(view.safeAreaLayoutGuide)
                
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom)
            }
            make.bottom.equalTo(bottomView.snp.top)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension OrderInfoViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width
        let type  = OrderSection(rawValue: indexPath.section)
        switch type {
        case .section1, .section2, .section3:
            return CGSize(width: width, height: 8)
        case .address:
            return CGSize(width: width, height: 120)
        case .transport:
            return CGSize(width: width, height: 230)
        case .orderInfo:
            return CGSize(width: width,
                          height: estimateHeight + 120)
        case .payment:
            return CGSize(width: width, height: 100)
        case .bill:
            return CGSize(width: width, height: 200)
        default:
            return CGSize(width: width, height: 0)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension OrderInfoViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return OrderSection.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
       return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = OrderSection(rawValue: indexPath.section)
        switch type {
        case .section1,
             .section2,
             .section3:
            let cell: FooterCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            return cell
        case .address:
            let cell: AddressCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            return cell
        case .transport:
            let cell: TransportCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            return cell
        case .orderInfo:
            let cell: OrderCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.products = products ?? []
            return cell
        case .payment:
            let cell: PaymentCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            return cell
        case .bill:
            let cell: BillerCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

// MARK: - UICollectionViewDelegate
 
extension OrderInfoViewController: UICollectionViewDelegate {
    
}

// MARK: - AddressCollectionViewCellDelegate

extension OrderInfoViewController: AddressCollectionViewCellDelegate {
    func didSelectAddress() {
        AppRouter.pushToDeliveryAddressVC()
    }
}
