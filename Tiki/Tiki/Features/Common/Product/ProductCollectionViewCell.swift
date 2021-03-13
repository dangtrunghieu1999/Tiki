//
//  ProductCollectionViewCell.swift
//  ZoZoApp
//
//  Created by MACOS on 6/29/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class ProductCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Variables
    
    weak var delegate: BaseProductViewDelegate? {
        didSet {
            productView.delegate = delegate
        }
    }
    
    private var product = Product()
    
    // MARK: - UI Elements
    
    private let productView = BaseProductView()
    
    lazy var refreshProductButton: ShimmerButton = {
        let button = ShimmerButton()
        button.setTitle(TextManager.refreshProduct.localized(), for: .normal)
        button.buttonBGColor = UIColor.accentColor
        button.setTitleColor(UIColor.white, for: .normal)
        button.setFont(UIFont.systemFont(ofSize: FontSize.h2.rawValue, weight: .medium))
        button.addTarget(self, action: #selector(tapOnRefreshProduct), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    lazy var getLinkButton: ShimmerButton = {
        let button = ShimmerButton()
        button.setTitle(TextManager.getLink.localized(), for: .normal)
        button.buttonBGColor = UIColor.clear
        button.setTitleColor(UIColor.background, for: .normal)
        button.layer.cornerRadius = 21
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.background.cgColor
        button.setFont(UIFont.systemFont(ofSize: FontSize.h2.rawValue, weight: .medium))
        button.addTarget(self, action: #selector(tapOnGetLinkButton), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    lazy var shareFacebookButton: ShimmerButton = {
        let button = ShimmerButton()
        button.setTitle(TextManager.facebook.localized(), for: .normal)
        button.buttonBGColor = UIColor.clear
        button.setTitleColor(UIColor.background, for: .normal)
        button.layer.cornerRadius = 21
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.background.cgColor
        button.setFont(UIFont.systemFont(ofSize: FontSize.h2.rawValue, weight: .medium))
        button.addTarget(self, action: #selector(tapOnShareFacebookButton), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    lazy var shareInAppButton: ShimmerButton = {
        let button = ShimmerButton()
        button.setTitle(TextManager.share.localized(), for: .normal)
        button.buttonBGColor = UIColor.accentColor
        button.setTitleColor(UIColor.white, for: .normal)
        button.setFont(UIFont.systemFont(ofSize: FontSize.h2.rawValue, weight: .medium))
        button.addTarget(self, action: #selector(tapOnShareInAppButton), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    // MARK: - LifeCycles
    
    override func initialize() {
        layoutProductView()
        productView.startShimmering()
        layoutRefreshProductButton()
        layoutShareInAppButton()
        layoutGetLinkButton()
        layoutShareFBButton()
    }
    
    // MARK: - Public methods
   
    func configData(_ product: Product, isOwner: Bool) {
        self.product = product
        refreshProductButton.isHidden = !isOwner
        productView.isOnwer = isOwner
        productView.configData(product: product)
    }
    
    func configData(_ product: Product, isEarnMoneyLayout: Bool) {
        self.product = product
        refreshProductButton.isHidden = true
        getLinkButton.isHidden = !isEarnMoneyLayout
        shareFacebookButton.isHidden = !isEarnMoneyLayout
        shareInAppButton.isHidden = !isEarnMoneyLayout
        productView.configData(product: product)
    }
    
    func stopShimmer() {
        productView.stopShimmering()
    }
    
    // MARK: - UIActions
    
    @objc private func tapOnRefreshProduct() {
        delegate?.didSelectRefresh(product)
    }
    
    @objc private func tapOnShareInAppButton() {
        AlertManager.shared.showToast(message: TextManager.featureInDev)
    }
    
    @objc private func tapOnGetLinkButton() {
        AlertManager.shared.showToast(message: TextManager.featureInDev)
    }
    
    @objc private func tapOnShareFacebookButton() {
        AlertManager.shared.showToast(message: TextManager.featureInDev)
    }
    
    // MARK: - Layouts
    
    private func layoutProductView() {
        addSubview(productView)
        productView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
    private func layoutRefreshProductButton() {
        addSubview(refreshProductButton)
        refreshProductButton.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(42)
        }
    }
    
    private func layoutShareInAppButton() {
        addSubview(shareInAppButton)
        shareInAppButton.snp.makeConstraints { (make) in
            make.edges.equalTo(refreshProductButton)
        }
    }
    
    private func layoutGetLinkButton() {
        addSubview(getLinkButton)
        getLinkButton.snp.makeConstraints { (make) in
            make.height.equalTo(shareInAppButton)
            make.left.equalTo(shareInAppButton).offset(2)
            make.bottom.equalTo(shareInAppButton.snp.top).offset(-5)
            make.right.equalTo(snp.centerX).offset(-2)
        }
    }
    
    private func layoutShareFBButton() {
        addSubview(shareFacebookButton)
        shareFacebookButton.snp.makeConstraints { (make) in
            make.height.equalTo(shareInAppButton)
            make.right.equalTo(shareInAppButton).offset(-2)
            make.bottom.top.equalTo(getLinkButton)
            make.left.equalTo(snp.centerX).offset(2)
        }
    }
    
}
