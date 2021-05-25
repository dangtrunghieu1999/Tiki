//
//  ProfileViewController.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 5/15/21.
//

import UIKit

class ProfileViewController: BaseViewController {
    
    private var selectedDate = AppConfig.defaultDate
    let widhtTextField = (UIScreen.main.bounds.size.width / 2 ) - dimension.normalMargin
    
    let withLabel = UIScreen.main.bounds.size.width / 2
    
    lazy var editBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: TextManager.edit, style: .done, target: self, action: nil)
        barButtonItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: FontSize.h1.rawValue)
                                              , NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        return barButtonItem
    }()
    
    var userProfile = User()
    
    // MARK: - UI Elements
    
    let contenStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = dimension.largeMargin
        return stackView
    }()
    
    let profileView = UIView()
    
    fileprivate lazy var profilePhotoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.avatarDefault
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    fileprivate lazy var changePhotoButton: UIButton = {
        let button = UIButton()
        button.setTitle("Thay đổi ảnh", for: .normal)
        button.setTitleColor(UIColor.second, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .semibold)
        button.addTarget(self, action: #selector(tapOnUploadPhoto), for: .touchUpInside)
        return button
    }()
        
    let nameContainerView = UIView()
    
    fileprivate lazy var fullNameField: TitleTextField = {
        let textField = TitleTextField()
        textField.titleText   = TextManager.fullName.localized()
        textField.textField.fontSizePlaceholder(text: TextManager.fullNamePlaceholder.localized(),
                                                size: FontSize.h1.rawValue)
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
        view.isActive = false
        view.iconWidth = dimension.checkBoxHeight
        view.handleDidChange = { [weak self] (isActive) in
            guard let self = self else { return }
            self.maleCheckBoxView.isActive = !isActive
        }
        return view
    }()
    
    lazy var maleCheckBoxView: CheckBoxAndDescriptionView = {
        let view = CheckBoxAndDescriptionView(
            activeImageName: "radioCheck",
            deactiveImageName: "uncheck",
            description: TextManager.male)
        view.isActive = false
        view.iconWidth = dimension.checkBoxHeight
        view.handleDidChange = { [weak self] (isActive) in
            guard let self = self else { return }
            self.femaleCheckBoxView.isActive = !isActive
        }
        return view
    }()
    
    let bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis         = .vertical
        stackView.alignment    = .fill
        stackView.distribution = .fill
        stackView.spacing = dimension.normalMargin
        return stackView
    }()
    
    fileprivate lazy var emailTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.titleText   = TextManager.email.localized()
        textField.textField.fontSizePlaceholder(text: TextManager.emailPlaceholder.localized(),
                                                size: FontSize.h1.rawValue)
        
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    fileprivate lazy var phoneTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.titleText   = TextManager.phoneNumber.localized()
        textField.textField.fontSizePlaceholder(text: TextManager.phoneNumberPlaceholder.localized(),
                                                size: FontSize.h1.rawValue)
        textField.keyboardType = .numberPad
        return textField
    }()
        
    let dobContainerView = UIView()
    
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
        return textField
    }()
    
    fileprivate lazy var changePasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.changePassword, for: .normal)
        button.backgroundColor = UIColor.primary
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(tapOnChangePassword), for: .touchUpInside)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupEditBarButtonItem()
        layoutScrollView()
        layoutBottomStackView()
        layoutItemBottomStackView()
        layoutDOBView()
        layoutDOBTitleLabel()
        layoutDOBTextField()
        layoutBottomButton()
        layoutContenStackView()
        layoutProfileView()
        layoutProfilePhotoImage()
        layoutChangePhotoButton()
        layoutGenderContainerView()
        layoutGenderTitleLabel()
        layoutGenderStackView()
        layoutGenderCheckBoxes()
        layoutFullNameTextField()
        configData(user: userProfile)
    }
    
    // MARK: - Get API
    
    func configData(user: User) {
        let birthDay = userProfile.dateOfBirth.toDate(with: DateFormat.shortDateUserFormat)
        
        self.fullNameField.text          = userProfile.fullName
        self.emailTextField.text         = userProfile.email
        self.phoneTextField.text         = userProfile.phone
        self.DOBTextField.text           = birthDay.desciption(by: DateFormat.shortDateUserFormat)
        
        if userProfile.gender == true {
            femaleCheckBoxView.isActive = false
        } else {
            maleCheckBoxView.isActive = true
        }
    }
    
    // MARK: - UI Action
    
    @objc private func tapSelectGender(_ view: CheckBoxAndDescriptionView) {
        view.isActive = true
    }
    
    @objc private func tapOnChangePassword() {
        let vc = ChangePWViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func processLogout() {
        AlertManager.shared.showConfirmMessage(mesage: TextManager.statusLogOut.localized())
        { (action) in
            UserManager.logout()
            guard let window = UIApplication.shared.keyWindow else { return }
            window.rootViewController = TKTabBarViewController()
        }
    }
    
    @objc private func tapOnUploadPhoto() {
        
    }
}

