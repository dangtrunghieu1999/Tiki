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
    
    // MARK: - UI Elements
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.enterAddressRecive
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .semibold)
        return label
    }()
    
    fileprivate lazy var fullNameReciveTextField: TitleTextField = {
        let label = TitleTextField()
        label.titleText = TextManager.fullNameRecive
        label.placeholder = TextManager.fullNamePlaceholder
        label.textField.delegate = self
        return label
    }()
    
    fileprivate lazy var phoneReciveTextField: TitleTextField = {
        let label = TitleTextField()
        label.titleText = TextManager.phoneNumber
        label.placeholder = TextManager.phoneNumberPlaceholder
        label.textField.delegate = self
        return label
    }()
    
    fileprivate lazy var addressReciveTextField: TitleTextField = {
        let label = TitleTextField()
        label.titleText = TextManager.addressRecive
        label.placeholder = TextManager.addressPlaceholder
        label.textField.delegate = self
        return label
    }()
    
    fileprivate lazy var provinceTextField: TitleTextField = {
        let label = TitleTextField()
        label.titleText = TextManager.provinceCity
        label.placeholder = TextManager.provinceCityPlaceholder
        label.textField.delegate = self
        return label
    }()
    
    fileprivate lazy var districtTextField: TitleTextField = {
        let label = TitleTextField()
        label.titleText = TextManager.district
        label.placeholder = TextManager.districteCityPlaceholder
        label.textField.delegate = self
        return label
    }()
    
    fileprivate lazy var wardTextField: TitleTextField = {
        let label = TitleTextField()
        label.titleText = TextManager.ward
        label.placeholder = TextManager.wardPlaceholder
        label.textField.delegate = self
        label.colorLine = UIColor.white
        return label
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
        button.backgroundColor = UIColor.primary
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Dimension.shared.cornerRadiusSmall
        return button
    }()
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = TextManager.addressRecive
        layoutTitleLabel()
        layoutBottomView()
        layoutShipAddressButton()
        layoutTitleLabel()
        layoutScrollView()
        layoutFullNameReciveTitleLabel()
        layoutPhoneNumberReciveTitleLabel()
        layoutAddressReciveTitleLabel()
        layoutProvinceCityTitleLabel()
        layoutDistrictCityTitleLabel()
        layoutWardCityTitleLabel()
    }
    
    // MARK: - Helper Method
    
    // MARK: - GET API
    
    // MARK: - Layout
    
    private func layoutTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            if #available(iOS 11, *) {
                make.top.equalTo(view.safeAreaLayoutGuide)
                    .offset(Dimension.shared.normalMargin)
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom)
                    .offset(Dimension.shared.normalMargin)
            }
            make.left.equalToSuperview()
                .offset(Dimension.shared.normalMargin)
            make.right.equalToSuperview()
                .offset(-Dimension.shared.normalMargin)
        }
    }
    
    private func layoutBottomView() {
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            if #available(iOS 11, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalTo(bottomLayoutGuide.snp.top)
            }
            make.left.right.equalToSuperview()
            make.height.equalTo(68)
        }
    }
    
    private func layoutShipAddressButton() {
        bottomView.addSubview(shipAddressButton)
        shipAddressButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
                .offset(Dimension.shared.normalMargin)
            make.right.equalToSuperview()
                .offset(-Dimension.shared.normalMargin)
            make.height.equalTo(Dimension.shared.defaultHeightButton)
            make.bottom.equalToSuperview()
                .offset(-Dimension.shared.mediumMargin)
        }
    }

    override internal func layoutScrollView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
                .offset(Dimension.shared.normalMargin)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(bottomView.snp.top)
        }
    }
    
    private func layoutFullNameReciveTitleLabel() {
        scrollView.addSubview(fullNameReciveTextField)
        fullNameReciveTextField.snp.makeConstraints { (make) in
            make.left.equalTo(view)
                .offset(Dimension.shared.normalMargin)
            make.right.equalTo(view)
                .offset(-Dimension.shared.normalMargin)
            make.top.equalToSuperview()
        }
    }
    
    private func layoutPhoneNumberReciveTitleLabel() {
        scrollView.addSubview(phoneReciveTextField)
        phoneReciveTextField.snp.makeConstraints { (make) in
            make.left.right.equalTo(fullNameReciveTextField)
            make.top.equalTo(fullNameReciveTextField.snp.bottom)
                .offset(Dimension.shared.largeMargin_32)
        }
    }
    
    private func layoutAddressReciveTitleLabel() {
        scrollView.addSubview(addressReciveTextField)
        addressReciveTextField.snp.makeConstraints { (make) in
            make.left.right.equalTo(fullNameReciveTextField)
            make.top.equalTo(phoneReciveTextField.snp.bottom)
                .offset(Dimension.shared.largeMargin_32)
        }
    }
    
    private func layoutProvinceCityTitleLabel() {
        scrollView.addSubview(provinceTextField)
        provinceTextField.snp.makeConstraints { (make) in
            make.left.right.equalTo(fullNameReciveTextField)
            make.top.equalTo(addressReciveTextField.snp.bottom)
                .offset(Dimension.shared.largeMargin_32)
        }
    }
    
    private func layoutDistrictCityTitleLabel() {
        scrollView.addSubview(districtTextField)
        districtTextField.snp.makeConstraints { (make) in
            make.left.right.equalTo(fullNameReciveTextField)
            make.top.equalTo(provinceTextField.snp.bottom)
                .offset(Dimension.shared.largeMargin_32)
        }
    }
    
    private func layoutWardCityTitleLabel() {
        scrollView.addSubview(wardTextField)
        wardTextField.snp.makeConstraints { (make) in
            make.left.right.equalTo(fullNameReciveTextField)
            make.top.equalTo(districtTextField.snp.bottom)
                .offset(Dimension.shared.largeMargin_32)
            make.bottom.equalToSuperview()
        }
    }
    
}
