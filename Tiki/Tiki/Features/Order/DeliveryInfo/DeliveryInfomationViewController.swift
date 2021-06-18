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
    
    private (set) var deliveryInformation      = DeliveryInformation()
    private (set) var provinces:    [Province] = []
    private (set) var districts:    [District] = []
    private (set) var wards:        [Ward]     = []
    private (set) var isWaitingLoadDistrict    = false
    private (set) var isWaitingLoadWard        = false
    
    // MARK: - Variables
    
    fileprivate lazy var provincePickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    fileprivate lazy var districtPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    fileprivate lazy var wardPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    // MARK: - UI Elements
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.enterAddressRecive
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue,
                                       weight: .semibold)
        return label
    }()
    
    fileprivate lazy var fullNameReciveTextField: TitleTextField = {
        let label = TitleTextField()
        label.titleText = TextManager.fullNameRecive
        label.textField.fontSizePlaceholder(text: TextManager.fullNamePlaceholder,
                                      size: FontSize.h1.rawValue)
        return label
    }()
    
    fileprivate lazy var phoneReciveTextField: TitleTextField = {
        let label = TitleTextField()
        label.titleText = TextManager.phoneNumber
        label.textField.fontSizePlaceholder(text: TextManager.phoneNumberPlaceholder,
                                      size: FontSize.h1.rawValue)
        return label
    }()
    
    fileprivate lazy var addressReciveTextField: TitleTextField = {
        let label = TitleTextField()
        label.titleText = TextManager.addressRecive
        label.textField.fontSizePlaceholder(text: TextManager.addressPlaceholder,
                                      size: FontSize.h1.rawValue)
        return label
    }()
    
    fileprivate lazy var provinceTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.textField.fontSizePlaceholder(text: TextManager.provinceCity.localized(),
                                                size: FontSize.h1.rawValue)
        textField.titleText = TextManager.provinceCity.localized()
        textField.rightTextfieldImage = ImageManager.dropDown
        textField.textFieldInputView = provincePickerView
        textField.addTarget(self,
                            action: #selector(textFieldBeginEditing(_:)),
                            for: .editingDidBegin)
        textField.addTarget(self,
                            action: #selector(textFieldDidEndEditing(_:)),
                            for: .editingDidEnd)
        return textField
    }()
    
    fileprivate lazy var districtTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.textField.fontSizePlaceholder(text: TextManager.district.localized(),
                                                size: FontSize.h1.rawValue)
        textField.titleText = TextManager.district.localized()
        textField.rightTextfieldImage = ImageManager.dropDown
        textField.isUserInteractionEnabled = false
        textField.textField.backgroundColor = UIColor.lightSeparator
        textField.textFieldInputView = districtPickerView
        textField.addTarget(self,
                            action: #selector(textFieldBeginEditing(_:)),
                            for: .editingDidBegin)
        textField.addTarget(self,
                            action: #selector(textFieldDidEndEditing(_:)),
                            for: .editingDidEnd)
        return textField
    }()
    
    fileprivate lazy var wardTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.textField.fontSizePlaceholder(text: TextManager.ward.localized(),
                                                size: FontSize.h1.rawValue)
        textField.titleText = TextManager.ward.localized()
        textField.rightTextfieldImage = ImageManager.dropDown
        textField.isUserInteractionEnabled = false
        textField.textField.backgroundColor = UIColor.lightSeparator
        textField.textFieldInputView = wardPickerView
        textField.addTarget(self,
                            action: #selector(textFieldValueChange(_:)),
                            for: .valueChanged)
        textField.addTarget(self,
                            action: #selector(textFieldBeginEditing(_:)),
                            for: .editingDidBegin)
        textField.addTarget(self,
                            action: #selector(textFieldDidEndEditing(_:)),
                            for: .editingDidEnd)
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
        getAPIAllProvince()
    }
    
    // MARK: - Helper Method
    
    @objc private func textFieldBeginEditing(_ textField: UITextField) {
       
    }
    
    @objc private func textFieldValueChange(_ textField: UITextField) {
       
    }
    
    @objc private func textFieldDidEndEditing(_ textField: UITextField) {
       
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
    
    // MARK: - GET API
    
    private func getAPIAllProvince() {
        let path = "https://api.mysupership.vn/v1/partner/areas/province"
        guard let url  = URL(string: path) else { return }
       
        Alamofire.request(url).responseJSON { (response) in
            switch response.result {
            case.success(let value):
                let json = JSON(value)
                let results = json["results"]
                self.provinces = results.arrayValue.map{ Province(json: $0) }
            case .failure(let error):
                print(error)
            }
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
                .offset(-dimension.largeMargin_38)
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
                .offset(dimension.largeMargin_32)
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
                .offset(dimension.largeMargin_32)
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
                .offset(dimension.largeMargin_32)
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
                .offset(dimension.largeMargin_32)
        }
    }
    
    private func layoutWardCityTitleLabel() {
        scrollView.addSubview(wardTextField)
        wardTextField.snp.makeConstraints { (make) in
            make.left
                .right
                .equalTo(fullNameReciveTextField)
            make.top.equalTo(districtTextField.snp.bottom)
                .offset(dimension.largeMargin_32)
            make.bottom.equalToSuperview()
        }
    }
    
}

// MARK: - UITextViewDelegate


// MARK: - UIPickerViewDelegate

extension DeliveryInfomationViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int,
                    inComponent component: Int) {
        if pickerView == provincePickerView {
            provinceTextField.textField.text = provinces[safe:row]?.name ?? ""
            deliveryInformation.province = provinces[safe:row]
        } else if pickerView == districtPickerView {
            districtTextField.textField.text = districts[safe:row]?.name ?? ""
            deliveryInformation.district = districts[safe:row]
        } else if pickerView == wardPickerView {
            wardTextField.textField.text = wards[safe:row]?.name ?? ""
            deliveryInformation.ward = wards[safe:row]
        }
    }
}

// MARK: - UIPickerViewDatasource

extension DeliveryInfomationViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        if pickerView == provincePickerView {
            return provinces.count
        } else if pickerView == districtPickerView {
            return districts.count
        } else {
            return wards.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int,
                    forComponent component: Int) -> String? {
        if pickerView == provincePickerView {
            return provinces[safe: row]?.name
        } else if pickerView == districtPickerView {
            return districts[safe: row]?.name
        } else {
            return wards[safe: row]?.name
        }
    }
}
