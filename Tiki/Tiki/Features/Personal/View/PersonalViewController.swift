//
//  PersonalViewController.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 3/13/21.
//

import UIKit

class PersonalViewController: BaseViewController {
    
    // MARK: - Variables
    
    fileprivate lazy var personalViewModel: PersonalViewModel = {
        let personal = PersonalViewModel()
        return personal
    }()
    
    // MARK: - UI Elements
    
    fileprivate lazy var personalCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = personalViewModel
        collectionView.dataSource = personalViewModel
        collectionView.backgroundColor = UIColor.separator
        return collectionView
    }()
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutPersonalCollectionView()
        registerCollectionView()
        personalViewModel.reloadData()
        personalViewModel.delegate = self
        navigationItem.title = TextManager.person
    }
    
    // MARK: - Helper Method
    
    func registerCollectionView() {
        self.personalCollectionView.registerReusableCell(PersonCollectionViewCell.self)
        self.personalCollectionView
            .registerReusableSupplementaryView(PersonalHeaderCollectionReusableView.self,
                                               forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
    }
    
    // MARK: - GET API
    
    // MARK: - Layout
    
    private func layoutPersonalCollectionView() {
        view.addSubview(personalCollectionView)
        personalCollectionView.snp.makeConstraints { (make) in
            if #available(iOS 11, *) {
                make.top.equalTo(view.safeAreaLayoutGuide)
                    .offset(Dimension.shared.smallMargin)
                make.bottom.equalTo(view.snp_bottomMargin)
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom)
                    .offset(Dimension.shared.smallMargin)
                make.bottom.equalTo(bottomLayoutGuide.snp.top)
            }
            make.left.right.equalToSuperview()
        }
    }
}

// MARK: - PersonalViewModelDelegate

extension PersonalViewController: PersonalViewModelDelegate {
    
    func reloadCollectionView() {
        self.personalCollectionView.reloadData()
    }
    
    func didTapOnCellRow(type: PersonalType) {
        switch type {
        case .managerOrder, .recive, .paymentAgain, .transport, .successOrder, .canccelOrder:
            let vc = ManagerOrderViewController()
            navigationController?.pushViewController(vc, animated: true)
        case .address:
            let vc = DeliveryAddressViewController()
            navigationController?.pushViewController(vc, animated: true)
        case .infoPayment:
            let vc = InfoPaymentViewController()
            navigationController?.pushViewController(vc, animated: true)
        case .productedBuy:
            let vc = ProductedBuyViewController()
            navigationController?.pushViewController(vc, animated: true)
        case .productedLove:
            let vc = ProductedLoveViewController()
            navigationController?.pushViewController(vc, animated: true)
        case .productRating:
            let vc = RaitingProductViewController()
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
    func didTapOnSignIn() {
        if UserManager.isLoggedIn() {
            AppRouter.pushViewToGetProfile(viewController: self)
        } else {
            AppRouter.presentViewToSignIn(viewController: self)
        }
    }    
}
