//
//  CreateProductViewController.swift
//  ZoZoApp
//
//  Created by MACOS on 6/29/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit
import Photos

protocol CreateProductViewControllerDelegate: class {
    func didCreateProductSuccess(_ product: Product?)
    func didUpdateProductSuccess(_ product: Product)
}

class CreateProductViewController: BaseViewController {

    // MARK: - Variables
    
    static let defaultNumberImages = 5
    weak var delegate: CreateProductViewControllerDelegate?
    
    var numberHorizontalItem: CGFloat {
        var numberHorizontalItem: CGFloat = 2
        let ip6Width: CGFloat = 375
        let ipadAirWidth: CGFloat = 768
        
        if ScreenSize.SCREEN_WIDTH >= ipadAirWidth {
            numberHorizontalItem = 6
        } else if ScreenSize.SCREEN_WIDTH > ip6Width {
            numberHorizontalItem = 3
        }
        
        return numberHorizontalItem
    }
    
    fileprivate var defaultProductImageWidth: CGFloat {
        return (ScreenSize.SCREEN_WIDTH - 2 * Dimension.shared.normalMargin ) / numberHorizontalItem
    }
    
    fileprivate var imageCollectionViewHeight: CGFloat {
        let verticalItem = ceil(CGFloat(CreateProductViewController.defaultNumberImages) / numberHorizontalItem)
        return defaultProductImageWidth * verticalItem
    }
    
    fileprivate var viewModel = CreateProductViewModel()
    
    var shopId: Int? {
        didSet {
            if let shopId = shopId, product.shopId == nil {
                product.shopId = shopId
            }
        }
    }
    
    var product = Product() {
        didSet {
            productNameTextField.text = product.name
            categoryTextField.text = product.categoryName
            supplierTextField.text = product.supplierName
            unitTextField.text = product.quantityPerUnit
            weightTextField.text = Int(product.weight).description
            detailDesTextView.text = product.detail
            guaranteeTextField.text = product.warranty.description
            listSizeView.setTag(tags: product.sizeModels)
            listColorView.setTag(tags: product.colorModels)
            isGenuineCheckMarkView.state = product.authentics ? CheckMarkState.check : CheckMarkState.unCheck
            
            if (product.promoPrice != 0) {
                promotionPriceTextField.text = Int(product.promoPrice).description
            }
            if (product.unitPrice != 0) {
                originalPriceTextField.text = Int(product.unitPrice).description
            }
            if (product.detail != "") {
                detailDesTextView.textColor = UIColor.titleText
            }
            
            listImageCollectionView.reloadData()
        }
    }
    
    // MARK: - UI Elements
    
