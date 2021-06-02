//
//  HeaderTitleCollectionReusableView.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 4/9/21.
//

import UIKit

class HeaderTitleCollectionReusableView: BaseCollectionViewHeaderFooterCell {
    
    // MARK: - Variables
    
    // MARK: - UI Elements
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.red
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: FontSize.body.rawValue, weight: .bold)
        return label
    }()
    
    // MARK: - View LifeCycles
    
    override func initialize() {
        super.initialize()
        backgroundColor = .white
        layoutTitleLabel()
    }
    
    // MARK: - Helper Method
    
    func configTitleHeader(title: String?) {
        self.titleLabel.text = title
    }
    
    // MARK: - GET API
    
    // MARK: - Layout
    
    private func layoutTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Dimension.shared.normalMargin)
            make.top.equalToSuperview().offset(Dimension.shared.mediumMargin)
            make.right.equalToSuperview()
        }
    }
}


