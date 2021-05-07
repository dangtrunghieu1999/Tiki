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
        imageView.image = ImageManager.checkMarkCheck
        return imageView
    }()
    
    fileprivate lazy var infoUserLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .semibold)
        label.text = "Đặng Trung Hiếu - 0336665653"
        label.textAlignment = .left
        return label
    }()

    fileprivate lazy var addressDetailLabel: UILabel = {
        let label = UILabel()
        label.text = "Hẻm 457 Huỳnh Tấn Phát, phường Tân Thuận Đông, Quận7, Hồ Chí Minh"
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

    // MARK: - View LifeCycles
    
    override func initialize() {
        super.initialize()
        layoutCheckImageView()
        layoutInfoUserLabel()
        layoutConfigAddressButton()
        layoutAddressDetailLabel()
        layoutbottomLineView()
    }
    
    // MARK: - Helper Method
    
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
                .offset(Dimension.shared.normalMargin)
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
