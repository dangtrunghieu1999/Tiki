//
//  AppDelegate.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 2/28/21.
//

import UIKit
import SDWebImage
import SnapKit
import IGListKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let attributed = [NSAttributedString.Key.foregroundColor: UIColor.white,
                          NSAttributedString.Key.font: UIFont.systemFont(ofSize: FontSize.body.rawValue)]
        UINavigationBar.appearance().titleTextAttributes = attributed
        UINavigationBar.appearance().barTintColor = UIColor.background
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().barStyle = .blackOpaque
        
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
//        window?.rootViewController = TKTabBarViewController()
        window?.rootViewController = UINavigationController(rootViewController: ProfileViewController())
        return true
    }
}

