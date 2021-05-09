//
//  ShopHomeProductListSearchHeaderView.swift
//  ZoZoApp
//
//  Created by MACOS on 6/29/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class ShopHomeProductListSearchHeaderView: BaseCollectionViewHeaderFooterCell {
    
    // MARK: - Variables
    
    private let buttonHorizontalMargin: CGFloat = 4
    private let textFieldHeight: CGFloat        = 36
    private let buttonWidth: CGFloat            = 120
    
    // MARK: - UI Elements
    
    private lazy var searchTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.placeholder = TextManager.searchProduct.localized()
        textField.leftImage = ImageManager.searchGray
        textField.layer.cornerRadius = Dimension.shared.cornerRadiusSmall
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 1.0
        textField.returnKeyType = .search
        textField.clearButtonMode = .whileEditing
        textField.layer.borderColor = UIColor.lightSeparator.cgColor
        textField.delegate = self
        return textField
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightBackground
        return view
    }()
    
    // MARK: - LifeCycles
    
    override func initialize() {
        backgroundColor = UIColor.white
        layoutSearchBar()
        layoutSeparatorView()
    }

    
    // MARK: - UIActions
    
    // MARK: - Layouts
    
    private func layoutSearchBar() {
        addSubview(searchTextField)
        searchTextField.snp.makeConstraints { (make) in
            make.height.equalTo(textFieldHeight)
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
        }
    }
    
    private func layoutSeparatorView() {
        addSubview(separatorView)
        separatorView.snp.makeConstraints { (make) in
            make.width.bottom.centerX.equalToSuperview()
            make.height.equalTo(BaseProductView.itemSpacing)
        }
    }
    
}

// MARK: - UITextFieldDelegate

extension ShopHomeProductListSearchHeaderView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
}
