//
//  ProfileViewController.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 5/15/21.
//

import UIKit

class ProfileViewController: BaseViewController {
    
    private var selectedDate = AppConfig.defaultDate

    let withLabel = UIScreen.main.bounds.size.width / 2
    
    lazy var editBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: TextManager.edit, style: .done, target: self, action: nil)
        barButtonItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: FontSize.h1.rawValue), NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        return barButtonItem
    }()
    
    let myScrollView = BaseScrollView(frame: .zero)
    
    let contenStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = dimension.largeMargin
        return stackView
    }()
    
    let nameContainerView = UIView()
    
    fileprivate lazy var firstNameLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.firstName
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .semibold)
        return label
    }()
    
    fileprivate lazy var lastNameLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.lastName
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .semibold)
        return label
    }()
    
    fileprivate lazy var firstNameTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.layer.borderColor = UIColor.boderColor.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = Dimension.shared.cornerRadiusSmall
        textField.layer.masksToBounds = true
        textField.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        textField.text = "Dang"
        return textField
    }()
    
    fileprivate lazy var lastNameTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.layer.borderColor = UIColor.boderColor.cgColor
        textField.layer.borderWidth = 1
        textField.text = "Hieu"
        textField.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        textField.layer.cornerRadius = Dimension.shared.cornerRadiusSmall
        textField.layer.masksToBounds = true
        return textField
    }()
    
        fileprivate lazy var emailNameLabel: UILabel = {
            let label = UILabel()
            label.text = TextManager.email
            label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .semibold)
            return label
        }()
    
    fileprivate lazy var emailTextFieldView: PaddingTextField = {
        let textField = PaddingTextField()
        textField.text = "Hieudt230899@gmail.com"
        textField.layer.borderColor = UIColor.boderColor.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = Dimension.shared.cornerRadiusSmall
        textField.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        textField.layer.masksToBounds = true
        return textField
    }()
    
    fileprivate lazy var phonelNameLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.phoneNumber
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .semibold)
        return label
    }()
    
    fileprivate lazy var phoneTextFieldView: PaddingTextField = {
        let textField = PaddingTextField()
        textField.text = "0336665653"
        textField.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        textField.layer.borderColor = UIColor.separator.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = Dimension.shared.cornerRadiusSmall
        textField.layer.masksToBounds = true
        textField.keyboardType = .numberPad
        return textField
    }()
    
    let genderContainerView = UIView()
    
    let genderTitleLabel = UILabel(text: TextManager.gender,
                                   font: UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .semibold),
                                   textColor: UIColor.bodyText,
                                   textAlignment: .left)
    
    let genderStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = dimension.mediumMargin
        return stackView
    }()
    
    lazy var femaleCheckBoxView: CheckBoxAndDescriptionView = {
        let view = CheckBoxAndDescriptionView(
            activeImageName: "radioCheck",
            deactiveImageName: "uncheck",
            description: TextManager.female)
        view.isActive = true
        view.iconWidth = dimension.checkBoxHeight
        return view
    }()
    
    lazy var maleCheckBoxView: CheckBoxAndDescriptionView = {
        let view = CheckBoxAndDescriptionView(
            activeImageName: "radioCheck",
            deactiveImageName: "uncheck",
            description: TextManager.male)
        view.isActive = false
        view.iconWidth = dimension.checkBoxHeight
        return view
    }()
    
    lazy var otherCheckBoxView: CheckBoxAndDescriptionView = {
        let view = CheckBoxAndDescriptionView(
            activeImageName: "radioCheck",
            deactiveImageName: "uncheck",
            description: TextManager.notSpecify)
        view.isActive = false
        view.iconWidth = dimension.checkBoxHeight
        return view
    }()
    
    fileprivate lazy var changePasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.changePassword, for: .normal)
        button.backgroundColor = UIColor.primary
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        button.isUserInteractionEnabled = true
        return button
    }()
    
    fileprivate lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.logOut, for: .normal)
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.primary, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        button.isUserInteractionEnabled = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.primary.cgColor
        button.addTarget(self, action: #selector(processLogout), for: .touchUpInside)
        return button
    }()
    
    fileprivate let DOBTitleLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.dateOfBirth
        label.textColor = UIColor.titleText
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .semibold)
        return label
    }()

    
    fileprivate lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.locale = Locale(identifier: "Vi")
        datePicker.datePickerMode = .date
        datePicker.minimumDate = AppConfig.minDate
        datePicker.maximumDate = Date()
        datePicker.date = selectedDate
        return datePicker
    }()
    
    fileprivate lazy var DOBTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.placeholder = TextManager.dateOfBirth
        textField.layer.borderColor = UIColor.separator.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = Dimension.shared.cornerRadiusSmall
        textField.layer.masksToBounds = true
        textField.inputView = datePicker
        textField.text = selectedDate.desciption(by: DateFormat.shortDateUserFormat)
        return textField
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupEditBarButtonItem()
        layoutLogoutButton()
        layoutChangePasswordButton()
        layoutMyScrollView()
        layoutFirstNameLabel()
        layoutLastNameLabel()
        layoutContenStackView()
        layoutNameContainerView()
        layoutFirstNameTextField()
        layoutLastNameTextField()
        layoutGenderContainerView()
        layoutGenderTitleLabel()
        layoutGenderStackView()
        layoutGenderCheckBoxes()
        layoutEmailLabel()
        layoutEmailTextField()
        layoutPhoneNameLabel()
        layoutPhoneTextField()
        layoutDOBTitleLabel()
        layoutDOBTextField()
    }
    
    // MARK: - UI Action
    
    @objc private func tapSelectGender(_ view: CheckBoxAndDescriptionView) {
        view.isActive = true
    }
    
    @objc private func processLogout() {
        AlertManager.shared.showConfirmMessage(mesage: TextManager.statusLogOut.localized())
        { (action) in
            UserManager.logout()
            guard let window = UIApplication.shared.keyWindow else { return }
            window.rootViewController = TKTabBarViewController()
        }
    }
}

