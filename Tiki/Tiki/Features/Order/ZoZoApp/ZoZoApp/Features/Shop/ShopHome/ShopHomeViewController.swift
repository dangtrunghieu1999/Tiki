//
//  ShopHomeViewController.swift
//  ZoZoApp
//
//  Created by MACOS on 6/9/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit
import Photos

protocol ShopHomeViewControllerDelegate: class {
    func didUpdateInfoSuccess()
}

// MARK: -

class ShopHomeViewController: HeaderedCAPSPageMenuViewController {
    
    // MARK: - Helper Type
    
    enum ImageType {
        case avatar
        case cover
    }
    
    // MARK: - Variables
    
    weak var shopInfoDelegate: ShopHomeViewControllerDelegate?
    
    fileprivate var isSelectAvatar = false
    fileprivate var isSelectBackground = false
    fileprivate var shop = Shop()
    fileprivate var viewModel = ShopHomeViewModel()
    fileprivate let stallDetailVC = ShopHomeStallDetailViewController()
    
    private lazy var viewControllerFrame = CGRect(x: 0,
                                                  y: 0,
                                                  width: view.bounds.width,
                                                  height: view.bounds.height)
    
    var parameters: [CAPSPageMenuOption] = [
        .centerMenuItems(true),
        .scrollMenuBackgroundColor(UIColor.scrollMenu),
        .selectionIndicatorColor(UIColor.clear),
        .selectedMenuItemLabelColor(UIColor.bodyText),
        .menuItemFont(UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .medium)),
        .menuHeight(42)
    ]
    
    // MARK: - UI Elements
    
    private lazy var profileView: ShopProfileHeaderView = {
        let view = ShopProfileHeaderView()
        view.delegate = self
        view.shopHeaderDelegate = self
        return view
    }()
    
    fileprivate var subPageControllers: [UIViewController] = []
    
    // MARK: - LifeCycles
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addBackButtonIfNeeded()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBarTitleColor = UIColor.white.withAlphaComponent(0)
        headerView = profileView
    }
    
    // MARK: - Public methods
    
    func setShopInfo(_ shop: Shop) {
        self.shop = shop
        navigationItem.title = shop.name
        profileView.configShop(by: shop)
        
        if shop.isOwner {
            profileView.stopShimmering()
            addShopOwnerChildsVC()
        } else {
            loadShopRole()
        }
    }
    
    func loadShop(by shopId: Int) {
        profileView.startShimmering()
        
        let endPoint = ShopEndPoint.getShopById(params: ["id": shopId])
        APIService.request(endPoint: endPoint, onSuccess: { [weak self] (apiResponse) in
            guard let self = self else { return }
            if let shop = apiResponse.toObject(Shop.self) {
                self.setShopInfo(shop)
            } else {
                AlertManager.shared.showToast()
            }
        }, onFailure: { (apiError) in
            AlertManager.shared.showToast()
        }) {
            AlertManager.shared.showToast()
        }
    }
    
    // MARK: - Helper methods
    
    fileprivate func loadShopRole() {
        ShopRoleManager.shared.getShopRolesOfCurrentUser(shopId: self.shop.id ?? 0, onSuccess: { [weak self] in
            guard let self = self else { return }
            self.profileView.stopShimmering()
            guard ShopRoleManager.shared.isShopAdmin else {
                self.addGuestChildsVC()
                return
            }

            self.profileView.updateShopIfNeeded()
            self.addShopOwnerChildsVC()
            AlertManager.shared.showToast(message: TextManager.messageUseHasRoleInShop.localized())
        }) { [weak self] in
            guard let self = self else { return }
            self.profileView.stopShimmering()
            self.addGuestChildsVC()
        }
    }
    
    // MARK: - Add VC Helper
    
    fileprivate func addShopOwnerChildsVC() {
        addProductListVC()
        addStallVC()
        addGalleryVC()
        
        let messageVC = ShopHomeListMessageViewController()
        messageVC.title = TextManager.mesage
        messageVC.view.frame = viewControllerFrame
        subPageControllers.append(messageVC)
        messageVC.scrollDelegateFunc = { [weak self] in self?.pleaseScroll($0) }
        
        let orderVC = ShopHomeListOrderViewController()
        orderVC.title = TextManager.order
        orderVC.view.frame = viewControllerFrame
        subPageControllers.append(orderVC)
        orderVC.scrollDelegateFunc = { [weak self] in self?.pleaseScroll($0) }
        
        addPageMenu(menu: CAPSPageMenu(viewControllers: subPageControllers,
                                       frame: CGRect(x: 0,
                                                     y: 0,
                                                     width: pageMenuContainer.frame.width,
                                                     height: pageMenuContainer.frame.height),
                                       pageMenuOptions: parameters))
    }
    
    fileprivate func addGuestChildsVC() {
        addProductListVC()
        addStallVC()
        addGalleryVC()
        
        addPageMenu(menu: CAPSPageMenu(viewControllers: subPageControllers,
                                       frame: CGRect(x: 0,
                                                     y: 0,
                                                     width: pageMenuContainer.frame.width,
                                                     height: pageMenuContainer.frame.height),
                                       pageMenuOptions: parameters))
    }
    
    private func addProductListVC() {
        let productListVC = ShopHomeListProductViewController()
        productListVC.shop = shop
        productListVC.title = TextManager.product
        productListVC.view.frame = viewControllerFrame
        subPageControllers.append(productListVC)
        productListVC.scrollDelegateFunc = { [weak self] in self?.pleaseScroll($0) }
    }
    
    private func addStallVC() {
        stallDetailVC.setupData(by: shop)
        stallDetailVC.title = TextManager.shopStallInfo
        stallDetailVC.view.frame = viewControllerFrame
        subPageControllers.append(stallDetailVC)
        stallDetailVC.scrollDelegateFunc = { [weak self] in self?.pleaseScroll($0) }
    }
    
    private func addGalleryVC() {
        let galleryVC = ShopHomeGalleryViewController()
        galleryVC.setupData(shopId: shop.id ?? 0)
        galleryVC.title = TextManager.gallery
        galleryVC.view.frame = viewControllerFrame
        subPageControllers.append(galleryVC)
        galleryVC.scrollDelegateFunc = { [weak self] in self?.pleaseScroll($0) }
    }
    
    // MARK: - Process Images Helper
    
    fileprivate func processAfterPickerImage(_ image: UIImage?) {
        guard let image = image else {
            AlertManager.shared.showDefaultError()
            return
        }
        
        if isSelectAvatar {
            AppRouter.pushToAvatarCropperVC(image: image, completion: { [weak self] (image) in
                guard let self = self else { return }
                UIViewController.popToViewController(self)
                if let image = image {
                    self.profileView.setAvatarImage(by: image)
                }
                
                self.performUpdateAvatar(with: image, imageType: .avatar)
                
            }) { [weak self] in
                guard let self = self else { return }
                UIViewController.popToViewController(self)
            }
        } else if isSelectBackground {
            AppRouter.pushToCropCoverImageVC(image: image,
                                             delegate: self,
                                             avatarURL: shop.avatar,
                                             displayName: shop.name)
        }
    }
    
    fileprivate func performUpdateAvatar(with image: UIImage?, imageType: ImageType) {
        guard let image = image else {
            AlertManager.shared.showDefaultError()
            return
        }
        
        self.showLoading()
        
        self.viewModel.uploadImage(image: image, completion: { [weak self] (url) in
            guard let self = self else { return }
            var shopInfoDict = self.shop.toDictionary()
            
            if imageType == .avatar {
                shopInfoDict["Avatar"] = url.absoluteString
            } else {
                shopInfoDict["CardImage"] = url.absoluteString
            }
            
            self.viewModel.updateShopInfo(params: shopInfoDict, completion: {
                self.hideLoading()
                self.shopInfoDelegate?.didUpdateInfoSuccess()
            }, error: {
                self.hideLoading()
                AlertManager.shared.showDefaultError()
            })
        }) { [weak self] in
            self?.hideLoading()
            AlertManager.shared.showDefaultError()
        }
    }
    
}

