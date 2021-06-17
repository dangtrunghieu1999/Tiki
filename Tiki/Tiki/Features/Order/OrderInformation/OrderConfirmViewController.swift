//
//  OrderConfirmViewController.swift
//  Tiki
//
//  Created by Bee_MacPro on 15/06/2021.
//

import UIKit

enum OrderConfirm: Int {
    case info     = 0
    case section1 = 1
    case address  = 2
    case section2 = 3
    case bill     = 4
    
    static func numberOfItems() -> Int {
        return 5
    }
}

class OrderConfirmViewController: BaseViewController {
    
    
    var estimateHeight: CGFloat = 0.0
    var products: [Product]     = []
    
    // MARK: - UI Elements
    
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
        button.layer.cornerRadius = dimension.cornerRadiusSmall
        button.addTarget(self, action: #selector(tapOnOrderSubbmit), for: .touchUpInside)
        return button
    }()
    
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
        collectionView.registerReusableCell(BillerCollectionViewCell.self)
        collectionView.registerReusableCell(AddressCollectionViewCell.self)
        collectionView.registerReusableCell(FooterCollectionViewCell.self)
        collectionView.registerReusableCell(OrderConfirmCollectionViewCell.self)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = TextManager.confirmOrder
        layoutBottomView()
        layoutBuyButton()
        layoutSumMoneyTitleLabel()
        layoutTotalMoneyTitleLabel()
        layoutCollectionView()
    }
    
    @objc private func tapOnOrderSubbmit() {
        let vc = OrderCompleteViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
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

extension OrderConfirmViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let type  = OrderConfirm(rawValue: indexPath.row)
        switch type {
        case .info:
            return CGSize(width: width,
                          height: estimateHeight + 300)
        case .address:
            return CGSize(width: width, height: 120)
        case .section1, .section2:
            return CGSize(width: width, height: 8)
        case .bill:
            return CGSize(width: width, height: 200)
        default:
            return CGSize(width: width, height: 0)
        }
    }
}


extension OrderConfirmViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return OrderConfirm.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = OrderConfirm(rawValue: indexPath.row)
        switch type {
        case .info:
            let cell: OrderConfirmCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.products = products
            return cell
        case .address:
            let cell: AddressCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.hiddenButton = true
            return cell
        case .section1, .section2:
            let cell: FooterCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            return cell
        case .bill:
            let cell: BillerCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}
