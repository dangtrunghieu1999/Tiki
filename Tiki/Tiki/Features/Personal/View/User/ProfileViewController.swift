//
//  ProfileViewController.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 5/15/21.
//

import UIKit
import RxSwift
import RxCocoa
import IQKeyboardManagerSwift

enum EditState: Int {
    case edit      = 0
    case done      = 1
}

protocol ProfileViewControllerDelegate: class {
    func handleLogoutSuccess()
}

class ProfileViewController: BaseViewController {
    
    // MARK: - Variables
    let disposeBag = DisposeBag()
    private var selectedDate = AppConfig.defaultDate
    
    lazy var editBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: TextManager.edit,
                                            style: .done,
                                            target: self,
                                            action: nil)
        let attributedText  = [NSAttributedString.Key.font:
                                UIFont.systemFont(ofSize: FontSize.h1.rawValue),
                               NSAttributedString.Key.foregroundColor: UIColor.white]
        barButtonItem.setTitleTextAttributes(attributedText, for: .normal)
        return barButtonItem
    }()
    
    var isPressCancel: Bool = false
    lazy var viewModel = ProfileViewModel()
    weak var delegate: ProfileViewControllerDelegate?
    
    // MARK: - UI Elements
    
    lazy var profileScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isUserInteractionEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchInScrollView))
        tapGesture.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(tapGesture)
        return scrollView
    }()
    
    let contenStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = dimension.largeMargin
        return stackView
    }()
    
    let profileView = UIView()
    
    fileprivate lazy var changePhotoButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.changePhoto, for: .normal)
        button.setTitleColor(UIColor.second, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .semibold)
        button.addTarget(self, action: #selector(tapOnUploadPhoto), for: .touchUpInside)
        return button
    }()
    
    let nameContainerView = UIView()
    
    fileprivate lazy var firstNameTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.titleText   = TextManager.firstName.localized()
        textField.textField.fontSizePlaceholder(text: TextManager.firstName.localized(),
                                                size: FontSize.h1.rawValue)
        return textField
    }()
    
    fileprivate lazy var lastNameTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.titleText   = TextManager.lastName.localized()
        textField.textField.fontSizePlaceholder(text: TextManager.lastName.localized(),
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
    
    fileprivate lazy var toolBar: IQToolbar = {
        let toolBar = IQToolbar()
        let flexSpace    = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                           target: self,
                                           action: nil)
        let doneButton   = UIBarButtonItem(title: TextManager.done.localized(),
                                           style: .done,
                                           target: self,
                                           action: #selector(onPressDoneButton))
        let cancelButton = UIBarButtonItem(title: TextManager.cancel.localized(),
                                           style: .done,
                                           target: self,
                                           action: #selector(onPressCancelButton))
        toolBar.items = [cancelButton, flexSpace, doneButton]
        toolBar.tintColor = UIColor.primary
        toolBar.sizeToFit()
        return toolBar
    }()
    
    fileprivate lazy var DOBTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.placeholder = TextManager.dateOfBirth
        textField.layer.borderColor = UIColor.separator.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = Dimension.shared.cornerRadiusSmall
        textField.layer.masksToBounds = true
        textField.inputAccessoryView = toolBar
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
        button.addTarget(self, action: #selector(tapOnChangePassword),
                         for: .touchUpInside)
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
        button.addTarget(self, action: #selector(processLogout),
                         for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindingCompoents()
        setupEditBarButtonItem()
        layoutLogouButton()
        layoutChangePasswordButton()
        layoutProfileScrollView()
        layoutContenStackView()
        layoutProfileView()
        layoutProfilePhotoImage()
        layoutChangePhotoButton()
        layoutNameContainerView()
        layoutFirstNameTextFieldView()
        layoutLastNameTextFieldView()
        layoutGenderContainerView()
        layoutGenderTitleLabel()
        layoutGenderStackView()
        layoutGenderCheckBoxes()
        layoutItemBottomView()
        layoutDOBView()
        layoutDOBTitleLabel()
        layoutDOBTextField()
        configData(user: UserManager.user)
    }
    
    // MARK: - Get API
    
    func configData(user: User?) {
        
        self.firstNameTextField.text = user?.firstName
        self.lastNameTextField.text  = user?.lastName
        self.emailTextField.text     = user?.email
        self.phoneTextField.text     = user?.phone
        self.DOBTextField.text       = user?.birthDay?.desciption(by: DateFormat.shortDateUserFormat)
        
        if user?.gender.rawValue == 1 {
            femaleCheckBoxView.isActive = false
        } else {
            maleCheckBoxView.isActive = true
        }
    }
    
    // MARK: - UI Action
    
    @objc private func tapOnChangePassword() {
        let vc = ChangePWViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func processLogout() {
        AlertManager.shared.showConfirm(TextManager.statusLogOut.localized())
        { (action) in
            UserManager.logout()
            self.navigationController?.popViewControllerWithHandler {
                self.delegate?.handleLogoutSuccess()
            }
        }
    }
    
    @objc private func tapOnUploadPhoto() {
        self.showChooseSourceTypeAlertController()
    }
    
    @objc private func onPressCancelButton() {
        self.isPressCancel = true
        self.view.endEditing(true)
    }
    
    @objc private func onPressDoneButton() {
        self.isPressCancel = false
        self.view.endEditing(true)
    }
}

// MARK: - Layout

extension ProfileViewController {
    
    private func setupEditBarButtonItem() {
        self.navigationItem.title = TextManager.userProfile
        self.navigationItem.rightBarButtonItem = self.editBarButtonItem
    }
    
    private func layoutLogouButton() {
        view.addSubview(logoutButton)
        logoutButton.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
                .inset(Dimension.shared.normalMargin)
            make.height.equalTo(Dimension.shared.largeHeightButton)
            if #available(iOS 11, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
                    .offset(-Dimension.shared.mediumMargin)
            } else {
                make.bottom.equalTo(bottomLayoutGuide.snp.top)
                    .offset(-Dimension.shared.mediumMargin)
            }
        }
    }
    
    private func layoutChangePasswordButton() {
        view.addSubview(changePasswordButton)
        changePasswordButton.snp.makeConstraints { (make) in
            make.height.equalTo(logoutButton)
            make.left.right.equalTo(logoutButton)
            make.bottom.equalTo(logoutButton.snp.top)
                .offset(-Dimension.shared.mediumMargin)
        }
    }
    
    private func layoutProfileScrollView() {
        view.addSubview(profileScrollView)
        profileScrollView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom)
            }
            make.left.right.equalToSuperview()
            make.bottom.equalTo(changePasswordButton.snp.top)
                .offset(-Dimension.shared.normalMargin)
        }
    }
    
    private func layoutContenStackView() {
        profileScrollView.addSubview(contenStackView)
        contenStackView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
                .inset(Dimension.shared.normalMargin)
            make.top.equalToSuperview()
                .offset(Dimension.shared.normalMargin)
            make.bottom.equalToSuperview()
                .offset(-Dimension.shared.largeMargin_56)
        }
    }
    
    private func layoutProfileView() {
        contenStackView.addArrangedSubview(profileView)
        profileView.snp.makeConstraints { (make) in
            make.height.equalTo(150)
        }
    }
    
    private func layoutProfilePhotoImage() {
        profileView.addSubview(profilePhotoImage)
        profilePhotoImage.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(dimension.largeMargin_120)
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
    
    private func layoutNameContainerView() {
        contenStackView.addArrangedSubview(nameContainerView)
    }
    
    private func layoutFirstNameTextFieldView() {
        nameContainerView.addSubview(firstNameTextField)
        firstNameTextField.snp.makeConstraints { (make) in
            make.leading.top.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
            make.trailing.equalTo(nameContainerView.snp.centerX)
                .offset(-dimension.mediumMargin)
        }
    }
    
    private func layoutLastNameTextFieldView() {
        nameContainerView.addSubview(lastNameTextField)
        lastNameTextField.snp.makeConstraints { (make) in
            make.trailing.top.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
            make.leading.equalTo(nameContainerView.snp.centerX).offset(dimension.mediumMargin)
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
        genderContainerView.addSubview(genderStackView)
        genderStackView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(genderTitleLabel.snp.bottom)
                .offset(dimension.mediumMargin)
        }
    }
    
    private func layoutGenderCheckBoxes() {
        genderStackView.addArrangedSubview(femaleCheckBoxView)
        genderStackView.addArrangedSubview(maleCheckBoxView)
    }
    
    private func layoutItemBottomView() {
        contenStackView.addArrangedSubview(emailTextField)
        contenStackView.addArrangedSubview(phoneTextField)
    }
    
    private func layoutDOBView() {
        contenStackView.addArrangedSubview(dobContainerView)
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
}

// MARK: - Binding Data
extension ProfileViewController {
    
    private func bindingCompoents() {
        bindingFirstName()
        bindingLastName()
        bindingPhone()
        bindingGender()
        bindingEmail()
        bindingBirthday()
        bindingEditButton()
    }
    
    private func bindingFirstName(){
        viewModel.firstName
            .asDriver()
            .drive(firstNameTextField.textField.rx.text)
            .disposed(by: disposeBag)
        firstNameTextField
            .textField.rx.text
            .changed.bind(to: viewModel.firstName)
            .disposed(by: disposeBag)
        firstNameTextField
            .textField.rx
            .controlEvent(.editingDidBegin)
            .map {true}
            .bind(to: viewModel.isEdit)
            .disposed(by: disposeBag)
    }
    
    private func bindingLastName(){
        viewModel.lastName
            .asDriver()
            .drive(lastNameTextField.textField.rx.text)
            .disposed(by: disposeBag)
        lastNameTextField
            .textField.rx.text
            .changed.bind(to: viewModel.lastName)
            .disposed(by: disposeBag)
        lastNameTextField
            .textField.rx
            .controlEvent(.editingDidBegin)
            .map {true}
            .bind(to: viewModel.isEdit)
            .disposed(by: disposeBag)
    }
    
    private func bindingPhone() {
        viewModel.phone
            .asDriver()
            .drive(phoneTextField.textField.rx.text)
            .disposed(by: disposeBag)
        phoneTextField
            .textField.rx.text
            .changed.bind(to: viewModel.phone)
            .disposed(by: disposeBag)
        phoneTextField
            .textField.rx
            .controlEvent(.editingChanged)
            .map {true}
            .bind(to: viewModel.isEdit)
            .disposed(by: disposeBag)
    }
    
    private func bindingGender() {
        viewModel.gender
            .asDriver()
            .drive(onNext: { [weak self] type in
                self?.femaleCheckBoxView.isActive = false
                self?.maleCheckBoxView.isActive   = false
                switch Gender(rawValue: type) {
                case .male:
                    self?.maleCheckBoxView.isActive   = true
                case .female:
                    self?.femaleCheckBoxView.isActive = true
                default:
                    self?.maleCheckBoxView.isActive   = true
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindingEmail() {
        viewModel.email
            .asDriver()
            .drive(emailTextField.textField.rx.text)
            .disposed(by: disposeBag)
        emailTextField
            .textField.rx.text
            .changed.bind(to: viewModel.email)
            .disposed(by: disposeBag)
        emailTextField
            .textField.rx
            .controlEvent(.editingDidBegin)
            .map { true }
            .bind(to: viewModel.isEdit)
            .disposed(by: disposeBag)
    }
    
    private func bindingBirthday() {
        viewModel.birthday.asDriver().map {
            $0?.toString(.ddMMyyyy)
        }
        .drive(DOBTextField.rx.text)
        .disposed(by: disposeBag)
        
        viewModel.birthday.asDriver().map {
            return $0 ?? Date()
        }
        .drive(datePicker.rx.date)
        .disposed(by: disposeBag)
        
        DOBTextField.rx.controlEvent(.editingDidEnd)
            .bind{ [weak self] in
                guard let self = self else { return }
                if !self.isPressCancel {
                    self.viewModel.birthday.accept(self.datePicker.date)
                } else {
                    self.DOBTextField.text = self.DOBTextField.text
                    if self.DOBTextField.text?.isEmpty ?? true {
                        self.viewModel.birthday.accept(nil)
                    }
                }
            }.disposed(by: disposeBag)
        
        DOBTextField.rx.controlEvent(.editingDidBegin)
            .map { true }
            .bind(to: viewModel.isEdit)
            .disposed(by: disposeBag)
    }
    
    private func bindingEditButton() {
        editBarButtonItem.rx.tap.map { [weak self] in
            self?.editBarButtonItem.title == TextManager.edit.localized()
        }.bind(to: viewModel.isEdit).disposed(by: disposeBag)
        
        viewModel.isEdit.map {
            $0 == true ? TextManager.done.localized() : TextManager.edit.localized()
        }.bind(to: editBarButtonItem.rx.title).disposed(by: disposeBag)
        
        viewModel.isEdit.bind(onNext: { [weak self] isEnable in
            self?.firstNameTextField.isBlur = isEnable
            self?.lastNameTextField.isBlur  = isEnable
            self?.phoneTextField.isBlur     = isEnable
            self?.DOBTextField.isBlur       = isEnable
            self?.emailTextField.isBlur     = isEnable
        }).disposed(by: disposeBag)
    }
    
}
