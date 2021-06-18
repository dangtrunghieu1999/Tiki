//
//  AbstractOrderViewController.swift
//  Tiki
//
//  Created by Bee_MacPro on 18/06/2021.
//

import UIKit

class AbstractOrderViewController: BaseViewController {
    
    fileprivate lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.background
        return refreshControl
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing      = dimension.mediumMargin
        layout.minimumInteritemSpacing = 0
        let collectionView             = UICollectionView(frame: .zero,
                                                          collectionViewLayout: layout)
        collectionView.backgroundColor = .lightBackground
        collectionView.refreshControl  = refreshControl
        collectionView.frame           = view.bounds
        collectionView.dataSource      = self
        collectionView.delegate        = self
        collectionView.contentInset    = UIEdgeInsets(top: dimension.mediumMargin,
                                                      left: 0,
                                                      bottom: dimension.mediumMargin,
                                                      right: 0)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.registerReusableCell(OrderStatusCollectionViewCell.self)
        collectionView
            .registerReusableSupplementaryView(GrayCollectionViewFooterCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter)
        return collectionView
    }()

    private var orders: [Order] = []
    private(set) var status: OrderStatus = .all
    
    convenience init(status: OrderStatus) {
        self.init()
        self.status = status
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutCollectionView()
    }
    
    func reloadData(_ orders: [Order]) {
        self.orders = orders
        collectionView.reloadData()
        collectionView.dataSource = self
    }
    
    private func layoutCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            if #available(iOS 11, *) {
                make.bottom.equalTo(view.snp.bottomMargin)
                    .offset(-dimension.largeMargin_32)
            } else {
                make.bottom.equalTo(bottomLayoutGuide.snp.top)
                    .offset(-dimension.largeMargin_32)
            }
        }
    }
}

extension AbstractOrderViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ScreenSize.SCREEN_WIDTH, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: ScreenSize.SCREEN_WIDTH, height: 100)
    }
}


extension AbstractOrderViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return orders.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: OrderStatusCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        if !orders.isEmpty {
            cell.stopShimmering()
            cell.configCell(order: orders[indexPath.row])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let cell: GrayCollectionViewFooterCell =
                collectionView.dequeueReusableSupplementaryView(ofKind:
                UICollectionView.elementKindSectionFooter, for: indexPath)
            return cell
        } else {
            return UICollectionReusableView()
        }
    }
}
