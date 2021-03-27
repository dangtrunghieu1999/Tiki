//
//  TagCollectionViewCell.swift
//  ZoZoApp
//
//  Created by MACOS on 7/1/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

protocol TagCollectionViewCellDelegate: class {
    func didSelectButton(at index: Int)
}

class TagCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Variables
    
    weak var delegate: TagCollectionViewCellDelegate?
    var indexPath: IndexPath?
    
    var titleFont: UIFont {
        return titleLabel.font
    }
    
    static var defaultLabelHeight: CGFloat  = 34
    static var labelRightMargin: CGFloat    = 8
    static var buttonWidth: CGFloat         = 28
    static var imageAndTitleMargin: CGFloat = 3
    static var labelLeftMargin: CGFloat     = 8
    static var buttonRightMargin            = defaultLabelHeight - buttonWidth - 3
    
    // MARK: - UI Elements
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.close, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(tapInButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - LifeCycles
    
    override func initialize() {
        layer.borderColor = UIColor.separator.cgColor
        layer.borderWidth = 0.5
        layer.cornerRadius = TagCollectionViewCell.defaultLabelHeight / 2
        layer.masksToBounds = true
        
        layoutLabel()
        layoutButton()
    }
    
    // MARK: - Public
    
    static func estimateCellSize(text: String) -> CGSize {
        var textWidth = text.width(withConstrainedHeight: TagCollectionViewCell.defaultLabelHeight,
                                   font: TagCollectionViewCell().titleFont)
        
        textWidth = textWidth + labelRightMargin + buttonWidth + imageAndTitleMargin + labelLeftMargin
            + buttonRightMargin
        return CGSize(width: textWidth, height: defaultLabelHeight)
    }
    
    static func estmateCellSizeWhenHideDeleteButton(text: String) -> CGSize {
        var textWidth = text.width(withConstrainedHeight: TagCollectionViewCell.defaultLabelHeight,
                                   font: TagCollectionViewCell().titleFont)
        
        textWidth = textWidth + 4 * labelLeftMargin
        return CGSize(width: textWidth, height: defaultLabelHeight)
    }
    
    func setTitle(_ title: String?) {
        titleLabel.text = title
    }
    
    func hideDeleteButton(_ isHidden: Bool) {
        button.isHidden = isHidden
        
        if isHidden {
            titleLabel.textAlignment = .center
            titleLabel.snp.updateConstraints { (make) in
                make.left.equalToSuperview().offset(2 * TagCollectionViewCell.labelLeftMargin)
            }
        }
    }
    
    // MARK: - Override
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.backgroundColor = UIColor.background
                self.titleLabel.textColor = UIColor.white
            } else {
                self.backgroundColor = UIColor.clear
                self.titleLabel.textColor = UIColor.bodyText
            }
        }
    }
    
    // MARK: - UI Actions
    
    @objc private func tapInButton() {
        guard let index = indexPath?.row else { return }
        delegate?.didSelectButton(at: index)
    }
    
    // MARK: - Layouts
    
    private func layoutLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.height.equalTo(TagCollectionViewCell.defaultLabelHeight)
            make.left.equalToSuperview().offset(TagCollectionViewCell.labelLeftMargin)
        }
    }
    
    private func layoutButton() {
        addSubview(button)
        button.snp.makeConstraints { (make) in
            make.width.height.equalTo(TagCollectionViewCell.buttonWidth)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-TagCollectionViewCell.buttonRightMargin)
        }
    }
    
}
