//
//  AddressReciveCollectionViewCell.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 4/29/21.
//

import UIKit

class AddressReciveCollectionViewCell: BaseCollectionViewCell {
    // MARK: - Variables
    
    // MARK: - UI Elements
    
    fileprivate lazy var addressTitleLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.addressRecive
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .bold)
        return label
    }()
    
    fileprivate lazy var infoUserLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .bold)
        label.text = "Đặng Trung Hiếu - 0336665653"
        label.textAlignment = .left
        return label
    }()

    fileprivate lazy var changeButton: UIButton = {
        let button = UIButton()
        button.layer.backgroundColor = UIColor.clear.cgColor
        button.setTitle(TextManager.changeAction, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        button.setTitleColor(UIColor.tabbarIcon, for: .normal)
        button.addTarget(self, action: #selector(tapOnChangeAddress), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var addressDetailLabel: UILabel = {
        let label = UILabel()
        label.text = "Hẻm 457 Huỳnh Tấn Phát, phường Tân Thuận Đông, Quận7, Hồ Chí Minh"
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - View LifeCycles
    
    override func initialize() {
        super.initialize()
        layoutAddressTitleLabel()
        layoutChangeButton()
        layoutInfoUserLabel()
        layoutAddressDetailLabel()
    }
    
    // MARK: - UI Action
    
    @objc private func tapOnChangeAddress() {
        
    }
    
    // MARK: - Helper Method
    
    // MARK: - GET API
    
    // MARK: - Layout
    
    private func layoutAddressTitleLabel() {
        addSubview(addressTitleLabel)
        addressTitleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Dimension.shared.normalMargin)
            make.top.equalToSuperview().offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutChangeButton() {
        addSubview(changeButton)
        changeButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-Dimension.shared.normalMargin)
            make.height.equalTo(40)
            make.top.equalToSuperview().offset(Dimension.shared.normalMargin)
            make.width.equalTo(100)
        }
    }
    
    private func layoutInfoUserLabel() {
        addSubview(infoUserLabel)
        infoUserLabel.snp.makeConstraints { (make) in
            make.left.equalTo(addressTitleLabel)
            make.top.equalTo(addressTitleLabel.snp.bottom).offset(Dimension.shared.mediumMargin)
        }
    }
    
    private func layoutAddressDetailLabel() {
        addSubview(addressDetailLabel)
        addressDetailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(addressTitleLabel)
            make.right.equalToSuperview().offset(-Dimension.shared.normalMargin)
            make.top.equalTo(infoUserLabel.snp.bottom).offset(Dimension.shared.smallMargin)
        }
    }
}
