//
//  OrderInfomationViewController.swift
//  ZoZoApp
//
//  Created by Dang Trung Hieu on 8/20/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DeliveryInfomationViewController: BaseViewController {
    
    private (set) var deliveryInformation = DeliveryInformation()
    
    // MARK: - Variables
    
    // MARK: - UI Elements
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.enterAddressRecive
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue,
                                       weight: .semibold)
        return label
    }()
    
    fileprivate lazy var fullNameReciveTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.titleText = TextManager.fullNameRecive
        
        textField.textField
        .fontPlaceholder(text: TextManager.fullNamePlaceholder.localized(),
        size: FontSize.h1.rawValue)
        textField.addTarget(self,
                            action: #selector(textFieldValueChange(_:)),
                            for: .editingChanged)
        return textField
    }()
    
    fileprivate lazy var phoneReciveTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.titleText = TextManager.phoneNumber
        
        textField.textField
        .fontPlaceholder(text: TextManager.phoneNumberPlaceholder.localized(),
        size: FontSize.h1.rawValue)
        
        textField.addTarget(self,
                            action: #selector(textFieldValueChange(_:)),
                            for: .editingChanged)
        return textField
    }()
    
    fileprivate lazy var addressReciveTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.titleText = TextManager.addressRecive
        
        textField.textField
        .fontPlaceholder(text: TextManager.addressPlaceholder.localized(),
        size: FontSize.h1.rawValue)
        
        textField.addTarget(self,
                            action: #selector(textFieldValueChange(_:)),
                            for: .editingChanged)
        return textField
    }()
    
    fileprivate lazy var provinceTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.titleText = TextManager.provinceCity.localized()
        textField.rightTextfieldImage = ImageManager.dropDown
        
        textField.textField
        .fontPlaceholder(text: TextManager.provinceCity.localized(),
        size: FontSize.h1.rawValue)
        
        textField.addTarget(self,
                            action: #selector(textFieldBeginEditing(_:)),
                            for: .editingDidBegin)
        return textField
    }()
    
    fileprivate lazy var districtTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.titleText = TextManager.district.localized()
        textField.rightTextfieldImage = ImageManager.dropDown
        
        textField.textField
        .fontPlaceholder(text: TextManager.district.localized(),
        size: FontSize.h1.rawValue)
        
        textField.addTarget(self,
                            action: #selector(textFieldBeginEditing(_:)),
                            for: .editingDidBegin)
        textField.addTarget(self,
                            action: #selector(textFieldValueChange(_:)),
                            for: .valueChanged)
        return textField
    }()
    
    fileprivate lazy var wardTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.textField.fontPlaceholder(text: TextManager.ward.localized(),
                                                size: FontSize.h1.rawValue)
        textField.titleText = TextManager.ward.localized()
        textField.rightTextfieldImage = ImageManager.dropDown

        textField.addTarget(self,
                            action: #selector(textFieldValueChange(_:)),
                            for: .valueChanged)
        textField.addTarget(self,
                            action: #selector(textFieldBeginEditing(_:)),
                            for: .editingDidBegin)
        return textField
    }()
    
    fileprivate lazy var bottomView: BaseView = {
        let view = BaseView()
        view.addTopBorder(with: UIColor.separator, andWidth: 1)
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var shipAddressButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.shipAddress, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.disable
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Dimension.shared.cornerRadiusSmall
        return button
    }()
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = TextManager.addressRecive
        layoutBottomView()
        layoutShipAddressButton()
        layoutScrollView()
        layoutTitleLabel()
        layoutFullNameReciveTitleLabel()
        layoutPhoneNumberReciveTitleLabel()
        layoutAddressReciveTitleLabel()
        layoutProvinceCityTitleLabel()
        layoutDistrictCityTitleLabel()
        layoutWardCityTitleLabel()
    }
    
    // MARK: - Helper Method
    
    @objc private func textFieldBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        let vc = LocationViewController()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func textFieldValueChange(_ textField: UITextField) {
       
    }
    
    fileprivate func checkValidDeliveryInfo() {
        if deliveryInformation.isValidInfo {
            shipAddressButton.isUserInteractionEnabled = true
            shipAddressButton.backgroundColor = UIColor.primary
            shipAddressButton.setTitleColor(UIColor.white, for: .normal)
        } else {
            shipAddressButton.isUserInteractionEnabled = false
            shipAddressButton.backgroundColor = UIColor.disable
            shipAddressButton.setTitleColor(UIColor.bodyText, for: .normal)
        }
    }
    
    // MARK: - Layout
    
    private func layoutBottomView() {
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            if #available(iOS 11, *) {
                make.bottom
                    .equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom
                    .equalTo(bottomLayoutGuide.snp.top)
            }
            make.left
                .right
                .equalToSuperview()
            
            make.height.equalTo(68)
        }
    }
    
    private func layoutShipAddressButton() {
        bottomView.addSubview(shipAddressButton)
        shipAddressButton.snp.makeConstraints { (make) in
            make.left
                .right
                .equalToSuperview()
                .inset(dimension.normalMargin)
            make.height
                .equalTo(dimension.defaultHeightButton)
            make.bottom
                .equalToSuperview()
                .offset(-dimension.mediumMargin)
        }
    }
    
    override internal func layoutScrollView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            if #available(iOS 11, *) {
                make.top
                    .equalTo(view.safeAreaLayoutGuide)
                    .offset(dimension.normalMargin)
            } else {
                make.top
                    .equalTo(topLayoutGuide.snp.bottom)
                    .offset(dimension.normalMargin)
            }
            make.left
                .right
                .equalToSuperview()
            make.bottom
                .equalTo(bottomView.snp.top)
        }
    }
    
    private func layoutTitleLabel() {
        scrollView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left
                .equalTo(view)
                .offset(dimension.normalMargin)
            make.right
                .equalTo(view)
                .offset(-dimension.normalMargin)
            make.top.equalToSuperview()
        }
    }
    
    private func layoutFullNameReciveTitleLabel() {
        scrollView.addSubview(fullNameReciveTextField)
        fullNameReciveTextField.snp.makeConstraints { (make) in
            make.left
                .right
                .equalTo(titleLabel)
            make.top
                .equalTo(titleLabel.snp.bottom)
                .offset(dimension.normalMargin)
        }
    }
    
    private func layoutPhoneNumberReciveTitleLabel() {
        scrollView.addSubview(phoneReciveTextField)
        phoneReciveTextField.snp.makeConstraints { (make) in
            make.left
                .right
                .equalTo(fullNameReciveTextField)
            make.top
                .equalTo(fullNameReciveTextField.snp.bottom)
                .offset(dimension.normalMargin)
        }
    }
    
    private func layoutAddressReciveTitleLabel() {
        scrollView.addSubview(addressReciveTextField)
        addressReciveTextField.snp.makeConstraints { (make) in
            make.left
                .right
                .equalTo(fullNameReciveTextField)
            make.top
                .equalTo(phoneReciveTextField.snp.bottom)
                .offset(dimension.normalMargin)
        }
    }
    
    private func layoutProvinceCityTitleLabel() {
        scrollView.addSubview(provinceTextField)
        provinceTextField.snp.makeConstraints { (make) in
            make.left
                .right
                .equalTo(fullNameReciveTextField)
            make.top
                .equalTo(addressReciveTextField.snp.bottom)
                .offset(dimension.normalMargin)
        }
    }
    
    private func layoutDistrictCityTitleLabel() {
        scrollView.addSubview(districtTextField)
        districtTextField.snp.makeConstraints { (make) in
            make.left
                .right
                .equalTo(fullNameReciveTextField)
            make.top
                .equalTo(provinceTextField.snp.bottom)
                .offset(dimension.normalMargin)
        }
    }
    
    private func layoutWardCityTitleLabel() {
        scrollView.addSubview(wardTextField)
        wardTextField.snp.makeConstraints { (make) in
            make.left
                .right
                .equalTo(fullNameReciveTextField)
            make.top.equalTo(districtTextField.snp.bottom)
                .offset(dimension.normalMargin)
            make.bottom.equalToSuperview()
        }
    }
    
}

// MARK: - LocationViewControllerDelegate

extension DeliveryInfomationViewController: LocationViewControllerDelegate {
    
    func finishSelectLocation(_ deliveryInfo: DeliveryInformation) {
        self.deliveryInformation = deliveryInfo
        self.provinceTextField.text = deliveryInformation.province?.name
        self.districtTextField.text = deliveryInformation.district?.name
        self.wardTextField.text     = deliveryInformation.ward?.name
    }
}
