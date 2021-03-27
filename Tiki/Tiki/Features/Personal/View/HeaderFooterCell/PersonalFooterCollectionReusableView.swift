//
//  PersonalFooterCollectionReusableView.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 3/23/21.
//

import UIKit

class PersonalFooterCollectionReusableView: BaseCollectionViewHeaderFooterCell {
    
    // MARK: - Variables
    
    // MARK: - UI Elements
    
    fileprivate lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.logOut, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.layer.borderColor = UIColor.background.cgColor
        button.layer.borderWidth = 0.3
        button.backgroundColor = UIColor.white
        button.titleLabel?.textColor = UIColor.background
        return button
    }()
    
    
    // MARK: - View LifeCycles

    override func initialize() {
        super.initialize()
        layoutLogoutButton()
    }
    
    // MARK: - Helper Method
    
    // MARK: - GET API
    
    // MARK: - Layout
    
    private func layoutLogoutButton() {
        addSubview(logoutButton)
        logoutButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(Dimension.shared.normalMargin)
            make.right.equalToSuperview().offset(-Dimension.shared.normalMargin)
            make.height.equalTo(40)
        }
    }
}
