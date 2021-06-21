//
//  SelectShipAddressTableViewCell.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 5/6/21.
//

import UIKit

class SelectShipAddressTableViewCell: BaseTableViewCell {
    
    // MARK: - Variables
    
    // MARK: - UI Elements
    
    private lazy var checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = ImageManager.checkMarkUnCheck
        return imageView
    }()
    
    fileprivate lazy var infoUserLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .semibold)
        label.textAlignment = .left
        return label
    }()
    
    fileprivate lazy var addressDetailLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        label.numberOfLines = 0
        return label
    }()
    
    fileprivate lazy var configAddressButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.config_address, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    fileprivate lazy var bottomLineView: BaseView = {
        let view = BaseView()
        view.backgroundColor = UIColor.separator
        return view
    }()
    
    private lazy var flagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = ImageManager.icon_flag
        return imageView
    }()
    
    fileprivate lazy var addressDefaultLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.addressDefault
        label.textColor = UIColor.background
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        return label
    }()
    
    // MARK: - View LifeCycles
    
    override func initialize() {
        super.initialize()
        layoutCheckImageView()
        layoutInfoUserLabel()
        layoutConfigAddressButton()
        layoutAddressDetailLabel()
        layoutbottomLineView()
        layoutFlagImageView()
        layoutAddressDefaultLabel()
    }
    
    // MARK: - UI Action
    
    // MARK: - Helper Method
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                checkImageView.image = ImageManager.checkMarkCheck
            } else {
                checkImageView.image = ImageManager.checkMarkUnCheck
            }
        }
    }
    
    func configData(_ delivery: DeliveryInformation, index: Int) {
        if index != 0 {
            flagImageView.isHidden = true
            addressDefaultLabel.isHidden = true
        }
        
        self.infoUserLabel.text      = delivery.info
        self.addressDetailLabel.text = delivery.recive
    }
    
    // MARK: - GET API
    
    // MARK: - Layout
    
    private func layoutCheckImageView() {
        addSubview(checkImageView)
        checkImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(22)
            make.left.equalToSuperview()
                .offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutInfoUserLabel() {
        addSubview(infoUserLabel)
        infoUserLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
                .offset(Dimension.shared.normalMargin)
            make.left.equalTo(checkImageView.snp.right)
                .offset(Dimension.shared.normalMargin)
            make.right.equalToSuperview()
                .offset(-Dimension.shared.normalMargin)
        }
    }
    
    private func layoutConfigAddressButton() {
        addSubview(configAddressButton)
        configAddressButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
                .offset(-Dimension.shared.normalMargin)
            make.width.height.equalTo(22)
            make.centerY.equalToSuperview()
        }
    }
    
    private func layoutAddressDetailLabel() {
        addSubview(addressDetailLabel)
        addressDetailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(infoUserLabel)
            make.top.equalTo(infoUserLabel.snp.bottom)
                .offset(Dimension.shared.mediumMargin)
            make.right.equalTo(configAddressButton.snp.left)
                .offset(-Dimension.shared.normalMargin)
        }
    }
    
    private func layoutFlagImageView() {
        addSubview(flagImageView)
        flagImageView.snp.makeConstraints { (make) in
            make.left.equalTo(infoUserLabel)
            make.width.height.equalTo(14)
            make.top.equalTo(addressDetailLabel.snp.bottom)
                .offset(Dimension.shared.mediumMargin)
        }
    }
    
    private func layoutAddressDefaultLabel() {
        addSubview(addressDefaultLabel)
        addressDefaultLabel.snp.makeConstraints { (make) in
            make.left.equalTo(flagImageView.snp.right)
                .offset(Dimension.shared.mediumMargin)
            make.right.equalToSuperview()
            make.top.equalTo(flagImageView)
        }
    }
    
    private func layoutbottomLineView() {
        addSubview(bottomLineView)
        bottomLineView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
            make.left.equalTo(checkImageView.snp.right)
                .offset(Dimension.shared.normalMargin)
            make.right.equalToSuperview()
        }
    }
    
}
