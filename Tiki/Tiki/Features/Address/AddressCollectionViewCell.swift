//
//  AddressOrderCollectionViewCell.swift
//  Tiki
//
//  Created by Bee_MacPro on 03/06/2021.
//

import UIKit

protocol AddressCollectionViewCellDelegate: class {
    func didSelectAddress()
}

class AddressCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Define Variables
    
    weak var delegate: AddressCollectionViewCellDelegate?
    
    var hiddenButton: Bool = false {
        didSet {
            self.changeButton.isHidden = hiddenButton
        }
    }
    
    // MARK: - UI Elements

    fileprivate lazy var addressTitleLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.addressRecive
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        return label
    }()
    
    fileprivate lazy var infoUserLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .semibold)
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
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        label.numberOfLines = 0
        return label
    }()
    
    override func initialize() {
        super.initialize()
        layoutAddressTitleLabel()
        layoutChangeButton()
        layoutInfoUserLabel()
        layoutAddressDetailLabel()
    }
    
    func configCell(with infoUser: String,
                    addressRecive: String) {
        
        self.infoUserLabel.text      = infoUser
        self.addressDetailLabel.text = addressRecive
    }
    
    @objc private func tapOnChangeAddress() {
        self.delegate?.didSelectAddress()
    }
    
    private func layoutAddressTitleLabel() {
        addSubview(addressTitleLabel)
        addressTitleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
                .offset(dimension.normalMargin)
            make.top.equalToSuperview().offset(dimension.normalMargin)
        }
    }
    
    private func layoutChangeButton() {
        addSubview(changeButton)
        changeButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
                .offset(-dimension.normalMargin)
            make.height.equalTo(40)
            make.top.equalToSuperview()
                .offset(dimension.smallMargin)
        }
    }
    
    private func layoutInfoUserLabel() {
        addSubview(infoUserLabel)
        infoUserLabel.snp.makeConstraints { (make) in
            make.left.equalTo(addressTitleLabel)
            make.top.equalTo(addressTitleLabel.snp.bottom)
                .offset(dimension.mediumMargin)
        }
    }
    
    private func layoutAddressDetailLabel() {
        addSubview(addressDetailLabel)
        addressDetailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(addressTitleLabel)
            make.right.equalToSuperview()
                .offset(-dimension.normalMargin)
            make.top.equalTo(infoUserLabel.snp.bottom)
                .offset(dimension.smallMargin)
        }
    }

}
