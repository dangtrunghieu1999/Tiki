//
//  ShopHomeProductListSearchHeaderView.swift
//  ZoZoApp
//
//  Created by MACOS on 6/29/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

protocol ShopSearchViewDelegate: class {
    func didEndSearch()
    func didSearch(text: String?)
    func didSelectAddNewProduct()
}

class ShopHomeProductListSearchHeaderView: BaseCollectionViewHeaderFooterCell {
    
    // MARK: - Variables
    
    weak var delegate: ShopSearchViewDelegate?
    
    private let buttonHorizontalMargin: CGFloat = 4
    private let textFieldHeight: CGFloat        = 36
    private let buttonWidth: CGFloat            = 120
    
    // MARK: - UI Elements
    
    private lazy var searchTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.placeholder = TextManager.searchProduct.localized()
        textField.leftImage = ImageManager.searchGray
        textField.layer.cornerRadius = textFieldHeight / 2
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 1.0
        textField.returnKeyType = .search
        textField.clearButtonMode = .whileEditing
        textField.layer.borderColor = UIColor.lightSeparator.cgColor
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldValueChange), for: .editingChanged)
        textField.addTarget(self, action: #selector(textFieldEndEditing), for: .editingDidEnd)
        return textField
    }()
    
    private lazy var createProductButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.addCircle, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(tapOnAddNewProductButton), for: .touchUpInside)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.addNewProductTitle.localized()
        label.textAlignment = .center
        label.textColor = UIColor.lightBodyText
        label.font = UIFont.systemFont(ofSize: FontSize.body.rawValue)
        label.numberOfLines = 1
        return label
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
        layoutCreateProductButton()
        layoutTitleLabel()
        layoutSeparatorView()
    }
    
    func configLayout(isOwnerShop: Bool) {
        if isOwnerShop {
            createProductButton.isHidden = false
            titleLabel.isHidden = false
        } else {
            createProductButton.isHidden = true
            titleLabel.isHidden = true
        }
    }
    
    // MARK: - UIActions
    
    @objc func tapOnAddNewProductButton() {
        delegate?.didSelectAddNewProduct()
    }
    
    @objc func textFieldValueChange() {
        delegate?.didSearch(text: searchTextField.text)
    }
    
    @objc func textFieldEndEditing() {
        if searchTextField.text == "" || searchTextField.text == nil {
            delegate?.didEndSearch()
        }
    }
    
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
    
    private func layoutCreateProductButton() {
        addSubview(createProductButton)
        createProductButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(60)
            make.centerX.equalToSuperview()
            make.top.equalTo(searchTextField.snp.bottom)
                .offset(Dimension.shared.largeMargin)
        }
    }
    
    private func layoutTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(createProductButton.snp.bottom).offset(4)
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
