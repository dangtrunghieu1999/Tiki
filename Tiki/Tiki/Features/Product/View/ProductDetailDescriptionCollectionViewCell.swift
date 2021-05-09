//
//  InfoDetailCollectionViewCell.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 4/15/21.
//

import UIKit

protocol ProductDetailDesciptionCollectionViewCellDelegate: class {
    func didSelectSeeMore()
}

class ProductDetailDescriptionCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Variables
    
    weak var delegate: ProductDetailDesciptionCollectionViewCellDelegate?
    static let defaultHeightToExpand: CGFloat = 280
    
    // MARK: - UI Elements
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightBodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    fileprivate lazy var seemoreButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.seemore, for: .normal)
        button.backgroundColor = UIColor.clear
        button.setTitleColor(UIColor.thirdColor, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.addRightIcon(image: ImageManager.see_more ?? UIImage())
        button.titleLabel?.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        button.addTarget(self, action: #selector(tapOnSeeMoreButton), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - View LifeCycles
    
    override func initialize() {
        super.initialize()
        layoutTitleLabel()
        layoutSeemoreButton()
    }
    
    // MARK: - Helper Method
    
    static func estimateHeight(_ product: Product) -> CGFloat {
        let textWidth = ScreenSize.SCREEN_WIDTH - 2 * Dimension.shared.normalMargin
        let textHeight = product.descriptions.height(withConstrainedWidth: textWidth,
                                               font: UIFont.systemFont(ofSize: FontSize.h1.rawValue))
        if textHeight > 180 {
            return textHeight + 50
        } else {
            return textHeight + 16
        }
    }
    
    static func esitmateColapseHeight(_ product: Product) -> CGFloat {
        let textWidth = ScreenSize.SCREEN_WIDTH - 2 * Dimension.shared.normalMargin
        let text = String(product.descriptions.prefix(500))
        return text.height(withConstrainedWidth: textWidth,
                           font: UIFont.systemFont(ofSize: FontSize.h1.rawValue)) + 50
    }
    
    func configData(_ product: Product, canExpand: Bool, isExpand: Bool) {
        if isExpand {
            seemoreButton.setTitle(TextManager.colapse.localized(), for: .normal)
            let name = product.descriptions
            titleLabel.attributedText = Ultilities.lineSpacingLabel(title: name)
        } else {
            seemoreButton.setTitle(TextManager.seemore.localized(), for: .normal)
            titleLabel.text = String(product.descriptions.prefix(500))
        }
        
        seemoreButton.isHidden = !canExpand
    }
    
    // MARK: - UI Actions
    
    @objc private func tapOnSeeMoreButton() {
        delegate?.didSelectSeeMore()
    }
    
    // MARK: - GET API
    
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
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(100)
        }
    }
    
}
