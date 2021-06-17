//
//  PersonalViewController.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 3/13/21.
//

import UIKit

class PersonalViewController: BaseViewController {
    
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
        collectionView.registerReusableCell(PersonCollectionViewCell.self)
        collectionView
            .registerReusableSupplementaryView(PersonalHeaderCollectionReusableView.self,
             forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        return collectionView
    }()
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutPersonalCollectionView()
        handleReloadDataNotification()
    }
    
    // MARK: - Helper Method
    
    override func setupNavigationBar() {
        navigationItem.title = TextManager.person
        self.tabBarController?.tabBar.isTranslucent = false
    }
    
    func handleReloadDataNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadCollectionView),
                                               name: Notification.Name.reloadDataCollectionView,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: Notification.Name.reloadDataCollectionView,
                                                  object: nil)
    }
    
    @objc func reloadCollectionView() {
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
            if UserManager.isLoggedIn() {
                header.configData(true, title: UserManager.user?.fullName)
            } else {
                header.configData(false, title: TextManager.welcomeSignInUp.localized())
            }
            header.delegate = self
            return header
        } else {
            return UICollectionReusableView()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PersonalViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width
        let type = PersonalType(rawValue: indexPath.row)
        switch type {
        case .section1, .section2:
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

// MARK: - UICollectionViewDelegate

extension PersonalViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        guard let type = PersonalType(rawValue: indexPath.row) else { return }
        switch type {
        case .mananger, .recive, .transport, .success, .canccel:
            let vc = ManagerOrderViewController()
            vc.numberIndex = indexPath.row - 1
            self.handleWhenLoginPushView(vc)
        case .address:
            let vc = DeliveryAddressViewController()
            self.handleWhenLoginPushView(vc)
        case .bought:
            let vc = ProductedBuyViewController()
            vc.isBought = true
            self.handleWhenLoginPushView(vc)
        case .liked:
            let vc = ProductedBuyViewController()
            vc.isBought = false
            self.handleWhenLoginPushView(vc)
        case .rating:
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
            AppRouter.pushViewToSignIn(viewController: self)
        }
    }
}

extension PersonalViewController: PersonalHeaderCollectionViewDelegate {
    func tapOnSignIn() {
        let vc = ProfileViewController()
        self.handleWhenLoginPushView(vc)
    }
}