extension ProfileViewController {
    
    private func setupEditBarButtonItem() {
        self.navigationItem.title = TextManager.userProfile
        self.navigationItem.rightBarButtonItem = self.editBarButtonItem
    }
    
    private func layoutLogoutButton() {
        view.addSubview(logoutButton)
        logoutButton.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(dimension.mediumMargin)
            make.height.equalTo(dimension.largeMargin_48)
            make.bottom.equalTo(bottomLayoutGuide.snp.top).offset(-dimension.mediumMargin)
        }
    }
    
    private func layoutChangePasswordButton() {
        view.addSubview(changePasswordButton)
        changePasswordButton.snp.makeConstraints { (make) in
            make.leading.trailing.height.equalTo(logoutButton)
            make.bottom.equalTo(logoutButton.snp.top).offset(-dimension.mediumMargin)
        }
    }
    
    private func layoutMyScrollView() {
        view.addSubview(self.myScrollView)
        myScrollView.snp.makeConstraints { (make) in
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(changePasswordButton.snp.top).offset(-dimension.normalMargin)
        }
    }
    
    private func layoutFirstNameLabel() {
        myScrollView.addSubview(firstNameLabel)
        firstNameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
                .offset(Dimension.shared.normalMargin)
            make.width.equalTo(withLabel)
            make.top.equalToSuperview()
                .offset(Dimension.shared.largeMargin)
        }
    }
    
    private func layoutLastNameLabel() {
        myScrollView.addSubview(lastNameLabel)
        lastNameLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
                .offset(Dimension.shared.mediumMargin)
            make.width.equalTo(withLabel)
            make.top.equalToSuperview()
                .offset(Dimension.shared.largeMargin)
        }
    }
    
    private func layoutContenStackView() {
        self.myScrollView.view.addSubview(self.contenStackView)
        self.contenStackView.snp.makeConstraints { (make) in
            make.top.equalTo(firstNameLabel.snp.bottom)
                .offset(Dimension.shared.mediumMargin)
            make.leading.equalToSuperview().offset(dimension.normalMargin)
            make.trailing.equalToSuperview().offset(-dimension.normalMargin)
            make.width.equalTo(self.view).offset(-dimension.normalMargin * 2)
            make.bottom.equalToSuperview()
        }
    }
    
    private func layoutNameContainerView() {
        self.contenStackView.addArrangedSubview(self.nameContainerView)
    }
    
    private func layoutFirstNameTextField() {
        nameContainerView.addSubview(firstNameTextField)
        firstNameTextField.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
            make.right.equalTo(self.nameContainerView.snp.centerX)
                .offset(-dimension.mediumMargin)
            make.height.equalTo(Dimension.shared.largeMargin_48)
        }
    }
    
    private func layoutLastNameTextField() {
        nameContainerView.addSubview(lastNameTextField)
        lastNameTextField.snp.makeConstraints { (make) in
            make.right.top.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
            make.left.equalTo(nameContainerView.snp.centerX)
                .offset(dimension.mediumMargin)
            make.height.equalTo(Dimension.shared.largeMargin_48)
        }
    }
    
    private func layoutGenderContainerView() {
        contenStackView.addArrangedSubview(genderContainerView)
    }
    
    private func layoutGenderTitleLabel() {
        genderContainerView.addSubview(genderTitleLabel)
        genderTitleLabel.snp.makeConstraints { (make) in
            make.leading.top.equalToSuperview()
        }
    }
    
    private func layoutGenderStackView() {
        genderContainerView.addSubview(self.genderStackView)
        genderStackView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.genderTitleLabel.snp.bottom)
                .offset(dimension.mediumMargin)
        }
    }
    
    private func layoutGenderCheckBoxes() {
        genderStackView.addArrangedSubview(femaleCheckBoxView)
        genderStackView.addArrangedSubview(maleCheckBoxView)
        genderStackView.addArrangedSubview(otherCheckBoxView)
    }
    
    
    private func layoutEmailLabel() {
        myScrollView.addSubview(emailNameLabel)
        emailNameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
                .offset(Dimension.shared.normalMargin)
            make.right.equalToSuperview()
                .offset(-Dimension.shared.normalMargin)
            make.top.equalTo(genderStackView.snp.bottom)
                .offset(Dimension.shared.largeMargin)
        }
    }
    
    private func layoutEmailTextField() {
        myScrollView.addSubview(emailTextFieldView)
        emailTextFieldView.snp.makeConstraints { (make) in
            make.left.right.equalTo(emailNameLabel)
            make.top.equalTo(emailNameLabel.snp.bottom)
                .offset(Dimension.shared.mediumMargin)
            make.height.equalTo(Dimension.shared.defaultHeightTextField)
        }
    }
    
    private func layoutPhoneNameLabel() {
        myScrollView.addSubview(phonelNameLabel)
        phonelNameLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(emailNameLabel)
            make.top.equalTo(emailTextFieldView.snp.bottom)
                .offset(Dimension.shared.largeMargin)
        }
    }
    
    private func layoutPhoneTextField() {
        myScrollView.addSubview(phoneTextFieldView)
        phoneTextFieldView.snp.makeConstraints { (make) in
            make.left.right.equalTo(emailNameLabel)
            make.top.equalTo(phonelNameLabel.snp.bottom)
                .offset(Dimension.shared.mediumMargin)
            make.height.equalTo(Dimension.shared.defaultHeightTextField)
        }
    }
    
    private func layoutDOBTitleLabel() {
        myScrollView.addSubview(DOBTitleLabel)
        DOBTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(phoneTextFieldView)
            make.top.equalTo(phoneTextFieldView.snp.bottom)
                .offset(Dimension.shared.largeMargin)
        }
    }
    
    private func layoutDOBTextField() {
        myScrollView.addSubview(DOBTextField)
        DOBTextField.snp.makeConstraints { (make) in
            make.left.width.height.equalTo(phoneTextFieldView)
            make.top.equalTo(DOBTitleLabel.snp.bottom).offset(Dimension.shared.mediumMargin)
        }
    }
}
