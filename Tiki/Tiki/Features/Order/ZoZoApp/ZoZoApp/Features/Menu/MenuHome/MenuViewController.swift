//
//  MenuViewController.swift
//  ZoZoApp
//
//  Created by MACOS on 6/8/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class MenuViewController: BaseViewController {
    
    // MARK: - UI Elements
    
    fileprivate lazy var settingCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        collectionView.registerReusableCell(MenuCollectionViewCell.self)
        return collectionView
    }()
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let menuButton = UIButton(type: .custom)
        menuButton.frame = CGRect(x: 0, y: 0, width: 80, height: 46)
        menuButton.setTitle("Menu", for: .normal)
        menuButton.titleLabel?.font = UIFont.systemFont(ofSize: FontSize.headline.rawValue, weight: .bold)
        let menuBarItem = UIBarButtonItem(customView: menuButton)
        navigationItem.leftBarButtonItem = menuBarItem
        
        let searchItemTarget: Target = (self, #selector(touchUpInRightBarButtonItem))
        addBarItems(with: [BarButtonItemModel(ImageManager.searchGray, searchItemTarget)], type: .right)
        
        layoutSettingCollectionView()
    }
    
    // MARK: - Helper methods
    
    fileprivate func processLogout() {
        AlertManager.shared.showConfirmMessage(mesage: TextManager.statusLogOut.localized())
        { (action) in
            UserManager.logout()
            guard let window = UIApplication.shared.keyWindow else { return }
            window.rootViewController = UINavigationController(rootViewController: SignInViewController())
        }
    }
    
    override func touchUpInRightBarButtonItem() {
        let searchGlobalVC = SearchGlobalViewController()
        navigationController?.pushViewController(searchGlobalVC, animated: false)
    }
    
    // MARK: - Setup Layouts
    
    private func layoutSettingCollectionView(){
        view.addSubview(settingCollectionView)
        settingCollectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MenuViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: settingCollectionView.frame.width, height: 50)
    }
}

// MARK: - UICollectionViewDelegate

extension MenuViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let settingOption = MenuOption(rawValue: indexPath.row) else { return }
        switch settingOption {
        case .shopping:
            let viewController = ShoppingViewController(pageType: .shopping)
            navigationController?.pushViewController(viewController, animated: true)
            break
        case .earnMoney:
            let viewController = ShoppingViewController(pageType: .earnMoney)
            navigationController?.pushViewController(viewController, animated: true)
            break
        case .myStall:
            let viewController = ListShopViewController()
            navigationController?.pushViewController(viewController,animated: true)
            break
        case .orderSetting:
            let viewController = OrderSettingViewController()
            navigationController?.pushViewController(viewController,animated: true)
            break
        case .financial:
            let viewController = FinacialManagerViewController()
            navigationController?.pushViewController(viewController,animated: true)
            break
        case .promo:
            let viewController = PromoViewController()
            navigationController?.pushViewController(viewController,animated: true)
            break
        case .report:
            let viewController = ReportViewController()
            navigationController?.pushViewController(viewController,animated: true)
            break
        case .following:
            let viewController = FollowingViewController()
            navigationController?.pushViewController(viewController,animated: true)
            break
        case .guideOrder:
            guard let url = URL(string: "https://careers.zalo.me/") else { return }
            AppRouter.pushToGuideOrderWebView(config: url)
            break
        case .guideEarnMoney:
            guard let url = URL(string: "https://careers.zalo.me/") else { return }
            AppRouter.pushToGuideEranMoneyWebView(config: url)
            break
        case .settingAndPrivacy:
            let viewController = SettingAndPrivacyViewController()
            navigationController?.pushViewController(viewController,animated: true)
            break
        case .profileMenu:
            let viewController = UserProfileViewController()
            navigationController?.pushViewController(viewController, animated: true)
        case .logOut:
            processLogout()
            break
        }
    }
}

// MARK: - UICollectionViewDataSource

extension MenuViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MenuOption.numberSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MenuCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        let settingOption = MenuOption(rawValue: indexPath.row)
        cell.configSetting(setting: settingOption)
        return cell
    }
}
