//
//  FilterCouponPulleyView.swift
//  CustomerApp
//
//  Created by Bee on 2/23/20.
//  Copyright © 2020 Bee. All rights reserved.
//

import UIKit

protocol FilterCouponPulleyViewDelegate: class {
    func didSelectedFilterCoupon(selectedOrderTypes: [FilterCouponOrderType], selecedValidationTypes: [FilterCupponByValidation])
}

class FilterCouponPulleyView: ShowHidePulleyView {
    
    // MARK: - Define Components
    private let titleLabel: UILabel = {
        let label = UILabel()
//        label.text = TextManager.whatDoYouWantToView.localized()
        label.textAlignment = .center
        label.textColor = UIColor.secondary1
//        label.font = UIFont.fromType(FontType.secondary(.bold, .title))
        return label
    }()
    
    fileprivate lazy var checkListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.headerReferenceSize = CGSize(width: self.frame.width, height: 20)
        layout.footerReferenceSize = CGSize(width: self.frame.width, height: 24)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerReusableCell(CheckListCollectionViewCell.self)
//        collectionView.registerReusableSupplementaryView(TitleHeaderCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        collectionView.registerReusableSupplementaryView(BaseCollectionViewHeaderFooterCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter)
        return collectionView
    }()
    
    fileprivate let lineView: UIView = {
        let view = UIView()
//        view.backgroundColor = UIColor.secondary3
        return view
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.cancel.localized(), for: .normal)
//        button.setTitleColor(UIColor.secondary2, for: .normal)
//        button.titleLabel?.font = UIFont.fromType(FontType.primary(.bold, .h1))
//        button.backgroundColor = UIColor.background1
//        button.layer.borderColor = UIColor.secondary3.cgColor
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 5
//        button.rx.controlEvent(.touchUpInside).asObservable().subscribe(onNext: { [weak self] in
//            guard let self = self else { return }
//            self.hidePulley()
//        }).disposed(by: self.disposeBag)
        return button
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.confirm.localized(), for: .normal)
//        button.titleLabel?.font = UIFont.fromType(FontType.primary(.bold, .h1))
//        button.backgroundColor = UIColor.primary1
//        button.layer.cornerRadius = 5
//        button.rx.controlEvent(.touchUpInside).asObservable().subscribe(onNext: { [weak self] in
//            guard let self = self else { return }
//            self.delegate?.didSelectedFilterCoupon(selectedOrderTypes: self.viewModel.selectedOrderTypes, selecedValidationTypes: self.viewModel.selectedValidations)
//            self.hidePulley()
//        }).disposed(by: self.disposeBag)
        return button
    }()
    
    // MARK: - Define Variables
    private let viewModel = FilterCouponViewModel()
    weak var delegate: FilterCouponPulleyViewDelegate?
    
    // MARK: - Override Methods
    
    override func initialize() {
        super.initialize()
        self.layoutTitleLabel()
        self.layoutCheckListCollectionView()
        self.layoutLineView()
        self.layoutCancelButton()
        self.layoutConfirmButton()
    }
    
    override func estimatePulleyMinHeight() -> CGFloat {
        return 420 + UIApplication.shared.bottomSafeAreaInsets
    }
}

// MARK: - Setup Components
extension FilterCouponPulleyView {
    
    private func layoutTitleLabel() {
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
    }
    
    private func layoutCheckListCollectionView() {
        self.contentView.addSubview(self.checkListCollectionView)
        self.checkListCollectionView.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview()
            make.left.equalToSuperview().offset(dimension.normalMargin)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(dimension.normalMargin)
            make.height.equalTo(279)
        }
    }
    
    private func layoutLineView() {
        self.contentView.addSubview(self.lineView)
        self.lineView.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.width.centerX.equalToSuperview()
            make.top.equalTo(self.checkListCollectionView.snp.bottom)
        }
    }
    
    private func layoutCancelButton() {
        self.contentView.addSubview(self.cancelButton)
        self.cancelButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(dimension.mediumMargin)
            make.height.equalTo(48)
            make.trailing.equalTo(self.contentView.snp.centerX).offset(-dimension.mediumMargin)
            make.top.equalTo(self.lineView.snp.bottom).offset(16)
        }
    }
    
    private func layoutConfirmButton() {
        self.contentView.addSubview(self.confirmButton)
        self.confirmButton.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-dimension.mediumMargin)
            make.height.top.equalTo(self.cancelButton)
            make.leading.equalTo(self.contentView.snp.centerX).offset(dimension.mediumMargin)
        }
    }
}

// MARK: - Support Methods

// MARK: - UICollectionViewDataSource
extension FilterCouponPulleyView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CheckListCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        let isSelected = self.viewModel.isSelectedCell(at: indexPath)
        
        if indexPath.section == 0 {
            if let orderType = FilterCouponOrderType(rawValue: indexPath.row) {
                cell.configureData(with: orderType.description, isSelected)
            }
        } else {
            if let validationType = FilterCupponByValidation(rawValue: indexPath.row) {
                cell.configureData(with: validationType.description, isSelected)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header: TitleCollectionViewHeaderCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)
//            if indexPath.section == 0 {
//                header.configureTitle(TextManager.viewByOrderType.localized())
//            } else {
//                header.configureTitle(TextManager.viewByValidation.localized())
//            }
            return header
        } else {
            let footer: BaseCollectionViewHeaderFooterCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)
            return footer
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FilterCouponPulleyView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2, height: 50)
    }
}

// MARK: - UICollectionViewDelegate
extension FilterCouponPulleyView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if let orderType = FilterCouponOrderType(rawValue: indexPath.row),
                self.viewModel.didSelectOrderType(orderType){
                self.checkListCollectionView.reloadData()
            }
        } else {
            if let validationType = FilterCupponByValidation(rawValue: indexPath.row),
                self.viewModel.didSelectValidationType(validationType) {
                self.checkListCollectionView.reloadData()
            }
        }
    }
}
