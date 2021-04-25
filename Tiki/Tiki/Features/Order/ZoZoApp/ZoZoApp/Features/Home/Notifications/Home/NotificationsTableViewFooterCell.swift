//
//  NotificationsTableViewFooterCell.swift
//  ZoZoApp
//
//  Created by Dang Trung Hieu on 8/29/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

protocol NotificationsTableViewDelegateCell: class{
    func didSelectSeeMore(with notificationType: NotificationsViewController.NotificationType)
}

class NotificationsTableViewFooterCell: BaseTableViewHeaderFooter {
    
    // MARK: - Variables
    
    weak var delegate: NotificationsTableViewDelegateCell?
    var notificationType: NotificationsViewController.NotificationType = .order
    
    
    // MARK: - UI Elements
    
    fileprivate lazy var seemoreButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.seemore, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .medium)
        button.setTitleColor(UIColor.background, for: .normal)
        button.addTarget(self, action: #selector(tapOnSeeMoreButton), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var lineBottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightSeparator
        return view
    }()
    
    // MARK: - View LifeCycles
    
    override func initialize() {
        contentView.backgroundColor = UIColor.white
        super.initialize()
        layoutSeemoreButton()
        layoutLineBottomView()
    }
    
    // MARK: - UI Actions
    
    @objc private func tapOnSeeMoreButton() {
        delegate?.didSelectSeeMore(with: notificationType)
    }
    
    // MARK: - Public Method
    
    // MARK: - Setup layouts
    
    private func layoutSeemoreButton() {
        addSubview(seemoreButton)
        seemoreButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalToSuperview()
        }
    }
    
    private func layoutLineBottomView() {
        addSubview(lineBottomView)
        lineBottomView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
            make.width.equalToSuperview()
        }
    }
}
