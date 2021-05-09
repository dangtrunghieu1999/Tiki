//
//  OrderTableViewHeaderCell.swift
//  ZoZoApp
//
//  Created by Dang Trung Hieu on 8/29/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class NotificationsTableViewHeaderCell: BaseTableViewHeaderFooter {
    
    // MARK: - Variables
    
    var titleName: String? {
        didSet{
            titleLabel.text = titleName
        }
    }
     // MARK: - UI Elements
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .medium)
        label.textAlignment = .left
        return label
    }()
    
    fileprivate lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightSeparator
        return view
    }()
    
    // MARK: - View LifeCycles
    
    override func initialize() {
        super.initialize()
        contentView.backgroundColor = UIColor.white
        layoutTitleLabel()
        layoutLineView()
    }
    
    // MARK: - Setup layouts

    private func layoutTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Dimension.shared.normalMargin)
            make.centerY.equalToSuperview()
        }
    }
    
    private func layoutLineView() {
        addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}
