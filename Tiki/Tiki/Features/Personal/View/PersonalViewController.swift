//
//  PersonalViewController.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 3/13/21.
//

import UIKit

class PersonalViewController: BaseViewController {
    
    // MARK: - Variables
    
    // MARK: - UI Elements
    
    fileprivate lazy var personalCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor.separator
        collectionView.dataSource = self
        collectionView.delegate  = self
        return collectionView
    }()
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutPersonalCollectionView()
        registerCollectionView()
        navigationItem.title = TextManager.person
        self.tabBarController?.tabBar.isTranslucent = false
    }
    
    // MARK: - Helper Method
    
    func registerCollectionView() {
        self.personalCollectionView.registerReusableCell(PersonCollectionViewCell.self)
        self.personalCollectionView
            .registerReusableSupplementaryView(PersonalHeaderCollectionReusableView.self,
                                               forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
    }
    
    // MARK: - GET API
    
    func reloadCollectionView() {
        self.personalCollectionView.reloadData()
    }
    
    // MARK: - Layout
    
    private func layoutPersonalCollectionView() {
        view.addSubview(personalCollectionView)
        personalCollectionView.snp.makeConstraints { (make) in
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

// MARK: - PersonalViewModelDelegate

extension PersonalViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return PersonalType.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return PersonalType.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: PersonCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.configCell(personal: Personal.cellObject[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header: PersonalHeaderCollectionReusableView =
                collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)
            
            let fullName = UserManager.user?.fullName
            let title = fullName ?? TextManager.welcomeSignInUp
            header.configData(title: title)
            header.delegate = self
            return header
        } else {
            return UICollectionReusableView()
        }
    }
}

extension PersonalViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width
        let type = PersonalType(rawValue: indexPath.row)
        switch type {
        case .section1, .section2, .section3, .section4:
            return CGSize(width: width, height: 10)
        default:
            return CGSize(width: width, height: 50)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: 80.0)
    }
}

extension PersonalViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let type = Personal.cellObject[indexPath.row].cellType else { return }
        switch type {
        case .managerOrder, .recive, .paymentAgain, .transport, .successOrder, .canccelOrder:
            let vc = ManagerOrderViewController()
            self.handleWhenLoginPushView(vc)
        case .address:
            let vc = DeliveryAddressViewController()
            self.handleWhenLoginPushView(vc)
        case .infoPayment:
            let vc = InfoPaymentViewController()
            self.handleWhenLoginPushView(vc)
        case .productedBuy:
            let vc = ProductedBuyViewController()
            vc.isBought = true
            self.handleWhenLoginPushView(vc)
        case .productedLove:
            let vc = ProductedBuyViewController()
            vc.isBought = false
            self.handleWhenLoginPushView(vc)
        case .productRating:
            let vc = RaitingProductViewController()
            self.handleWhenLoginPushView(vc)
        default:
            break
        }
    }
    
    func handleWhenLoginPushView(_ vc: UIViewController) {
        if UserManager.isLoggedIn() {
            navigationController?.pushViewController(vc, animated: true)
        } else {
            AppRouter.presentViewToSignIn(viewController: self)
        }
    }
}

extension PersonalViewController: PersonalHeaderCollectionViewDelegate {
    func tapOnSignIn() {
        if UserManager.isLoggedIn() {
            let vc = ProfileViewController()
            vc.delegate = self
           self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = SignInViewController()
            vc.delegate = self
            let nvc = UINavigationController(rootViewController: vc)
            self.present(nvc, animated: true, completion: nil)
        }
    }
}

extension PersonalViewController: SignInViewControllerDelegate {
    func reloadUserInfo() {
        self.reloadCollectionView()
    }
}

extension PersonalViewController: ProfileViewControllerDelegate {
    func handleLogoutSuccess() {
        self.reloadCollectionView()
    }
}
