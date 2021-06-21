//
//  ShopHomeStallDetailViewController.swift
//  ZoZoApp
//
//  Created by MACOS on 6/29/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class ShopHomeStallDetailViewController: BaseViewController {
    
    // MARK: - Variables
    
    // MARK: - UI Elements
    
    fileprivate lazy var containView: BaseView = {
        let view = BaseView()
        return view
    }()
    
    fileprivate lazy var shopNameTitleContent: TitleAndContent = {
        let titleContent = TitleAndContent()
        titleContent.titleText = TextManager.shopNameTitle.localized()
        return titleContent
    }()
    
    fileprivate lazy var shopPhoneTitleContent: TitleAndContent = {
        let titleContent = TitleAndContent()
        titleContent.titleText = TextManager.shopPhoneNumber.localized()
        return titleContent
    }()
    
    fileprivate lazy var shopAddressTitleContent: TitleAndContent = {
        let titleContent = TitleAndContent()
        titleContent.titleText = TextManager.shopAddressTitle.localized()
        return titleContent
    }()
    
    fileprivate lazy var shopHotLineTitleContent: TitleAndContent = {
        let titleContent = TitleAndContent()
        titleContent.titleText = TextManager.shopHotline.localized()
        return titleContent
    }()
    
    fileprivate lazy var shopWebsiteLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.shopWebsiteTitle.localized()
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue,
                                       weight: .medium)
        label.textAlignment = .left
        return label
    }()

    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        layoutScrollView()
        layoutContainView()
        layoutShopNameTitleContent()
        layoutShopPhoneTitleContent()
        layoutShopAddressTitleContent()
        layoutShopHotLineTitleContent()
        layoutShopWebsiteTitleContent()
    }
    
    // MARK: - Public methods
    
    func setupData(by shop: Shop) {
        shopPhoneTitleContent.contentText = shop.mobile
        shopAddressTitleContent.contentText = shop.address
        shopHotLineTitleContent.contentText = shop.hotline
        if shop.displayName != "" {
            shopNameTitleContent.contentText = shop.displayName
        } else {
            shopNameTitleContent.contentText = shop.name
        }
    }
    
    // MARK: - Setup layouts
    
    func layoutContainView() {
        scrollView.addSubview(containView)
        containView.snp.makeConstraints { (make) in
            make.top
                .equalToSuperview()
                .offset(dimension.normalMargin)
            make.width
                .equalTo(view)
                .offset(-10)
            make.centerX
                .equalToSuperview()
            make.bottom
                .equalToSuperview()
        }
    }
    
    func layoutShopNameTitleContent() {
        containView.addSubview(shopNameTitleContent)
        shopNameTitleContent.snp.makeConstraints { (make) in
            make.left
                .right
                .equalToSuperview()
                .inset(dimension.normalMargin)
            make.top
                .equalToSuperview()
                .offset(dimension.largeMargin)
        }
    }
    
    func layoutShopPhoneTitleContent() {
        containView.addSubview(shopPhoneTitleContent)
        shopPhoneTitleContent.snp.makeConstraints { (make) in
            make.left
                .right
                .equalTo(shopNameTitleContent)
            make.top
                .equalTo(shopNameTitleContent.snp.bottom)
                .offset(dimension.largeMargin)
        }
    }
    
    func layoutShopAddressTitleContent() {
        containView.addSubview(shopAddressTitleContent)
        shopAddressTitleContent.snp.makeConstraints { (make) in
            make.left
                .right
                .equalTo(shopNameTitleContent)
            make.top
                .equalTo(shopPhoneTitleContent.snp.bottom)
                .offset(dimension.largeMargin)
        }
    }
    
    func layoutShopHotLineTitleContent() {
        containView.addSubview(shopHotLineTitleContent)
        shopHotLineTitleContent.snp.makeConstraints { (make) in
            make.left
                .right
                .equalTo(shopNameTitleContent)
            make.top
                .equalTo(shopAddressTitleContent.snp.bottom)
                .offset(dimension.largeMargin)
        }
    }
    
    func layoutShopWebsiteTitleContent(){
        containView.addSubview(shopWebsiteLabel)
        shopWebsiteLabel.snp.makeConstraints { (make) in
            make.left
                .right
                .equalTo(shopNameTitleContent)
            make.top
                .equalTo(shopHotLineTitleContent.snp.bottom)
                .offset(dimension.largeMargin)
        }
    }

    
}
// MARK: - UIScrollViewDelegate

extension ShopHomeStallDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let scrollDelegate = scrollDelegateFunc {
            scrollDelegate(scrollView)
        }
    }
}
