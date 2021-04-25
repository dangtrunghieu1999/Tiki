//
//  CreateShopViewController.swift
//  ZoZoApp
//
//  Created by MACOS on 6/9/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

@objc protocol CreateShopViewControllerDelegate: class {
    @objc optional func didCreateShopSuccess(with shopId: String)
    @objc optional func didUpdateShopSuccess(with shop: Shop)
}

class CreateShopViewController: BaseViewController {
    
    // MARK: - Variables
    
    fileprivate (set) var selectedProvince: Province?
    fileprivate (set) var selecteDistrict:  District?
    fileprivate (set) var selectedWard:     Ward?
    
    fileprivate (set) var provinces:    [Province] = []
    fileprivate (set) var districts:    [District] = []
    fileprivate (set) var wards:        [Ward]     = []
    fileprivate (set) var shop: Shop?
    
    weak var delegate: CreateShopViewControllerDelegate?
    
    var isEditShop: Bool {
        return shop != nil
    }
    
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
    
    fileprivate lazy var shopCodeTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.placeholder = TextManager.shopCode.localized()
        textField.titleText = TextManager.shopCode.localized()
        textField.textFieldBGColor = UIColor.disable.withAlphaComponent(0.4)
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    fileprivate lazy var shopNameTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.placeholder = TextManager.shopName.localized()
        textField.titleLabelAttributed = getRequiredAttibuted(from: TextManager.shopNameTitle.localized())
        textField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)
        return textField
    }()
    
    fileprivate lazy var displayNameTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.placeholder = TextManager.displayNameTitle.localized()
        textField.titleLabelAttributed = getRequiredAttibuted(from: TextManager.displayName.localized())
        textField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)
        return textField
    }()
    
    fileprivate lazy var phoneNumberTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.placeholder = TextManager.shopPhoneNumber.localized()
        textField.titleLabelAttributed = getRequiredAttibuted(from: TextManager.shopPhoneNumberTitle.localized())
        textField.keyboardType = .numberPad
        textField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)
        return textField
    }()
    
    private lazy var addressTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.titleText
        label.font = UIFont.systemFont(ofSize: FontSize.body.rawValue)
        label.attributedText = getRequiredAttibuted(from: TextManager.shopAddressTitle.localized())
        return label
    }()
    
    fileprivate lazy var addressTextView: UITextView = {
        let textView = UITextView()
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
        textView.text = TextManager.shopAddress.localized()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = UIColor.placeholder
        textView.layer.borderColor = UIColor.separator.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 10
        textView.layer.masksToBounds = true
        textView.delegate = self
        return textView
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
    
    fileprivate lazy var hotlineTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.placeholder = TextManager.shopHotline.localized()
        textField.titleLabelAttributed = getRequiredAttibuted(from: TextManager.shopHotlineTitle.localized())
        textField.keyboardType = .numberPad
        textField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)
        return textField
    }()
    
    fileprivate lazy var linkGGMapTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.placeholder = TextManager.shopGGMap.localized()
        textField.titleText = TextManager.shopGGMapTitle.localized()
        textField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)
        return textField
    }()
    
    fileprivate lazy var linkWebsiteTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.placeholder = TextManager.shopWebsite.localized()
        textField.titleText = TextManager.shopWebsiteTitle.localized()
        textField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)
        return textField
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.save.localized(), for: .normal)
        button.backgroundColor = UIColor.disable
        button.isUserInteractionEnabled = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = Dimension.shared.defaultHeightButton / 2
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(tapOnSaveButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isEditShop {
            navigationItem.title = TextManager.editShopInfo.localized()
        } else {
            navigationItem.title = TextManager.shopCreate.localized()
        }
        
        layoutScrollView()
        layoutShopCodeTextField()
        layoutShopNameTextField()
        layoutDisplayNameTextField()
        layoutPhoneNumberTextField()
        lauoutAddressTitleLabel()
        layoutAddressTextView()
        layoutProvinceTextField()
        layoutDistrictTextField()
        layoutWardTextField()
        layoutHotlineTextField()
        layoutLinkGGMapTextField()
        layoutLinkWebSiteTextField()
        layoutSaveButton()
        getAPIAllProvince()
    }
    
    // MARK: - Public methods
    
    func configData(_ shop: Shop?) {
        if let shop = shop {
            self.shop = shop
            shopNameTextField.textField.isUserInteractionEnabled = false
            shopNameTextField.textFieldBGColor = UIColor.disable.withAlphaComponent(0.4)
            navigationItem.title                = TextManager.editShopInfo.localized()
            
            shopCodeTextField.text     = shop.code
            shopNameTextField.text     = shop.name
            displayNameTextField.text  = shop.displayName
            phoneNumberTextField.text  = shop.mobile
            addressTextView.text                = shop.address
            hotlineTextField.text      = shop.hotline
            linkGGMapTextField.text    = shop.map
            linkWebsiteTextField.text  = shop.website
            
            // Provinve
            selectedProvince                    = Province()
            selectedProvince?.id                = shop.provinceId
            selectedProvince?.name              = shop.provinceName
            provinceTextField.textField.text    = shop.provinceName
            
            // District
            selecteDistrict                     = District()
            selecteDistrict?.id                 = shop.districtId
            selecteDistrict?.name               = shop.districtName
            districtTextField.textField.text    = shop.districtName
            
            // Ward
            selectedWard                        = Ward()
            selectedWard?.id                    = shop.wardId
            selectedWard?.name                  = shop.wardName
            wardTextField.textField.text        = shop.wardName
            
            // Enable Address TextView
            addressTextView.textColor           = UIColor.titleText
        }
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
        guard let provinceId = selectedProvince?.id else { return }
        let params = ["provinceId": provinceId, "limitRecord": 300]
        let endPoint = OrderEndPoint.getDistrictByProvince(parans: params)
        self.showLoading()
        
        APIService.request(endPoint: endPoint, onSuccess: { (apiResponse) in
            self.districts = apiResponse.toArray([District.self])
            self.hideLoading()
        }, onFailure: { (apiError) in
            self.hideLoading()
        }) {
            self.hideLoading()
        }
    }
    
    private func getAPIWards() {
        guard let provinceId = selectedProvince?.id, let districtId = selecteDistrict?.id else {
            return
        }
        
        let params = ["provinceId": provinceId, "districtId": districtId, "limitRecord": 300]
        let endPoint = OrderEndPoint.getWardByProvinceIdAndDistrictId(parans: params)
        self.showLoading()
        
        APIService.request(endPoint: endPoint, onSuccess: { (apiResponse) in
            self.wards = apiResponse.toArray([Ward.self])
            self.hideLoading()
        }, onFailure: { (apiError) in
            self.hideLoading()
        }) {
            self.hideLoading()
        }
    }
    
    // MARK: - UIActions
    
    @objc private func tapOnSaveButton() {
        var endpoint: ShopEndPoint
        
        if isEditShop {
            endpoint = ShopEndPoint.updateShopInfo(params: getShopParams())
        } else {
            endpoint = ShopEndPoint.createShop(params: getShopParams())
        }
        
        showLoading()
        
        APIService.request(endPoint: endpoint, onSuccess: { [weak self] (apiResponse) in
            guard let self = self, let shop = self.shop else { return }
            
            if self.isEditShop {
                self.delegate?.didUpdateShopSuccess?(with: shop)
                AlertManager.shared.showToast(message: TextManager.updateShopSuccess.localized())
            } else {
                self.delegate?.didCreateShopSuccess?(with: self.shopCodeTextField.text ?? "")
                AlertManager.shared.showToast(message: TextManager.createShopSuccess.localized())
            }
            
            self.hideLoading()
            self.navigationController?.popViewController(animated: true)
            
            }, onFailure: { [weak self]  (apiError) in
                self?.hideLoading()
                self?.presentDefaultErrorMessage()
        }) { [weak self] in
            self?.hideLoading()
            self?.presentDefaultErrorMessage()
        }
    }
    
    @objc private func textFieldValueChange(_ textField: UITextField) {
        if textField == shopNameTextField.textField {
            shopCodeTextField.text = textField.text?.makeAliasCode()
        }
        checkCanEnableSaveButton()
    }
    
    @objc private func textFieldBeginEditing(_ textField: UITextField) {
        if textField == provinceTextField.textField {
            if let province = selectedProvince,
                let index = provinces.firstIndex(where: { $0.id == province.id }) {
                provincePickerView.selectRow(index, inComponent: 0, animated: false)
            } else {
                provinceTextField.textField.text = provinces.first?.name
                selectedProvince = provinces.first
                provincePickerView.selectRow(0, inComponent: 0, animated: false)
            }
            
        } else if textField == districtTextField.textField {
            if let district = selecteDistrict,
                let index = districts.firstIndex(where: { $0.id == district.id }) {
                districtPickerView.selectRow(index, inComponent: 0, animated: false)
            } else {
                districtTextField.textField.text = districts.first?.name
                selecteDistrict = districts.first
                districtPickerView.selectRow(0, inComponent: 0, animated: false)
            }
            
        } else if textField == wardTextField.textField  {
            if let ward = selectedWard,
                let index = wards.firstIndex(where: { $0.id == ward.id }) {
                wardPickerView.selectRow(index, inComponent: 0, animated: false)
            } else {
                wardTextField.textField.text = wards.first?.name
                selectedWard = wards.first
                wardPickerView.selectRow(0, inComponent: 0, animated: false)
            }
        }
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
        
        checkCanEnableSaveButton()
    }
    
    // MARK: - Private
    
    private func getShopParams() -> [String: Any] {
        if shop == nil {
            shop = Shop()
        }
        
        shop?.name          = shopNameTextField.text ?? ""
        shop?.code          = shopCodeTextField.text ?? ""
        shop?.mobile        = phoneNumberTextField.text ?? ""
        shop?.hotline       = hotlineTextField.text ?? ""
        shop?.address       = addressTextView.text ?? ""
        shop?.website       = linkWebsiteTextField.text ?? ""
        shop?.map           = linkGGMapTextField.text ?? ""
        shop?.displayName   = displayNameTextField.text ?? ""
        shop?.provinceId    = selectedProvince?.id ?? 0
        shop?.provinceName  = selectedProvince?.name ?? ""
        shop?.districtId    = selecteDistrict?.id ?? 0
        shop?.districtName  = selecteDistrict?.name ?? ""
        shop?.wardId        = selectedWard?.id ?? 0
        shop?.wardName      = selectedWard?.name ?? ""
        
        if addressTextView.text != TextManager.shopAddress.localized() {
            shop?.address = addressTextView.text ?? ""
        }
        
        return shop?.toDictionary() ?? [:]
    }
    
    private func getRequiredAttibuted(from text: String) -> NSAttributedString {
        let font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        let attributeds = [NSAttributedString.Key.font: font,
                           NSAttributedString.Key.foregroundColor: UIColor.titleText]
        let attributedText = NSMutableAttributedString(string: text, attributes: attributeds)
        let requiredTextAttributes = [NSAttributedString.Key.font: font,
                                      NSAttributedString.Key.foregroundColor: UIColor.red]
        let requiredText = NSAttributedString(string: " (*)", attributes: requiredTextAttributes)
        
        attributedText.append(requiredText)
        attributedText.append(NSAttributedString(string: ":", attributes: attributeds))
        return attributedText
    }
    
    private func checkCanEnableSaveButton() {
        let shopName    = shopNameTextField.text ?? ""
        let phoneNumber = phoneNumberTextField.text ?? ""
        let address     = addressTextView.text
        let hotline     = hotlineTextField.text ?? ""
        let displayName = displayNameTextField.text ?? ""
        
        if shopName != ""
            && phoneNumber != ""
            && address != "" && address != TextManager.shopAddress.localized()
            && hotline != ""
            && displayName != ""
            && selectedProvince != nil && selecteDistrict != nil && selectedWard != nil {
            
            saveButton.isUserInteractionEnabled = true
            saveButton.backgroundColor = UIColor.accentColor
        } else {
            saveButton.isUserInteractionEnabled = false
            saveButton.backgroundColor = UIColor.disable
        }
    }
    
    // MARK: - Layouts
    
    private func layoutShopCodeTextField() {
        scrollView.addSubview(shopCodeTextField)
        shopCodeTextField.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(Dimension.shared.normalMargin)
            make.right.equalTo(view).offset(-Dimension.shared.normalMargin)
            make.top.equalToSuperview().offset(Dimension.shared.largeMargin)
        }
    }
    
    private func layoutShopNameTextField() {
        scrollView.addSubview(shopNameTextField)
        shopNameTextField.snp.makeConstraints { (make) in
            make.width.centerX.equalTo(shopCodeTextField)
            make.top.equalTo(shopCodeTextField.snp.bottom).offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutDisplayNameTextField() {
        scrollView.addSubview(displayNameTextField)
        displayNameTextField.snp.makeConstraints { (make) in
            make.width.centerX.equalTo(shopCodeTextField)
            make.top.equalTo(shopNameTextField.snp.bottom).offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutPhoneNumberTextField() {
        scrollView.addSubview(phoneNumberTextField)
        phoneNumberTextField.snp.makeConstraints { (make) in
            make.width.centerX.equalTo(shopCodeTextField)
            make.top.equalTo(displayNameTextField.snp.bottom).offset(Dimension.shared.normalMargin)
        }
    }
    
    private func lauoutAddressTitleLabel() {
        scrollView.addSubview(addressTitleLabel)
        addressTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(shopCodeTextField)
            make.top.equalTo(phoneNumberTextField.snp.bottom).offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutAddressTextView() {
        scrollView.addSubview(addressTextView)
        addressTextView.snp.makeConstraints { (make) in
            make.width.centerX.equalTo(shopCodeTextField)
            make.height.equalTo(80)
            make.top.equalTo(addressTitleLabel.snp.bottom).offset(Dimension.shared.mediumMargin)
        }
    }
    
    private func layoutProvinceTextField() {
        scrollView.addSubview(provinceTextField)
        provinceTextField.snp.makeConstraints { (make) in
            make.width.centerX.equalTo(shopCodeTextField)
            make.top.equalTo(addressTextView.snp.bottom).offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutDistrictTextField() {
        scrollView.addSubview(districtTextField)
        districtTextField.snp.makeConstraints { (make) in
            make.width.centerX.equalTo(shopCodeTextField)
            make.top.equalTo(provinceTextField.snp.bottom).offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutWardTextField() {
        scrollView.addSubview(wardTextField)
        wardTextField.snp.makeConstraints { (make) in
            make.width.centerX.equalTo(shopCodeTextField)
            make.top.equalTo(districtTextField.snp.bottom)
                .offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutHotlineTextField() {
        scrollView.addSubview(hotlineTextField)
        hotlineTextField.snp.makeConstraints { (make) in
            make.width.centerX.equalTo(shopCodeTextField)
            make.top.equalTo(wardTextField.snp.bottom)
                .offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutLinkGGMapTextField() {
        scrollView.addSubview(linkGGMapTextField)
        linkGGMapTextField.snp.makeConstraints { (make) in
            make.width.centerX.equalTo(shopCodeTextField)
            make.top.equalTo(hotlineTextField.snp.bottom)
                .offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutLinkWebSiteTextField() {
        scrollView.addSubview(linkWebsiteTextField)
        linkWebsiteTextField.snp.makeConstraints { (make) in
            make.width.centerX.equalTo(shopCodeTextField)
            make.top.equalTo(linkGGMapTextField.snp.bottom)
                .offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutSaveButton() {
        scrollView.addSubview(saveButton)
        saveButton.snp.makeConstraints { (make) in
            make.width.equalTo(Dimension.shared.smallWidthButton)
            make.height.equalTo(Dimension.shared.defaultHeightButton)
            make.centerX.equalToSuperview()
            make.top.equalTo(linkWebsiteTextField.snp.bottom)
                .offset(Dimension.shared.largeMargin)
            make.bottom.equalToSuperview().offset(-Dimension.shared.largeMargin_32)
        }
    }
    
}

// MARK: - UITextViewDelegate

extension CreateShopViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == TextManager.shopAddress.localized() {
            textView.text = ""
        }
        textView.textColor = UIColor.titleText
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = TextManager.shopAddress.localized()
            textView.textColor = UIColor.placeholder
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        checkCanEnableSaveButton()
    }
}

// MARK: - UIPickerViewDelegate

extension CreateShopViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int,
                    inComponent component: Int) {
        if pickerView == provincePickerView {
            provinceTextField.textField.text = provinces[safe:row]?.name ?? ""
            selectedProvince = provinces[safe:row]
        } else if pickerView == districtPickerView {
            districtTextField.textField.text = districts[safe:row]?.name ?? ""
            selecteDistrict = districts[safe:row]
        } else if pickerView == wardPickerView {
            wardTextField.textField.text = wards[safe:row]?.name ?? ""
            selectedWard = wards[safe:row]
        }
    }
}

// MARK: - UIPickerViewDatasource

extension CreateShopViewController: UIPickerViewDataSource {
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

