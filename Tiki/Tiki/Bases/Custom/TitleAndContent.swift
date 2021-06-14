//
//  TitleText.swift
//  ZoZoApp
//
//  Created by Dang Trung Hieu on 8/4/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class TitleAndContent: BaseView {

    
    // MARK: - Varibles
    
    var titleText: String? {
        didSet {
            titleLabel.text = titleText
        }
    }
    var contentText: String? {
        didSet {
            contentlLabel.text = contentText
        }
    }
    
    // MARK: - UI Elements
    
    private let titleLabel: UILabel = {
      let label = UILabel()
        label.textColor = UIColor.titleText
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .medium)
      return label
    }()
    
    private let contentlLabel: UILabel = {
      let label = UILabel()
        label.textColor = UIColor.titleText
        label.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - View LifeCycles
    
    override func initialize() {
        super.initialize()
        
        layoutTitleLabel()
        layoutContentLabel()
    }
    
    // MARK: - Setup layouts
    
    func layoutTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
        }
    }
    
    func layoutContentLabel() {
        addSubview(contentlLabel)
        contentlLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(Dimension.shared.mediumMargin)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
