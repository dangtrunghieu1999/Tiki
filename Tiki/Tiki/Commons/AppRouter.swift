//
//  AppRouter.swift
//  ZoZoApp
//
//  Created by MACOS on 6/1/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit
import Photos

class AppRouter: NSObject {
    
    class func presentViewToSignIn(viewController: UIViewController) {
        let vc = SignInViewController()
        let nvc = UINavigationController(rootViewController: vc)
        viewController.present(nvc, animated: true, completion: nil)
    }
    
    class func presentViewParameterProduct(viewController: UIViewController, values: [String]) {
        let vc = ProductParameterViewController()
        vc.configValueTitle(values: values)
        let nvc = UINavigationController(rootViewController: vc)
        viewController.present(nvc, animated: true, completion: nil)
    }
    
    class func pushToPasswordVC() {
        let vc = PasswordViewController()
        UIViewController.topViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    class func pushToWebView(config byURL: URL) {
        let webVC = WebViewViewController()
        webVC.configWebView(by: byURL)
        UIViewController.topViewController()?.navigationController?.pushViewController(webVC, animated: true)
    }

    class func pushToGuideEranMoneyWebView(config byURL: URL) {
        
    }
    
    class func pushToAvatarCropperVC(image: UIImage,
                                     completion: @escaping ImageCropperCompletion,
                                     dismis: @escaping ImageCropperDismiss) {

    }
    
    class func pushToCropCoverImageVC(image: UIImage,
                                      delegate: UpdateCoverImageViewControllerDelegate?,
                                      avatarURL: String?,
                                      displayName: String) {

    }
    
    class func presentToImagePicker(pickerDelegate: ImagePickerControllerDelegate?,
                                    limitImage: Int = 1,
                                    selecedAssets: [PHAsset] = []) {

    }
    
    class func presentPopupImage(urls: [String],
                                 selectedIndexPath: IndexPath = IndexPath(row: 0, section: 0),
                                 productName: String = "") {
        
    }
    
    class func pushToVerifyOTPVC(with userName: String, isActiveAcc: Bool = false) {
        let viewController = VerifyOTPViewController()
        viewController.userName = userName
        viewController.isActiveAccount = isActiveAcc
        UIViewController.topNavigationVC?.pushViewController(viewController, animated: true)
    }
    
    class func pushToProductDetail(_ product: Product) {
        let viewController = ProductDetailViewController()
        viewController.configData(product)
        UINavigationController.topNavigationVC?.pushViewController(viewController, animated: true)
    }
    
    class func pushToShopHome(_ shopId: Int) {
        let viewController = ShopHomeViewController()
//        viewController.loadShop(by: shopId)
        viewController.requestLoadShop()
        UINavigationController.topNavigationVC?.pushViewController(viewController, animated: true)
    }
    
    class func pushToUserProfile(_ userId: String) {
    }
    
    class func pushToCart() {
        let viewController = CartViewController()
        UINavigationController.topNavigationVC?.pushViewController(viewController, animated: true)
    }
    
    class func pushToChatHistory() {

    }
    
    class func pushToChatDetail(partnerId: String) {

    }
    
    class func pushToCategory(categoryId: Int, categoryName: String) {

    }
    
    class func pushToNotificationVC() {
        let viewController = NotificationViewController()
        UINavigationController.topNavigationVC?.pushViewController(viewController, animated: true)
    }
    


}
