//
//  SearchPlaceResultTableViewCell.swift
//  ZoZoApp
//
//  Created by LAP12852 on 10/26/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class SearchPlaceResultTableViewCell: BaseTableViewCell {

    // MARK: - Variables
    
    // MARK: - UI Elements
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Access to all Cloud Platform Products"
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        label.numberOfLines = 1
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Get everything you need to build and run your apps, websites and services, including Firebase and the"
        label.textColor = UIColor.lightBodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        label.numberOfLines = 1
        return label
    }()
    
    // MARK: - LifeCycles
    
    override func initialize() {
        layoutTitleLabel()
        ;layoutSubTitleLabel()
    }
    
    // MARK: - Public Methods
    
    // MARK: - UI Actions
    
    // MARK: - Helper Methods
    
    // MARK: - Layout
    
    private func layoutTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(dimension.normalMargin)
            make.leading.equalToSuperview().offset(dimension.normalMargin)
            make.trailing.equalToSuperview().inset(dimension.mediumMargin)
        }
    }
    
    private func layoutSubTitleLabel() {
        addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(dimension.smallMargin)
            make.bottom.equalToSuperview().offset(-dimension.normalMargin)
        }
    }

}