// MARK: - UserProfileHeaderViewDelegate

extension ShopHomeViewController: UserProfileHeaderViewDelegate {
    func didSelectBackgroundImage() {
        if shop.isOwner || ShopRoleManager.shared.hasRole(roleType: .editShop) {
            AlertManager.shared.show(style: .actionSheet, buttons: [TextManager.updateCover.localized(), TextManager.viewCover.localized()]) { (action, index) in
                if index == 0 {
                    self.isSelectBackground = true
                    self.isSelectAvatar = false
                    AppRouter.presentToImagePicker(pickerDelegate: self)
                } else {
                    AppRouter.presentPopupImage(urls: [self.shop.cardImage])
                }
            }
        } else {
            AppRouter.presentPopupImage(urls: [shop.cardImage])
        }
    }
    
    func didSelectAvatar() {
        if shop.isOwner || ShopRoleManager.shared.hasRole(roleType: .editShop) {
            AlertManager.shared.show(style: .actionSheet, buttons: [TextManager.updateAvatar.localized(), TextManager.viewAvatar.localized()]) { (action, index) in
                if index == 0 {
                    self.isSelectBackground = false
                    self.isSelectAvatar = true
                    AppRouter.presentToImagePicker(pickerDelegate: self)
                } else {
                    AppRouter.presentPopupImage(urls: [self.shop.avatar])
                }
            }
        } else {
            AppRouter.presentPopupImage(urls: [shop.avatar])
        }
    }
}

