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
    
    fileprivate lazy var shopCodeTitleContent: TitleAndContent = {
        let titleContent = TitleAndContent()
        titleContent.titleText = TextManager.shopCode.localized()
        return titleContent
    }()
    
    fileprivate lazy var shopNameTitleContent: TitleAndContent = {
        let titleContent = TitleAndContent()
        titleContent.titleText = TextManager.shopName.localized()
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
    
    fileprivate lazy var shopWebsiteTitleContent: TitleAndContent = {
        let titleContent = TitleAndContent()
        titleContent.titleText = TextManager.shopWebsiteTitle.localized()
        return titleContent
    }()
    
    private let localtionWebView: UIWebView = {
        let webView = UIWebView()
        webView.backgroundColor = UIColor.white
        return webView
    }()
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        layoutScrollView()
        layoutContainView()
        layoutShopCodeTitleContent()
        layoutShopNameTitleContent()
        layoutShopPhoneTitleContent()
        layoutShopAddressTitleContent()
        layoutShopHotLineTitleContent()
        layoutShopWebsiteTitleContent()
        layoutLocationWebView()
    }
    
    // MARK: - Public methods
    
    func setupData(by shop: Shop) {
        shopCodeTitleContent.contentText = shop.code
        shopPhoneTitleContent.contentText = shop.mobile
        shopAddressTitleContent.contentText = shop.address
        shopHotLineTitleContent.contentText = shop.hotline
        shopWebsiteTitleContent.contentText = shop.website
        localtionWebView.loadHTMLString(shop.map, baseURL: nil)
        
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
            make.top.equalToSuperview().offset(Dimension.shared.normalMargin)
            make.width.equalTo(view).offset(-10)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func layoutShopCodeTitleContent() {
        containView.addSubview(shopCodeTitleContent)
        shopCodeTitleContent.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Dimension.shared.normalMargin)
            make.right.equalToSuperview().offset(-Dimension.shared.normalMargin)
            make.top.equalToSuperview().offset(Dimension.shared.largeMargin)
        }
    }
    
    func layoutShopNameTitleContent() {
        containView.addSubview(shopNameTitleContent)
        shopNameTitleContent.snp.makeConstraints { (make) in
            make.left.right.equalTo(shopCodeTitleContent)
            make.top.equalTo(shopCodeTitleContent.snp.bottom).offset(Dimension.shared.largeMargin)
        }
    }
    
    func layoutShopPhoneTitleContent() {
        containView.addSubview(shopPhoneTitleContent)
        shopPhoneTitleContent.snp.makeConstraints { (make) in
            make.left.right.equalTo(shopCodeTitleContent)
            make.top.equalTo(shopNameTitleContent.snp.bottom).offset(Dimension.shared.largeMargin)
        }
    }
    
    func layoutShopAddressTitleContent() {
        containView.addSubview(shopAddressTitleContent)
        shopAddressTitleContent.snp.makeConstraints { (make) in
            make.left.right.equalTo(shopCodeTitleContent)
            make.top.equalTo(shopPhoneTitleContent.snp.bottom).offset(Dimension.shared.largeMargin)
        }
    }
    
    func layoutShopHotLineTitleContent() {
        containView.addSubview(shopHotLineTitleContent)
        shopHotLineTitleContent.snp.makeConstraints { (make) in
            make.left.right.equalTo(shopCodeTitleContent)
            make.top.equalTo(shopAddressTitleContent.snp.bottom).offset(Dimension.shared.largeMargin)
        }
    }
    
    func layoutShopWebsiteTitleContent(){
        containView.addSubview(shopWebsiteTitleContent)
        shopWebsiteTitleContent.snp.makeConstraints { (make) in
            make.left.right.equalTo(shopCodeTitleContent)
            make.top.equalTo(shopHotLineTitleContent.snp.bottom).offset(Dimension.shared.largeMargin)
        }
    }
    
    private func layoutLocationWebView() {
        let width = ScreenSize.SCREEN_WIDTH - 32
        let height = width * 0.65
        containView.addSubview(localtionWebView)
        localtionWebView.snp.makeConstraints { (make) in
            make.width.equalTo(width)
            make.height.equalTo(height)
            make.centerX.equalToSuperview()
            make.top.equalTo(shopWebsiteTitleContent.snp.bottom).offset(Dimension.shared.largeMargin)
            make.bottom.equalToSuperview().offset(-Dimension.shared.largeMargin_32)
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
