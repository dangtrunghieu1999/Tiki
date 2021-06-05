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

    static func numberOfSections() -> Int {
        return 6
    }
}

class OrderInfoViewController: BaseViewController {
    
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
    
    private var products: [Product]? = []

    private var estimateHeight: CGFloat = 0.0
    
    convenience init(products: [Product]) {
        self.init()
        self.products = products
        self.estimateHeight = CGFloat(products.count) * 100.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = TextManager.confirmOrder
        layoutCollectionView()
        registerCell()
    }
    
    private func registerCell() {
        self.collectionView.registerReusableCell(AddressCollectionViewCell.self)
        self.collectionView.registerReusableCell(FooterCollectionViewCell.self)
        self.collectionView.registerReusableCell(TransportCollectionViewCell.self)
        self.collectionView.registerReusableCell(OrderCollectionViewCell.self)
        self.collectionView.registerReusableCell(PaymentCollectionViewCell.self)
    }
    
    
    private func layoutCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            if #available(iOS 11, *) {
                make.top.equalTo(view.safeAreaLayoutGuide)
                make.bottom.equalTo(view.snp.bottomMargin)
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom)
                make.bottom.equalTo(bottomLayoutGuide.snp.top)
            }
        }
    }
}

extension OrderInfoViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width
        let type  = OrderSection(rawValue: indexPath.section)
        switch type {
        case .section1, .section2:
            return CGSize(width: width, height: 8)
        case .address:
            return CGSize(width: width, height: 120)
        case .transport:
            return CGSize(width: width, height: 250)
        case .orderInfo:
            return CGSize(width: width,
                          height: estimateHeight + 100)
        case .payment:
            return CGSize(width: width, height: 200)
        default:
            return CGSize(width: width, height: 0)
        }
    }
}

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
             .section2:
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
        default:
            return UICollectionViewCell()
        }
    }
}

extension OrderInfoViewController: UICollectionViewDelegate {
    
}

extension OrderInfoViewController: AddressCollectionViewCellDelegate {
    func didSelectAddress() {
        AppRouter.pushToDeliveryAddressVC()
    }
}