    fileprivate lazy var categoryPickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    
    fileprivate lazy var supplierPickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    
    fileprivate lazy var productNameTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.placeholder = TextManager.inputProductName.localized()
        textField.titleLabelAttributed = getRequiredAttibuted(from: TextManager.productName.localized())
        textField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)
        return textField
    }()
    
    fileprivate lazy var categoryTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.placeholder = TextManager.pickCateogry.localized()
        textField.titleLabelAttributed = getRequiredAttibuted(from: TextManager.cateogry.localized())
        textField.addTarget(self, action: #selector(textFieldBeginEditing(_:)), for: .editingDidBegin)
        textField.textFieldInputView = categoryPickerView
        return textField
    }()
    
    fileprivate lazy var supplierTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.placeholder = TextManager.pickProducer.localized()
        textField.titleText = TextManager.producer.localized()
        textField.addTarget(self, action: #selector(textFieldBeginEditing(_:)), for: .editingDidBegin)
        textField.textFieldInputView = supplierPickerView
        return textField
    }()
    
    fileprivate lazy var originalPriceTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.placeholder = TextManager.inputOriginalPrice.localized()
        textField.titleLabelAttributed = getRequiredAttibuted(from: TextManager.originalPrice.localized())
        textField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)
        textField.keyboardType = .numberPad
        return textField
    }()
    
    fileprivate lazy var promotionPriceTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.placeholder = TextManager.inputPromotionPrice.localized()
        textField.titleText = TextManager.promotionPrice.localized()
        textField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)
        textField.keyboardType = .numberPad
        return textField
    }()
    
    fileprivate lazy var unitTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.placeholder = TextManager.inputUnit.localized()
        textField.titleText = TextManager.unit.localized()
        textField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)
        return textField
    }()
    
    fileprivate lazy var weightTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.keyboardType = .numberPad
        textField.placeholder = TextManager.inputWeight.localized()
        textField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)
        textField.titleLabelAttributed = getRequiredAttibuted(from: TextManager.weight.localized())
        return textField
    }()
    
    private lazy var detailDesTitleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = getRequiredAttibuted(from: TextManager.detailDes.localized())
        return label
    }()
    
    fileprivate lazy var detailDesTextView: UITextView = {
        let textView = UITextView()
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
        textView.text = TextManager.inputDetailDes.localized()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = UIColor.placeholder
        textView.layer.borderColor = UIColor.separator.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 10
        textView.layer.masksToBounds = true
        textView.delegate = self
        return textView
    }()
    
    fileprivate lazy var guaranteeTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.placeholder = TextManager.inputGuarantee_Month.localized()
        textField.titleLabelAttributed = getRequiredAttibuted(from: TextManager.guarantee_Month.localized())
        textField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)
        textField.keyboardType = .numberPad
        return textField
    }()
    
    fileprivate lazy var sizeTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.titleLabelAttributed = getRequiredAttibuted(from: TextManager.size.localized())
        textField.placeholder = TextManager.inputSize.localized()
        textField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)
        return textField
    }()
    
    private lazy var addSizeButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.add.localized(), for: .normal)
        button.backgroundColor = UIColor.disable
        button.isUserInteractionEnabled = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = Dimension.shared.defaultHeightTextField / 2
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(tapOnAddNewSizeButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var listSizeView: CollectionTagView = {
        let view = CollectionTagView()
        view.delegate = self
        return view
    }()
    
    private lazy var addColorButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.add.localized(), for: .normal)
        button.backgroundColor = UIColor.disable
        button.isUserInteractionEnabled = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = Dimension.shared.defaultHeightTextField / 2
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(tapOnAddNewColorButton), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var colorTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.placeholder = TextManager.inputColor.localized()
        textField.titleLabelAttributed = getRequiredAttibuted(from:  TextManager.color.localized())
        textField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)
        return textField
    }()
    
    private lazy var listColorView: CollectionTagView = {
        let view = CollectionTagView()
        view.delegate = self
        return view
    }()
    
    fileprivate lazy var isGenuineCheckMarkView: CheckMarkView = {
        let view = CheckMarkView()
        view.title = TextManager.isGenuine.localized()
        view.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnIsGenuineView))
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    fileprivate lazy var listImageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: defaultProductImageWidth, height: defaultProductImageWidth)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerReusableCell(UploadImageCollectionViewCell.self)
        return collectionView
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
        
        if product.id != nil {
            navigationItem.title = TextManager.editProduct.localized()
        } else {
            navigationItem.title = TextManager.addNewProduct.localized()
        }
        
        layoutScrollView()
        layoutProductNameTextField()
        layoutCategoryTextField()
        layoutSupplierTextField()
        layoutOriginalPriceTextField()
        layoutPromotionPriceTextField()
        layoutUnitTextField()
        layoutWeightTextField()
        layoutDetailDesTitleLabel()
        layoutDetailDesTextView()
        layoutGuaranteeTextField()
        layoutAddNewSizeButton()
        layoutSizeTextField()
        layoutListSizeView()
        layoutAddNewColorButton()
        layoutColorTextField()
        layoutListColorView()
        layoutIsGenuineCheckMarkView()
        layoutImageCollectionView()
        layoutSaveButton()
        
        requestAPICategoryIfNeeded()
        requestAPISuplierIfNeeded()
    }
    
    // MARK: - UIActions
    
    @objc private func textFieldValueChange(_ textField: UITextField) {
        if (textField == sizeTextField.textField) {
            checkEnableAddSizeButton()
        }
        
        if (textField == colorTextField.textField) {
            checkEnableAddColorButton()
        }
        
        checkCanEnableSaveButton()
    }
    
    @objc private func textFieldBeginEditing(_ textField: UITextField) {
        if textField == categoryTextField.textField {
            requestAPICategoryIfNeeded()
            
            if let categoryId = product.categoryId {
                if let categoryIndex = viewModel.categories.firstIndex(where: { $0.id == categoryId }) {
                    categoryPickerView.selectRow(categoryIndex, inComponent: 0, animated: false)
                }
            } else {
                pickerView(categoryPickerView, didSelectRow: 0, inComponent: 0)
            }
            
        } else if textField == supplierTextField.textField {
            requestAPISuplierIfNeeded()
            
            if let supplierId = product.supplierId {
                if let supplierIndex = viewModel.suppliers.firstIndex(where: { $0.id == supplierId }) {
                    supplierPickerView.selectRow(supplierIndex, inComponent: 0, animated: false)
                }
            } else {
                pickerView(supplierPickerView, didSelectRow: 0, inComponent: 0)
            }
        }
    }
    
    @objc private func tapOnSaveButton() {
        let originalPrice = Double(originalPriceTextField.text ?? "") ?? 0
        let promotionPrice = Double(promotionPriceTextField.text ?? "") ?? 0
        if (promotionPrice >= originalPrice) {
            AlertManager.shared.show(message: TextManager.promotionPriceGreaterThanOriginalPrice.localized())
            return
        }
        
        product.name            = productNameTextField.text ?? ""
        product.categoryName    = categoryTextField.text ?? ""
        product.promoPrice      = Double(promotionPriceTextField.text ?? "") ?? 0
        product.unitPrice       = Double(originalPriceTextField.text ?? "") ?? 0
        product.quantityPerUnit = unitTextField.text ?? ""
        product.warranty        = Int(guaranteeTextField.text ?? "") ?? 0
        product.authentics      = (isGenuineCheckMarkView.state == .check)
        product.alias           = product.name.makeAliasCode()
        product.weight          = weightTextField.text?.toDouble() ?? 0
       
        if detailDesTextView.text != TextManager.inputDetailDes {
            product.detail = detailDesTextView.text
        }
        
        showLoading()
        
        var endPoint: ProductEndPoint
        if product.id != nil {
            endPoint = ProductEndPoint.updateProduct(parameters: product.toDictionary())
        } else {
            endPoint = ProductEndPoint.createProduct(parameters: product.toDictionary())
        }

        APIService.request(endPoint: endPoint, onSuccess: { [weak self] (apiResponse) in
            guard let self = self else { return }
            self.hideLoading()
            
            if self.product.id != nil {
                self.delegate?.didUpdateProductSuccess(self.product)
                AlertManager.shared.showToast(message: TextManager.updateProductSuccess.localized())
            } else {
                let product = apiResponse.toObject(Product.self)
                self.delegate?.didCreateProductSuccess(product)
                AlertManager.shared.showToast(message: TextManager.createProductSuccess.localized())
            }
            
            self.clearAllData()
            self.checkCanEnableSaveButton()
            
        }, onFailure: { [weak self]  (apiError) in
            self?.hideLoading()
            AlertManager.shared.showDefaultError()
        }) { [weak self] in
            self?.hideLoading()
            AlertManager.shared.showDefaultError()
        }
    }
    
    @objc private func tapOnIsGenuineView() {
        isGenuineCheckMarkView.updateState()
        product.authentics = (isGenuineCheckMarkView.state == .check)
        checkCanEnableSaveButton()
    }
    
    @objc private func tapOnAddNewSizeButton() {
        guard var newSize = sizeTextField.text else { return }
        newSize = newSize.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !product.colorModels.contains(newSize) else {
            AlertManager.shared.showToast(message: TextManager.invalidSize.localized())
            return
        }
        
        listSizeView.addTag(tag: newSize)
        sizeTextField.text = nil
        product.addNewSize(size: newSize)
        checkEnableAddSizeButton()
        checkCanEnableSaveButton()
    }
    
    @objc private func tapOnAddNewColorButton() {
        guard var newColor = colorTextField.text else { return }
        newColor = newColor.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !product.colorModels.contains(newColor) else {
            AlertManager.shared.showToast(message: TextManager.invalidColor.localized())
            return
        }
        
        listColorView.addTag(tag: newColor)
        colorTextField.text = nil
        product.addNewColor(color: newColor)
        checkEnableAddColorButton()
        checkCanEnableSaveButton()
    }
    
    // MARK: - Request API methods
    
    private func requestAPICategoryIfNeeded() {
        if !viewModel.categories.isEmpty {
            return
        }
        showLoading()
        viewModel.getAllCategories(completion: { [weak self] in
            guard let self = self else { return }
            self.categoryPickerView.reloadAllComponents()
            self.hideLoading()
        }) { [weak self] in
            guard let self = self else { return }
            self.hideLoading()
            AlertManager.shared.showToast()
        }
    }
    
    private func requestAPISuplierIfNeeded() {
        if !viewModel.suppliers.isEmpty {
            return
        }
        showLoading()
        viewModel.getAllSupplier(completion: { [weak self] in
            guard let self = self else { return }
            self.supplierPickerView.reloadAllComponents()
            self.hideLoading()
        }) { [weak self] in
            guard let self = self else { return }
            self.hideLoading()
            AlertManager.shared.showToast()
        }
    }
    
     // MARK: - Helper method
    
    private func getRequiredAttibuted(from text: String) -> NSAttributedString {
        let font = UIFont.systemFont(ofSize: FontSize.body.rawValue)
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
    
    private func checkEnableAddSizeButton() {
        if sizeTextField.text != nil && sizeTextField.text != "" {
            addSizeButton.isUserInteractionEnabled = true
            addSizeButton.backgroundColor = UIColor.accentColor
        } else {
            addSizeButton.isUserInteractionEnabled = false
            addSizeButton.backgroundColor = UIColor.disable
        }
    }
    
    private func checkEnableAddColorButton() {
        if colorTextField.text != nil && colorTextField.text != "" {
            addColorButton.isUserInteractionEnabled = true
            addColorButton.backgroundColor = UIColor.accentColor
        } else {
            addColorButton.isUserInteractionEnabled = false
            addColorButton.backgroundColor = UIColor.disable
        }
    }
    
    private func checkCanEnableSaveButton() {
        let productName     = productNameTextField.text ?? ""
        let categoryName    = categoryTextField.text ?? ""
        let originalPrice   = originalPriceTextField.text ?? ""
        let desciption      = detailDesTextView.text
        let guarantee       = guaranteeTextField.text ?? ""
        let weight          = Double(weightTextField.text ?? "") ?? 0
        
        if productName != "" && categoryName != "" && originalPrice != ""
            && desciption != "" && desciption != TextManager.inputDetailDes.localized()
            && guarantee != ""
            && product.sizeModels.count > 0 && product.colorModels.count > 0 && product.photos.count > 0
            && weight > 0 {
            
            saveButton.isUserInteractionEnabled = true
            saveButton.backgroundColor = UIColor.accentColor
        } else {
            saveButton.isUserInteractionEnabled = false
            saveButton.backgroundColor = UIColor.disable
        }
    }
    
    private func clearAllData() {
        product = Product()
        productNameTextField.text      = nil
        categoryTextField.text         = nil
        supplierTextField.text         = nil
        originalPriceTextField.text    = nil
        promotionPriceTextField.text   = nil
        unitTextField.text             = nil
        detailDesTextView.text                  = nil
        guaranteeTextField.text        = nil
        sizeTextField.text             = nil
        colorTextField.text            = nil
        isGenuineCheckMarkView.state            = .unCheck
        weightTextField.text           = nil
        
        listSizeView.setTag(tags: [])
        listColorView.setTag(tags: [])
        listImageCollectionView.reloadData()
    }
    
    // MARK: - Layouts

    private func layoutProductNameTextField() {
        scrollView.addSubview(productNameTextField)
        productNameTextField.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(Dimension.shared.normalMargin)
            make.right.equalTo(view).offset(-Dimension.shared.normalMargin)
            make.top.equalToSuperview().offset(Dimension.shared.largeMargin)
        }
    }
    
    private func layoutCategoryTextField() {
        scrollView.addSubview(categoryTextField)
        categoryTextField.snp.makeConstraints { (make) in
            make.width.centerX.equalTo(productNameTextField)
            make.top.equalTo(productNameTextField.snp.bottom).offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutSupplierTextField() {
        scrollView.addSubview(supplierTextField)
        supplierTextField.snp.makeConstraints { (make) in
            make.width.centerX.equalTo(productNameTextField)
            make.top.equalTo(categoryTextField.snp.bottom).offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutOriginalPriceTextField() {
        scrollView.addSubview(originalPriceTextField)
        originalPriceTextField.snp.makeConstraints { (make) in
            make.width.centerX.equalTo(productNameTextField)
            make.top.equalTo(supplierTextField.snp.bottom).offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutPromotionPriceTextField() {
        scrollView.addSubview(promotionPriceTextField)
        promotionPriceTextField.snp.makeConstraints { (make) in
            make.width.centerX.equalTo(productNameTextField)
            make.top.equalTo(originalPriceTextField.snp.bottom)
                .offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutUnitTextField() {
        scrollView.addSubview(unitTextField)
        unitTextField.snp.makeConstraints { (make) in
            make.width.centerX.equalTo(productNameTextField)
            make.top.equalTo(promotionPriceTextField.snp.bottom)
                .offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutWeightTextField() {
        scrollView.addSubview(weightTextField)
        weightTextField.snp.makeConstraints { (make) in
            make.width.centerX.equalTo(productNameTextField)
            make.top.equalTo(unitTextField.snp.bottom)
                .offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutDetailDesTitleLabel() {
        scrollView.addSubview(detailDesTitleLabel)
        detailDesTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(productNameTextField)
            make.top.equalTo(weightTextField.snp.bottom).offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutDetailDesTextView() {
        scrollView.addSubview(detailDesTextView)
        detailDesTextView.snp.makeConstraints { (make) in
            make.width.centerX.equalTo(productNameTextField)
            make.height.equalTo(80)
            make.top.equalTo(detailDesTitleLabel.snp.bottom).offset(Dimension.shared.mediumMargin)
        }
    }
    
    private func layoutGuaranteeTextField() {
        scrollView.addSubview(guaranteeTextField)
        guaranteeTextField.snp.makeConstraints { (make) in
            make.width.centerX.equalTo(productNameTextField)
            make.top.equalTo(detailDesTextView.snp.bottom)
                .offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutAddNewSizeButton() {
        scrollView.addSubview(addSizeButton)
        addSizeButton.snp.makeConstraints { (make) in
            make.height.equalTo(Dimension.shared.defaultHeightTextField)
            make.right.equalTo(supplierTextField)
            make.top.equalTo(guaranteeTextField.snp.bottom).offset(Dimension.shared.largeMargin_42)
            make.width.equalTo(100)
        }
    }
    
    private func layoutSizeTextField() {
        scrollView.addSubview(sizeTextField)
        sizeTextField.snp.makeConstraints { (make) in
            make.left.equalTo(productNameTextField)
            make.bottom.equalTo(addSizeButton)
            make.right.equalTo(addSizeButton.snp.left).offset(-Dimension.shared.mediumMargin)
        }
    }
    
    private func layoutListSizeView() {
        scrollView.addSubview(listSizeView)
        listSizeView.snp.makeConstraints { (make) in
            make.left.right.equalTo(productNameTextField)
            make.top.equalTo(sizeTextField.snp.bottom).offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutAddNewColorButton() {
        scrollView.addSubview(addColorButton)
        addColorButton.snp.makeConstraints { (make) in
            make.right.left.height.equalTo(addSizeButton)
            make.top.equalTo(listSizeView.snp.bottom).offset(Dimension.shared.largeMargin_42)
        }
    }
    
    private func layoutColorTextField() {
        scrollView.addSubview(colorTextField)
        colorTextField.snp.makeConstraints { (make) in
            make.left.equalTo(productNameTextField)
            make.bottom.equalTo(addColorButton)
            make.right.equalTo(addColorButton.snp.left).offset(-Dimension.shared.mediumMargin)
        }
    }
    
    private func layoutListColorView() {
        scrollView.addSubview(listColorView)
        listColorView.snp.makeConstraints { (make) in
            make.left.right.equalTo(productNameTextField)
            make.top.equalTo(colorTextField.snp.bottom).offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutIsGenuineCheckMarkView() {
        scrollView.addSubview(isGenuineCheckMarkView)
        isGenuineCheckMarkView.snp.makeConstraints { (make) in
            make.left.equalTo(productNameTextField)
            make.top.equalTo(listColorView.snp.bottom).offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutImageCollectionView() {
        scrollView.addSubview(listImageCollectionView)
        listImageCollectionView.snp.makeConstraints { (make) in
            make.left.right.equalTo(productNameTextField)
            make.top.equalTo(isGenuineCheckMarkView.snp.bottom)
                .offset(Dimension.shared.largeMargin_32)
            make.height.equalTo(imageCollectionViewHeight)
        }
    }
    
    private func layoutSaveButton() {
        scrollView.addSubview(saveButton)
        saveButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(productNameTextField)
            make.height.equalTo(Dimension.shared.defaultHeightButton)
            make.width.equalTo(Dimension.shared.mediumWidthButton)
            make.top.equalTo(listImageCollectionView.snp.bottom)
                .offset(Dimension.shared.largeMargin_42)
            make.bottom.equalToSuperview().offset(-50)
        }
    }
    
}

// MARK: - UITextViewDelegate

extension CreateProductViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == TextManager.inputDetailDes.localized() {
            textView.text = ""
        }
        
        textView.textColor = UIColor.titleText
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = TextManager.inputDetailDes.localized()
            textView.textColor = UIColor.placeholder
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        checkCanEnableSaveButton()
    }
}

// MARK: - UICollectionViewDelegate

extension CreateProductViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let maxSelectImage = CreateProductViewController.defaultNumberImages - product.photos.count
        if maxSelectImage <= 0 {
            AlertManager.shared.show(message: TextManager.selectMaxPhotoAddProduct.localized())
            return
        }
        AppRouter.presentToImagePicker(pickerDelegate: self, limitImage: maxSelectImage)
    }
}

// MARK: - UICollectionViewDatasource

extension CreateProductViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CreateProductViewController.defaultNumberImages
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UploadImageCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.indexPath = indexPath
        cell.delegate = self
        cell.setPhoto(photo: product.photos[safe: indexPath.row])
        return cell
    }
}

// MARK: - ImagePickerControllerDelegate

extension CreateProductViewController: ImagePickerControllerDelegate {
    func imagePickerController(_ picker: ImagePickerController,
                               shouldLaunchCameraWithAuthorization status: AVAuthorizationStatus) -> Bool {
        return true
    }
    
    func imagePickerController(_ picker: ImagePickerController,
                               didFinishPickingImageAssets assets: [PHAsset]) {
        dismiss(animated: true, completion: nil)
        var photos: [Photo] = Array(repeating: Photo(), count: assets.count)
        let dispatchGroup = DispatchGroup()
        
        DispatchQueue.global(qos: .userInteractive).async {
            for (index, asset) in assets.enumerated() {
                dispatchGroup.enter()
                asset.getUIImage(completion: { (image) in
                    if let image = image, index < photos.count {
                        photos[index] = Photo(image: image.normalizeImage())
                    }
                    dispatchGroup.leave()
                })
            }
            
            let result = dispatchGroup.wait(timeout: .now() + .seconds(5));
            if result == .success {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.product.addNewPhoto(photos: photos)
                    self.listImageCollectionView.reloadData()
                    self.checkCanEnableSaveButton()
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: ImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - CollectionTagViewDelegate

extension CreateProductViewController: CollectionTagViewDelegate {
    func didSelectDeleteTag(collectionTagView: CollectionTagView, at index: Int) {
        if collectionTagView == listSizeView {
            product.removeSize(at: index)
        } else if collectionTagView == listColorView {
            product.removeColor(at: index)
        }
        checkCanEnableSaveButton()
    }
}

// MARK: - UploadImageCollectionViewCellDelegate

extension CreateProductViewController: UploadImageCollectionViewCellDelegate {
    func didSelectDeleteButton(cell: UploadImageCollectionViewCell, at inexPath: IndexPath) {
        product.removePhoto(at: inexPath.row)
        listImageCollectionView.reloadData()
        checkCanEnableSaveButton()
    }
}

// MARK: - UIPickerViewDelegate

extension CreateProductViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == categoryPickerView {
            if let category = viewModel.categories[safe: row] {
                product.categoryId = category.id
                product.categoryName = category.name
                categoryTextField.text = category.name
            }
        } else {
            if let supplier = viewModel.suppliers[safe: row] {
                product.supplierId = supplier.id
                product.supplierName = supplier.name
                supplierTextField.text = supplier.name
            }
        }
        
        checkCanEnableSaveButton()
    }
}

// MARK: - UIPickerViewDataSource

extension CreateProductViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == categoryPickerView {
            return viewModel.categories.count
        } else {
            return viewModel.suppliers.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == categoryPickerView {
            return viewModel.categories[safe: row]?.name
        } else {
            return viewModel.suppliers[safe: row]?.name
        }
    }
}
