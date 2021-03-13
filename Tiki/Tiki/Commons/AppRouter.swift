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

    }
    
    class func pushToProductDetail(_ product: Product) {

    }
    
    class func pushToShopHome(_ shopId: Int) {

    }
    
    class func pushToUserProfile(_ userId: String) {
    }
    
    class func pushToCart() {

    }
    
    class func pushToChatHistory() {

    }
    
    class func pushToChatDetail(partnerId: String) {

    }
    
    class func pushToCategory(categoryId: Int, categoryName: String) {

    }
    

}