// MARK: - ImagePickerControllerDelegate

extension ShopHomeViewController: ImagePickerControllerDelegate {
    func imagePickerController(_ picker: ImagePickerController, shouldLaunchCameraWithAuthorization status: AVAuthorizationStatus) -> Bool {
        return true
    }
    
    func imagePickerController(_ picker: ImagePickerController,
                               didFinishPickingImageAssets assets: [PHAsset]) {
        UIViewController.topViewController()?.dismiss(animated: true, completion: {
            assets.first?.getUIImage(completion: { (image) in
                self.processAfterPickerImage(image?.normalizeImage())
            })
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: ImagePickerController) {
        UIViewController.topViewController()?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerCpmtroller(_ picker: ImagePickerController, didTakePhoto photo: UIImage?) {
        UIViewController.topViewController()?.dismiss(animated: true, completion: {
            self.processAfterPickerImage(photo?.normalizeImage())
        })
    }
}

// MARK: - UpdateProfileBackgroundViewControllerDelegate

extension ShopHomeViewController: UpdateCoverImageViewControllerDelegate {
    func didSelectSaveButton(image: UIImage?) {
        guard let image = image else {
            AlertManager.shared.showDefaultError()
            return
        }
        
        profileView.setCoverImage(by: image)
        performUpdateAvatar(with: image, imageType: .cover)
    }
}

// MARK: - ShopProfileHeaderViewDelegate

extension ShopHomeViewController: ShopProfileHeaderViewDelegate {
    func didSelectSetting() {
        // Edit Shop
        let editShopAction = UIAlertAction(title: TextManager.editShopInfo.localized(), style: .default) { [weak self] (action) in
            guard let self = self else { return }
            
            if self.shop.isOwner || ShopRoleManager.shared.hasRole(roleType: .editShop) {
                let viewController = CreateShopViewController()
                viewController.configData(self.shop)
                viewController.delegate = self
                self.navigationController?.pushViewController(viewController, animated: true)
            } else {
                AlertManager.shared.showToast(message: TextManager.messageNotHasShopRole.localized())
            }
        }
        
        // Shop Role
        var message = ""
        if self.shop.isOwner || ShopRoleManager.shared.hasRole(roleType: .editUserRole) {
            message = TextManager.userDecentralization.localized()
        } else {
            message = TextManager.viewUserRole.localized()
        }
        
        let userRoleAction = UIAlertAction(title: message, style: .default) { [weak self] (action) in
            guard let self = self else { return }
            
            if self.shop.isOwner || ShopRoleManager.shared.hasRole(roleType: .editUserRole) {
                let viewController = ShopRoleViewController()
                viewController.configureData(shopId: self.shop.id ?? 0)
                self.navigationController?.pushViewController(viewController, animated: true)
            } else {
                let viewController = UserPermissionViewController()
                viewController.configureTitle(title: TextManager.yourRole.localized())
                viewController.configureData(user: UserManager.user ?? User(), shopId: self.shop.id ?? 0)
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
        
        // Cancel
        let cancelAction = UIAlertAction(title: TextManager.cancel.localized(), style: .cancel, handler: nil)
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(editShopAction)
        alert.addAction(userRoleAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func didSelectSendMessage() {
        
    }
    
    func didSelectFollow() {
        
    }
}

// MARK: - CreateShopViewControllerDelegate

extension ShopHomeViewController: CreateShopViewControllerDelegate {
    func didUpdateShopSuccess(with shop: Shop) {
        shopInfoDelegate?.didUpdateInfoSuccess()
        self.shop = shop
        profileView.configShop(by: shop)
        stallDetailVC.setupData(by: shop)
    }
}
