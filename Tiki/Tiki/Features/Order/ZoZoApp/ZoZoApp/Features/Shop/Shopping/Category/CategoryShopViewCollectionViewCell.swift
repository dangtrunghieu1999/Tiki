//
//  CategoryShopViewCollectionViewCell.swift
//  ZoZoApp
//
//  Created by Dang Trung Hieu on 9/1/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class CategoryShopViewCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - UI Elements
    
    fileprivate lazy var titleNameLabel: ShimmerLabel = {
        let label = ShimmerLabel()
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .medium)
        label.textColor = UIColor.background
        return label
    }()
    
    override func initialize() {
        super.initialize()
        layouTitleNameLabel()
    }
    
    func configCell(by category: Category) {
        titleNameLabel.text = category.name
    }
    
    private func layouTitleNameLabel() {
        addSubview(titleNameLabel)
        titleNameLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(4)
        }
    }
}
