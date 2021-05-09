//
//  OrderInfomationViewController.swift
//  ZoZoApp
//
//  Created by Dang Trung Hieu on 8/20/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class DeliveryInfomationViewController: BaseViewController {
    
    // MARK: - Variables
    
    private (set) var deliveryInformation      = DeliveryInformation()
    private (set) var provinces:    [Province] = []
    private (set) var districts:    [District] = []
    private (set) var wards:        [Ward]     = []
    private (set) var isWaitingLoadDistrict    = false
    private (set) var isWaitingLoadWard        = false
    
    // MARK: - UI Elements
    
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
    
    fileprivate lazy var containerView: BaseView = {
        let view = BaseView()
        return view
    }()
    
    fileprivate lazy var emailTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.placeholder = TextManager.emailPlaceholder.localized()
        textField.titleText = TextManager.email.localized()
        textField.keyboardType = .emailAddress
        textField.addTarget(self,
                            action: #selector(textFieldValueChange(_:)),
                            for: .editingChanged)
        textField.addTarget(self,
                            action: #selector(textFieldDidEndEditing(_:)),
                            for: .editingDidEnd)
        return textField
    }()
    
    fileprivate lazy var fullNameTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.placeholder = TextManager.fullNamePlaceholder.localized()
        textField.titleText = TextManager.fullName.localized()
        textField.addTarget(self,
                            action: #selector(textFieldValueChange(_:)),
                            for: .editingChanged)
        textField.addTarget(self,
                            action: #selector(textFieldDidEndEditing(_:)),
                            for: .editingDidEnd)
        return textField
    }()
    
    fileprivate lazy var phoneNumberTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.placeholder = TextManager.phoneNumberPlaceholder.localized()
        textField.titleText = TextManager.phoneNumber.localized()
        textField.keyboardType = .numberPad
        textField.addTarget(self,
                            action: #selector(textFieldValueChange(_:)),
                            for: .editingChanged)
        textField.addTarget(self,
                            action: #selector(textFieldDidEndEditing(_:)),
                            for: .editingDidEnd)
        return textField
    }()
    
    fileprivate lazy var addressTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.placeholder = TextManager.addressPlaceholder.localized()
        textField.titleText = TextManager.address.localized()
        textField.addTarget(self,
                            action: #selector(textFieldValueChange(_:)),
                            for: .editingChanged)
        textField.addTarget(self,
                            action: #selector(textFieldDidEndEditing(_:)),
                            for: .editingDidEnd)
        return textField
    }()
    
    fileprivate lazy var provinceTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.placeholder = TextManager.provinceCity.localized()
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
        textField.placeholder = TextManager.district.localized()
        textField.titleText = TextManager.district.localized()
        textField.rightTextfieldImage = ImageManager.dropDown
        textField.isUserInteractionEnabled = false
        textField.textField.backgroundColor = UIColor.lightDisable
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
        textField.placeholder = TextManager.ward.localized()
        textField.titleText = TextManager.ward.localized()
        textField.rightTextfieldImage = ImageManager.dropDown
        textField.isUserInteractionEnabled = false
        textField.textField.backgroundColor = UIColor.lightDisable
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
    
    fileprivate lazy var apartmentNumberTextView: UITextView = {
        let textView = UITextView()
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
        textView.text = TextManager.apartmentNumberStreet.localized()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = UIColor.placeholder
        textView.layer.borderColor = UIColor.separator.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 10
        textView.layer.masksToBounds = true
        textView.delegate = self
        return textView
    }()
    
    fileprivate lazy var apartmentNumberLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.apartmentNumberStreet.localized()
        label.font = UIFont.systemFont(ofSize: FontSize.body.rawValue)
        label.textColor = UIColor.titleText
        return label
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.accentColor
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = Dimension.shared.defaultHeightButton / 2
        button.layer.masksToBounds = true
        button.setTitle(TextManager.next.localized(), for: .normal)
        button.isUserInteractionEnabled = false
        button.backgroundColor = UIColor.disable
        button.addTarget(self, action: #selector(touchInNextButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = TextManager.deliveryInfomation.localized()
        
        layoutScrollView()
        layoutContainerView()
        layoutEmailTextField()
        layoutFullNameTextField()
        layoutPhoneNumberTextField()
        layoutAddressTextField()
        layoutProvinceCityTextField()
        layoutDistrictTextField()
        layoutWardTextField()
        layoutApartmentNumberLabel()
        layoutApartmentNumberTextView()
        layoutNextButton()
        
        getAPIAllProvince()
        autoFillDeliveryInfoIfNeeded()
    }
    
    // MARK: - Request APIs
    
    private func getAPIAllProvince() {
        self.showLoading()
        let apiEndPoint = OrderEndPoint.getAllProvince
        
        APIService.request(endPoint: apiEndPoint, onSuccess: { (apiResponse) in
            self.provinces = apiResponse.toArray([Province.self])
            self.hideLoading()
        }, onFailure: { (apiError) in
            self.hideLoading()
        }) {
            self.hideLoading()
        }
    }
    
    private func getAPIDistrict() {
        guard let provinceId = deliveryInformation.province?.id else { return }
        
        let params = ["provinceId": provinceId, "limitRecord": 300]
        let endPoint = OrderEndPoint.getDistrictByProvince(parans: params)
        self.showLoading()
        
        APIService.request(endPoint: endPoint, onSuccess: { (apiResponse) in
            self.districts = apiResponse.toArray([District.self])
            self.hideLoading()
            if self.isWaitingLoadDistrict {
                self.isWaitingLoadDistrict = false
                self.districtTextField.textField.becomeFirstResponder()
            }
        }, onFailure: { (apiError) in
            self.hideLoading()
        }) {
            self.hideLoading()
        }
    }
    
    private func getAPIWards() {
        guard let provinceId = deliveryInformation.province?.id,
            let districtId = deliveryInformation.district?.id else {
                return
        }
        
        let params = ["provinceId": provinceId, "districtId": districtId,
                      "limitRecord": 300]
        let endPoint = OrderEndPoint.getWardByProvinceIdAndDistrictId(parans: params)
        self.showLoading()
        
        APIService.request(endPoint: endPoint, onSuccess: { (apiResponse) in
            self.wards = apiResponse.toArray([Ward.self])
            self.hideLoading()
            if self.isWaitingLoadWard {
                self.isWaitingLoadWard = false
                self.wardTextField.textField.becomeFirstResponder()
            }
        }, onFailure: { (apiError) in
            self.hideLoading()
        }) {
            self.hideLoading()
        }
    }
    
    // MARK: - UI Actions
    
    @objc private func touchInNextButton() {
        OrderManager.shared.setDeliveryInfomation(deliveryInformation)
        let viewController = TransportersViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc private func textFieldBeginEditing(_ textField: UITextField) {
        if textField == provinceTextField.textField {
            if let province = deliveryInformation.province,
                let index = provinces.firstIndex(where: { $0.id == province.id }) {
                provincePickerView.selectRow(index, inComponent: 0, animated: false)
            } else {
                provinceTextField.textField.text = provinces.first?.name
                deliveryInformation.province = provinces.first
            }
            
        } else if textField == districtTextField.textField {
            if districts.isEmpty {
                isWaitingLoadDistrict = true
                getAPIDistrict()
                return
            }
            
            if let district = deliveryInformation.district,
                let index = districts.firstIndex(where: { $0.id == district.id }) {
                districtPickerView.selectRow(index, inComponent: 0, animated: false)
            } else {
                districtTextField.textField.text = districts.first?.name
                deliveryInformation.district = districts.first
            }
            
        } else if textField == wardTextField.textField  {
            if wards.isEmpty {
                isWaitingLoadWard = true
                getAPIWards()
                return
            }
            
            if let ward = deliveryInformation.ward,
                let index = wards.firstIndex(where: { $0.id == ward.id }) {
                wardPickerView.selectRow(index, inComponent: 0, animated: false)
            } else {
                wardTextField.textField.text = wards.first?.name
                deliveryInformation.ward = wards.first
            }
        }
    }
    
    @objc private func textFieldValueChange(_ textField: UITextField) {
        if textField == emailTextField.textField {
            deliveryInformation.email = textField.text ?? ""
        } else if textField == fullNameTextField.textField {
            deliveryInformation.fullName = textField.text ?? ""
        } else if textField == phoneNumberTextField.textField {
            deliveryInformation.phoneNumber = textField.text ?? ""
        } else if textField == addressTextField.textField {
            deliveryInformation.address = textField.text ?? ""
        }
        
        checkValidDeliveryInfo()
    }
    
    @objc private func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == provinceTextField.textField {
            getAPIDistrict()
            districtTextField.isUserInteractionEnabled = true
            districtTextField.textFieldBGColor = UIColor.clear
        } else if textField == districtTextField.textField {
            getAPIWards()
            wardTextField.isUserInteractionEnabled = true
            wardTextField.textFieldBGColor = UIColor.clear
        }
        
        checkValidDeliveryInfo()
    }
    
    // MARK: - Helper methods
    
    fileprivate func checkValidDeliveryInfo() {
        if deliveryInformation.isValidInfo {
            nextButton.isUserInteractionEnabled = true
            nextButton.backgroundColor = UIColor.accentColor
        } else {
            nextButton.isUserInteractionEnabled = false
            nextButton.backgroundColor = UIColor.disable
        }
    }
    
    private func autoFillDeliveryInfoIfNeeded() {
        guard let deliveryInfo      = OrderManager.shared.deliveryInformation else { return }
        deliveryInformation         = deliveryInfo
        emailTextField.text         = deliveryInformation.email
        fullNameTextField.text      = deliveryInformation.fullName
        phoneNumberTextField.text   = deliveryInformation.phoneNumber
        addressTextField.text       = deliveryInformation.address
        provinceTextField.text      = deliveryInformation.province?.name
        districtTextField.text      = deliveryInformation.district?.name
        wardTextField.text          = deliveryInformation.ward?.name
        apartmentNumberTextView.text = deliveryInformation.apartmentNumber
        
        districtTextField.textFieldBGColor          = UIColor.white
        districtTextField.isUserInteractionEnabled  = true
        wardTextField.textFieldBGColor              = UIColor.white
        wardTextField.isUserInteractionEnabled      = true
        apartmentNumberTextView.textColor           = UIColor.titleText
        nextButton.isUserInteractionEnabled         = true
        nextButton.backgroundColor                  = UIColor.accentColor
    }
    
    // MARK: - Setup Layouts
    
    private func layoutContainerView() {
        scrollView.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalToSuperview().offset(-Dimension.shared.normalMargin)
        }
    }
    
    private func layoutEmailTextField() {
        containerView.addSubview(emailTextField)
        emailTextField.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Dimension.shared.normalMargin)
            make.right.equalToSuperview().offset(-Dimension.shared.normalMargin)
            make.top.equalToSuperview().offset(Dimension.shared.largeMargin)
        }
    }
    
    private func layoutFullNameTextField() {
        containerView.addSubview(fullNameTextField)
        fullNameTextField.snp.makeConstraints { (make) in
            make.left.equalTo(emailTextField)
            make.right.equalTo(emailTextField)
            make.top.equalTo(emailTextField.snp.bottom)
                .offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutPhoneNumberTextField() {
        containerView.addSubview(phoneNumberTextField)
        phoneNumberTextField.snp.makeConstraints { (make) in
            make.left.equalTo(fullNameTextField)
            make.right.equalTo(fullNameTextField)
            make.top.equalTo(fullNameTextField.snp.bottom)
                .offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutAddressTextField() {
        containerView.addSubview(addressTextField)
        addressTextField.snp.makeConstraints { (make) in
            make.left.equalTo(phoneNumberTextField)
            make.right.equalTo(phoneNumberTextField)
            make.top.equalTo(phoneNumberTextField.snp.bottom)
                .offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutProvinceCityTextField() {
        containerView.addSubview(provinceTextField)
        provinceTextField.snp.makeConstraints { (make) in
            make.left.equalTo(addressTextField)
            make.right.equalTo(addressTextField)
            make.top.equalTo(addressTextField.snp.bottom)
                .offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutDistrictTextField() {
        containerView.addSubview(districtTextField)
        districtTextField.snp.makeConstraints { (make) in
            make.left.equalTo(provinceTextField)
            make.right.equalTo(provinceTextField)
            make.top.equalTo(provinceTextField.snp.bottom)
                .offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutWardTextField() {
        containerView.addSubview(wardTextField)
        wardTextField.snp.makeConstraints { (make) in
            make.left.equalTo(districtTextField)
            make.right.equalTo(districtTextField)
            make.top.equalTo(districtTextField.snp.bottom)
                .offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutApartmentNumberLabel() {
        containerView.addSubview(apartmentNumberLabel)
        apartmentNumberLabel.snp.makeConstraints { (make) in
            make.left.equalTo(wardTextField)
            make.right.equalTo(wardTextField)
            make.top.equalTo(wardTextField.snp.bottom)
                .offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutApartmentNumberTextView() {
        containerView.addSubview(apartmentNumberTextView)
        apartmentNumberTextView.snp.makeConstraints { (make) in
            make.left.equalTo(wardTextField)
            make.right.equalTo(wardTextField)
            make.height.equalTo(80)
            make.top.equalTo(apartmentNumberLabel.snp.bottom)
                .offset(Dimension.shared.mediumMargin)
        }
    }

    private func layoutNextButton() {
        containerView.addSubview(nextButton)
        nextButton.snp.makeConstraints { (make) in
            make.width.equalTo(Dimension.shared.mediumWidthButton)
            make.height.equalTo(Dimension.shared.defaultHeightButton)
            make.centerX.equalToSuperview()
            make.top.equalTo(apartmentNumberTextView.snp.bottom)
                .offset(Dimension.shared.normalMargin)
            make.bottom.equalToSuperview().offset(-Dimension.shared.normalMargin)
        }
    }
    
}

// MARK: - UITextViewDelegate

extension DeliveryInfomationViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == TextManager.apartmentNumberStreet.localized() {
            textView.text = ""
        }
        textView.textColor = UIColor.titleText
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = TextManager.apartmentNumberStreet.localized()
            textView.textColor = UIColor.placeholder
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text != TextManager.apartmentNumberStreet.localized() {
            deliveryInformation.apartmentNumber = textView.text
        }
        
        checkValidDeliveryInfo()
    }
}

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
