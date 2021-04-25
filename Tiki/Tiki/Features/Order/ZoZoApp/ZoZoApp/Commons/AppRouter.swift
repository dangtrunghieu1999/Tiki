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
    class func pushToWebView(config byURL: URL) {
        let webVC = WebViewViewController()
        webVC.configWebView(by: byURL)
        UIViewController.topViewController()?.navigationController?.pushViewController(webVC, animated: true)
    }
    
    class func pushToGuideOrderWebView(config byURL: URL) {
        let webVC = GuideOrderWebViewViewController()
        webVC.configWebView(by: byURL)
        UIViewController.topViewController()?.navigationController?.pushViewController(webVC, animated: true)
    }
    
    class func pushToGuideEranMoneyWebView(config byURL: URL) {
        let webVC = GuiderEarnMoneyWebViewViewController()
        webVC.configWebView(by: byURL)
        UIViewController.topViewController()?.navigationController?.pushViewController(webVC, animated: true)
    }
    
    class func pushToAvatarCropperVC(image: UIImage,
                                     completion: @escaping ImageCropperCompletion,
                                     dismis: @escaping ImageCropperDismiss) {
        let config = ImageCropperConfiguration(with: image, and: .circle)
        let viewController = ImageCropperViewController.initialize(with: config,
                                                                   completionHandler: completion,
                                                                   dismiss: dismis)
        UIViewController.topNavigationVC?.pushViewController(viewController, animated: true)
    }
    
    class func pushToCropCoverImageVC(image: UIImage,
                                      delegate: UpdateCoverImageViewControllerDelegate?,
                                      avatarURL: String?,
                                      displayName: String) {
        
        let viewController = UpdateCoverViewController()
        viewController.setImageToScrop(image: image)
        viewController.setProfileInfo(avatarURL: avatarURL, displayName: displayName)
        viewController.delegate = delegate
        UIViewController.topNavigationVC?.pushViewController(viewController, animated: true)
    }
    
    class func presentToImagePicker(pickerDelegate: ImagePickerControllerDelegate?,
                                    limitImage: Int = 1,
                                    selecedAssets: [PHAsset] = []) {
        var parameters = ImagePickerParameters()
        parameters.navigationBarTintColor = UIColor.white
        parameters.navigationBarTitleTintColor = UIColor.white
        parameters.photoAlbumsNavigationBarShadowColor = UIColor.clear
        parameters.allowedSelections = .limit(to: limitImage)
        let viewController = ImagePickerController.init(selectedAssets: selecedAssets, configuration: parameters)
        viewController.delegate = pickerDelegate
        UIViewController.topViewController()?.present(viewController, animated: true, completion: nil)
    }
    
    class func presentPopupImage(urls: [String],
                                 selectedIndexPath: IndexPath = IndexPath(row: 0, section: 0),
                                 productName: String = "") {
        
        let storyboard = UIStoryboard(name: "PopUpSlideImage", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "PopUpSlideImageController") as? PopUpSlideImageController else {
            return
        }
        UIViewController.topViewController()?.present(viewController, animated: true, completion: nil)
        viewController.setupData(selectedIndexPath: selectedIndexPath, urls: urls, productName: productName)
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
        viewController.loadShop(by: shopId)
        UINavigationController.topNavigationVC?.pushViewController(viewController, animated: true)
    }
    
    class func pushToUserProfile(_ userId: String) {
        let viewController = UserProfileViewController()
        UINavigationController.topNavigationVC?.pushViewController(viewController, animated: true)
    }
    
    class func pushToCart() {
        let viewController = CartViewController()
        UINavigationController.topNavigationVC?.pushViewController(viewController, animated: true)
    }
    
    class func pushToChatHistory() {
        let viewController = ChatHistoryViewController()
        UINavigationController.topNavigationVC?.pushViewController(viewController, animated: true)
    }
    
    class func pushToChatDetail(partnerId: String) {
        let viewController = ChatDetailViewController()
        UINavigationController.topNavigationVC?.pushViewController(viewController, animated: true)
    }
    
    class func pushToCategory(categoryId: Int, categoryName: String) {
        let viewController = ProductListViewController(type: .productCategory,
                                                       addtionalTitle: categoryName)
        viewController.categoryId = categoryId
        UINavigationController.topNavigationVC?.pushViewController(viewController, animated: true)
    }
    
    class func pushToPostFeed(_ postFeedType: PostFeedDetailViewController.PostFeedType) {
        let viewController = PostFeedDetailViewController()
        UINavigationController.topNavigationVC?.pushViewController(viewController, animated: true)
        viewController.configData(postFeedType: postFeedType)
    }
}
