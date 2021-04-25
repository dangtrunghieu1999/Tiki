//
//  ZTabBarViewController.swift
//  ZoZoApp
//
//  Created by MACOS on 6/8/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class ZTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        tabBar.tintColor = UIColor.background
        let insets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        let newsFeedNavigationVC = UINavigationController(rootViewController: FeedViewController())
        newsFeedNavigationVC.tabBarItem = UITabBarItem(title: nil, image: ImageManager.logoTransparentTabbar, tag: 0)
        newsFeedNavigationVC.tabBarItem.imageInsets = insets
        
        let shoppingNavigationVC = UINavigationController(rootViewController: ShoppingViewController(pageType: .shopping))
        shoppingNavigationVC.tabBarItem = UITabBarItem(title: nil, image: ImageManager.shopping, tag: 1)
        shoppingNavigationVC.tabBarItem.imageInsets = insets
        
        let earnMoneyNavigationVC = UINavigationController(rootViewController: ShoppingViewController(pageType: .earnMoney))
        earnMoneyNavigationVC.tabBarItem = UITabBarItem(title: nil, image: ImageManager.makeMoney, tag: 2)
        earnMoneyNavigationVC.tabBarItem.imageInsets = insets
        
        let notificationNavigationVC = UINavigationController(rootViewController: NotificationsViewController())
        notificationNavigationVC.tabBarItem = UITabBarItem(title: nil, image: ImageManager.notifications, tag:3)
        notificationNavigationVC.tabBarItem.imageInsets = insets
        
        let settingNavigationVC = UINavigationController(rootViewController: MenuViewController())
        settingNavigationVC.tabBarItem = UITabBarItem(title: nil, image: ImageManager.setting, tag: 4)
        settingNavigationVC.tabBarItem.imageInsets = insets
        
        viewControllers = [newsFeedNavigationVC, shoppingNavigationVC, earnMoneyNavigationVC,
                           notificationNavigationVC, settingNavigationVC]
        
    }

}
