//
//  CheckListCollectionViewCell.swift
//  CustomerApp
//
//  Created by LAP12852 on 10/11/19.
//  Copyright © 2019 Bee. All rights reserved.
//

import UIKit

class CheckListCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - UI Elements
    
    fileprivate let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.background
        view.layer.cornerRadius = 5
        return view
    }()
    
    private let checkIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "icon-checkbox-uncheck")
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.secondary1
        label.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue,
                                       weight: .regular)
        return label
    }()
    
    // MARK: - View LifeCycle
    
    override func initialize() {
        super.initialize()
        self.layoutContainerView()
        self.layoutCheckIcon()
        self.layoutTitleLabel()
    }
    
    // MARK: - Public method
    
    func configureData(with title: String, _ isSelected: Bool) {
        self.titleLabel.text = title
        if isSelected {
            self.checkIcon.image = UIImage(named: "icon-checkbox")
        } else {
            self.checkIcon.image = UIImage(named: "icon-checkbox-uncheck")
        }
    }
    
    // MARK: - Setup Layouts
    
    private func layoutContainerView() {
        self.addSubview(self.containerView)
        self.containerView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview().offset(-dimension.normalMargin)
            make.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(10)
        }
    }
    
    private func layoutCheckIcon() {
        self.containerView.addSubview(self.checkIcon)
        self.checkIcon.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(dimension.mediumMargin)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(26)
        }
    }
    
    private func layoutTitleLabel() {
        self.containerView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self.checkIcon.snp.trailing).offset(dimension.normalMargin)
            make.centerY.equalToSuperview()
        }
    }
    
}
