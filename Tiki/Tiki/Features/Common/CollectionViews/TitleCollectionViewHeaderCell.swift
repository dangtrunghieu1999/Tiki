//
//  TitleCollectionViewCell.swift
//  ZoZoApp
//
//  Created by MACOS on 7/20/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class TitleCollectionViewHeaderCell: BaseCollectionViewHeaderFooterCell {
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var font: UIFont? {
        didSet {
            titleLabel.font = font
        }
    }
    
    var textColor: UIColor = .white {
        didSet {
            titleLabel.textColor = textColor
        }
    }
    
    private let view: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    override func initialize() {
        setupViewbackgroundView()
        setupViewTitleLabel()
    }
    
    private func setupViewbackgroundView() {
        addSubview(view)
        view.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
    }
    
    private func setupViewTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Dimension.shared.normalMargin)
            make.centerY.equalToSuperview()
        }
    }
}
