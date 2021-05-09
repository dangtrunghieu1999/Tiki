//
//  ProductDetailDesciptionCollectionViewCell.swift
//  ZoZoApp
//
//  Created by MACOS on 7/20/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

protocol ProductDetailDesciptionCollectionViewCellDelegate: class {
    func didSelectSeeMore()
}

class ProductDetailDesciptionCollectionViewCell: BaseCollectionViewCell {
    
    static let defaultHeightToExpand: CGFloat = 280
    
    weak var delegate: ProductDetailDesciptionCollectionViewCellDelegate?
    
    // MARK: - UI Elements
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightBodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var seemoreButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.seemore.localized(), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .medium)
        button.setTitleColor(UIColor.background, for: .normal)
        button.addTarget(self, action: #selector(tapOnSeeMoreButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - LifeCycles
    
    override func initialize() {
        layoutTitleLabel()
        layoutSeemoreButton()
    }
    
    // MARK: - Public methods
    
    static func estimateHeight(_ product: Product) -> CGFloat {
        let textWidth = ScreenSize.SCREEN_WIDTH - 2 * Dimension.shared.normalMargin
        let textHeight = product.detail.height(withConstrainedWidth: textWidth,
                                               font: UIFont.systemFont(ofSize: FontSize.h1.rawValue))
        if textHeight > 230 {
            return textHeight + 50
        } else {
            return textHeight + 16
        }
    }
    
    static func esitmateColapseHeight(_ product: Product) -> CGFloat {
        let textWidth = ScreenSize.SCREEN_WIDTH - 2 * Dimension.shared.normalMargin
        let text = String(product.detail.prefix(500))
        return text.height(withConstrainedWidth: textWidth,
                           font: UIFont.systemFont(ofSize: FontSize.h1.rawValue)) + 50
    }
    
    func configData(_ product: Product, canExpand: Bool, isExpand: Bool) {
        if isExpand {
            seemoreButton.setTitle(TextManager.colapse.localized(), for: .normal)
            titleLabel.text = product.detail
        } else {
            seemoreButton.setTitle(TextManager.seemore.localized(), for: .normal)
            titleLabel.text = String(product.detail.prefix(500))
        }
        
        seemoreButton.isHidden = !canExpand
    }
    
    // MARK: - UI Actions
    
    @objc private func tapOnSeeMoreButton() {
        delegate?.didSelectSeeMore()
    }
    
    // MARK: - Layouts
    
    private func layoutTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Dimension.shared.normalMargin)
            make.top.equalToSuperview()
            make.right.equalToSuperview().offset(-Dimension.shared.normalMargin)
        }
    }
    
    private func layoutSeemoreButton() {
        addSubview(seemoreButton)
        seemoreButton.snp.makeConstraints { (make) in
            make.bottom.centerX.width.equalToSuperview()
            make.height.equalTo(50)
        }
    }
}
