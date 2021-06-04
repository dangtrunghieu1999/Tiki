//
//  AddressOrderCollectionViewCell.swift
//  Tiki
//
//  Created by Bee_MacPro on 03/06/2021.
//

import UIKit

class AddressCollectionViewCell: BaseCollectionViewCell {
    
    
    fileprivate lazy var topView: BaseView = {
        let view = BaseView()
        return view
    }()
    
    fileprivate lazy var addressTitleLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.addressRecive
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        return label
    }()
    
    fileprivate lazy var infoUserLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .semibold)
        label.text = "Đặng Trung Hiếu - 0336665653"
        label.textAlignment = .left
        return label
    }()

    fileprivate lazy var changeButton: UIButton = {
        let button = UIButton()
        button.layer.backgroundColor = UIColor.clear.cgColor
        button.setTitle(TextManager.changeAction, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        button.setTitleColor(UIColor.tabbarIcon, for: .normal)
        button.addTarget(self, action: #selector(tapOnChangeAddress), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var lineView: BaseView = {
        let view = BaseView()
        view.backgroundColor = UIColor.separator
        return view
    }()
    
    fileprivate lazy var addressDetailLabel: UILabel = {
        let label = UILabel()
        label.text = "Hẻm 457 Huỳnh Tấn Phát, phường Tân Thuận Đông, Quận7, Hồ Chí Minh"
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        label.numberOfLines = 0
        return label
    }()
    
    override func initialize() {
        super.initialize()
        layoutTopView()
        layoutLineView()
        layoutAddressTitleLabel()
        layoutChangeButton()
        layoutInfoUserLabel()
        layoutAddressDetailLabel()
    }
    
    @objc private func tapOnChangeAddress() {
//        let vc = DeliveryAddressViewController()
//        vc.requestShipAddressAPI()
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func layoutTopView() {
        addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(120)
        }
    }
    
    private func layoutAddressTitleLabel() {
        topView.addSubview(addressTitleLabel)
        addressTitleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
                .offset(dimension.normalMargin)
            make.top.equalToSuperview().offset(dimension.normalMargin)
        }
    }
    
    private func layoutChangeButton() {
        topView.addSubview(changeButton)
        changeButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
                .offset(-dimension.normalMargin)
            make.height.equalTo(40)
            make.top.equalToSuperview()
                .offset(dimension.smallMargin)
        }
    }
    
    private func layoutInfoUserLabel() {
        topView.addSubview(infoUserLabel)
        infoUserLabel.snp.makeConstraints { (make) in
            make.left.equalTo(addressTitleLabel)
            make.top.equalTo(addressTitleLabel.snp.bottom)
                .offset(dimension.mediumMargin)
        }
    }
    
    private func layoutAddressDetailLabel() {
        topView.addSubview(addressDetailLabel)
        addressDetailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(addressTitleLabel)
            make.right.equalToSuperview()
                .offset(-dimension.normalMargin)
            make.top.equalTo(infoUserLabel.snp.bottom)
                .offset(dimension.smallMargin)
        }
    }
    
    private func layoutLineView() {
        topView.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(8)
        }
    }
    
    
}