extension ProfileViewController {
    
    private func setupEditBarButtonItem() {
        self.navigationItem.title = TextManager.userProfile
        self.navigationItem.rightBarButtonItem = self.editBarButtonItem
    }
        
    private func layoutBottomStackView() {
        scrollView.addSubview(bottomStackView)
        bottomStackView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
                .offset(-Dimension.shared.mediumMargin)
            make.left.right.equalTo(view)
                .inset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutItemBottomStackView() {
        bottomStackView.addArrangedSubview(emailTextField)
        bottomStackView.addArrangedSubview(phoneTextField)
    }
    
    private func layoutDOBView() {
        bottomStackView.addArrangedSubview(dobContainerView)
        dobContainerView.snp.makeConstraints { ( make) in
            make.height.equalTo(74)
        }
    }
    
    private func layoutDOBTitleLabel() {
        dobContainerView.addSubview(DOBTitleLabel)
        DOBTitleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
        }
    }
    
    private func layoutDOBTextField() {
        dobContainerView.addSubview(DOBTextField)
        DOBTextField.snp.makeConstraints { (make) in
            make.top.equalTo(DOBTitleLabel.snp.bottom)
                .offset(Dimension.shared.mediumMargin)
            make.height.equalTo(Dimension.shared.largeHeightButton)
            make.left.right.equalToSuperview()
        }
    }
    
    private func layoutBottomButton() {
        bottomStackView.addArrangedSubview(changePasswordButton)
        changePasswordButton.snp.makeConstraints { (make) in
            make.height.equalTo(Dimension.shared.largeMargin_48)
        }
        bottomStackView.addArrangedSubview(logoutButton)
        logoutButton.snp.makeConstraints { (make) in
            make.height.equalTo(changePasswordButton)
        }
    }
    
    private func layoutContenStackView() {
        scrollView.addSubview(contenStackView)
        contenStackView.snp.makeConstraints { (make) in
            make.left.equalTo(view)
                .offset(Dimension.shared.normalMargin)
            make.right.equalTo(view)
                .offset(-Dimension.shared.normalMargin)
            make.top.equalToSuperview()
                .offset(Dimension.shared.normalMargin)
            make.bottom.equalTo(bottomStackView.snp.top)
                .offset(-Dimension.shared.normalMargin)
        }
    }
    
    private func layoutProfileView() {
        contenStackView.addArrangedSubview(profileView)
        profileView.snp.makeConstraints { (make) in
            make.height.equalTo(180)
        }
    }
    
    private func layoutProfilePhotoImage() {
        profileView.addSubview(profilePhotoImage)
        profilePhotoImage.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(150)
        }
    }
    
    private func layoutChangePhotoButton() {
        profileView.addSubview(changePhotoButton)
        changePhotoButton.snp.makeConstraints { (make) in
            make.top.equalTo(profilePhotoImage.snp.bottom)
                .offset(Dimension.shared.mediumMargin)
            make.centerX.width.equalTo(profilePhotoImage)
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
    }
    
    private func layoutFullNameTextField() {
        contenStackView.addArrangedSubview(fullNameField)
    }
    
}
