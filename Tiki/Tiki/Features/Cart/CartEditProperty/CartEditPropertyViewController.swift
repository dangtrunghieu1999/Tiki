//
//  CartEditPropertyViewController.swift
//  ZoZoApp
//
//  Created by LAP12852 on 8/25/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

protocol CartEditPropertyViewControllerDelegate: class {
    func didSelectCofirmEditProperties(for product: Product, size: String?, color: String?)
}

class CartEditPropertyViewController: BaseAlertViewController {

    // MARK: - Variables
    
    weak var delegate: CartEditPropertyViewControllerDelegate?
    
    fileprivate var product = Product()
    fileprivate var selectedSize: String?
    fileprivate var selectedColor: String?
    
    // MARK: - UI Elements
    
    fileprivate let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.white
        imageView.contentMode =  .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.lightSeparator.cgColor
        imageView.layer.borderWidth = 1
        return imageView
    }()
    
    private let containerScrollView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.selectProperties.localized()
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .medium)
        return label
    }()
    
    private let titleSizeLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.size.localized()
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.body.rawValue, weight: .medium)
        return label
    }()
    
    private lazy var listSizeView: CollectionTagView = {
        let view = CollectionTagView()
        view.delegate = self
        view.hiddeDeleteButton = true
        return view
    }()
    
    private let titleColorLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.color.localized()
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.body.rawValue, weight: .medium)
        return label
    }()
    
    private lazy var listColorView: CollectionTagView = {
        let view = CollectionTagView()
        view.delegate = self
        view.hiddeDeleteButton = true
        return view
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.accentColor
        button.layer.cornerRadius = 3
        button.layer.masksToBounds = true
        button.setTitle(TextManager.confirm.capitalized.localized(), for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(touchInConfirmButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutContainerView()
        layoutProductImageView()
        layoutTitleLabel()
        layoutConfirmButton()
        layoutScrollView()
        layoutContainerScrollView()
        layoutSizeTitleLabel()
        layoutListSizeView()
        layoutColorLabel()
        layoutListColorView()
    }
    
    // MARK: - Public Methods

    func configData(_ product: Product) {
        self.product = product
        listSizeView.selectedValue = product.selectedSize
        listSizeView.setTag(tags: product.sizeModels)
        listColorView.selectedValue = product.selectedColor
        listColorView.setTag(tags: product.colorModels)
        
        productImageView.loadImage(by: product.defaultImage,
                                   defaultImage: ImageManager.imagePlaceHolder)
    }
    
    // MARK: - UI Actions
    
    @objc private func touchInConfirmButton() {
        delegate?.didSelectCofirmEditProperties(for: product,
                                                size: selectedSize,
                                                color: selectedColor)
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helper Methods
    
    fileprivate func getText(at indexPath: IndexPath) -> String? {
        if indexPath.section == 0 {
            return product.sizeModels[safe: indexPath.row]
        } else {
            return product.colorModels[safe: indexPath.row]
        }
    }
    
    // MARK: - Layout
    
    private func layoutContainerView() {
        view.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.bottom.centerX.equalToSuperview()
            make.height.equalTo(350)
            make.width.equalToSuperview()
        }
    }
    
    private func layoutProductImageView() {
        view.addSubview(productImageView)
        productImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(80)
            make.left.equalToSuperview().offset(16)
            make.centerY.equalTo(containerView.snp.top)
        }
    }
    
    private func layoutTitleLabel() {
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(productImageView.snp.right).offset(16)
            make.top.equalToSuperview().offset(16)
        }
    }
    
    override func layoutScrollView() {
        containerView.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(productImageView.snp.bottom).offset(16)
            make.bottom.equalTo(confirmButton.snp.top).offset(-16)
        }
    }
    
    private func layoutContainerScrollView() {
        scrollView.addSubview(containerScrollView)
        containerScrollView.snp.makeConstraints { (make) in
            make.width.equalTo(containerView).offset(-32)
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func layoutSizeTitleLabel() {
        containerScrollView.addSubview(titleSizeLabel)
        titleSizeLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
        }
    }
    
    private func layoutListSizeView() {
        containerScrollView.addSubview(listSizeView)
        listSizeView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleSizeLabel.snp.bottom).offset(16)
        }
    }
    
    private func layoutColorLabel() {
        containerScrollView.addSubview(titleColorLabel)
        titleColorLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalTo(listSizeView.snp.bottom).offset(20)
        }
    }
    
    private func layoutListColorView() {
        containerScrollView.addSubview(listColorView)
        listColorView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleColorLabel.snp.bottom).offset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
    
    private func layoutConfirmButton() {
        containerView.addSubview(confirmButton)
        confirmButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-8)
            make.height.equalTo(Dimension.shared.defaultHeightButton)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-30)
        }
    }

}

// MARK: - CollectionTagViewDelegate

extension CartEditPropertyViewController: CollectionTagViewDelegate {
    func didSelectTag(collectionTagView: CollectionTagView, value: String?) {
        if collectionTagView == listSizeView {
            selectedSize = value
        } else {
            selectedColor = value
        }
    }
}
