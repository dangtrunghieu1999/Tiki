//
//  CheckBoxAndDescriptionView.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 5/15/21.
//

import UIKit

class CheckBoxAndDescriptionView: BaseView {
    
    // MARK: - Variables
    
    var iconWidth: CGFloat = dimension.checkBoxHeight {
        didSet {
            self.iconImageView.snp.updateConstraints { (make) in
                make.width.equalTo(self.iconWidth)
                make.height.equalTo(self.iconImageView.snp.width)
            }
        }
    }
    
    // MARK: - Define Components
    let iconImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        label.textColor = UIColor.bodyText
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    let extraIconImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
    // MARK: - Define Variables
    private var activeImage: UIImage!
    private var deactiveImage: UIImage!
    private var extraImage: UIImage?
    
    var isActive: Bool = false {
        didSet {
            guard let activeImage = self.activeImage, let deactiveImage = self.deactiveImage else { return }
            self.iconImageView.image = self.isActive ? activeImage : deactiveImage
        }
    }
    
    // MARK: - Handle Action
    var handleDidChange: ((Bool) -> Void)?
    
    // MARK: - Init
    convenience init(activeImageName: String, deactiveImageName: String, description: String, isActive: Bool = false, extraIcon: String? = nil) {
        self.init(frame: .zero)
        
        self.activeImage = UIImage(named: activeImageName)
        self.deactiveImage = UIImage(named: deactiveImageName)
        
        if extraIcon != nil {
            self.extraImage = UIImage(named: extraIcon!)
            self.extraIconImageView.image = extraImage
        }
        
        self.descriptionLabel.text = description
        self.iconImageView.image = isActive ? activeImage : deactiveImage
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CheckBoxAndDescriptionView.onTap))
        self.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Override Methods
    override func initialize() {
        self.setupIconImageView()
        self.setupDescriptionLabel()
    }
    
    func setupExtraImage() {
        if self.extraImage != nil {
            self.extraIconImageView.image = self.extraImage
            self.addSubview(self.extraIconImageView)
            self.extraIconImageView.snp.makeConstraints { (make) in
                make.top.equalToSuperview()
                make.leading.equalTo(self.iconImageView.snp.trailing).offset(dimension.normalMargin)
                make.width.equalTo(dimension.largeMargin)
                make.height.equalTo(self.extraIconImageView.snp.width)
                make.bottom.lessThanOrEqualToSuperview()
            }
            
            self.descriptionLabel.snp.remakeConstraints { (make) in
                make.top.trailing.bottom.equalToSuperview()
                make.leading.equalTo(self.extraIconImageView.snp.trailing).offset(dimension.mediumMargin)
            }
        }
    }
}

// MARK: - Setup UI
extension CheckBoxAndDescriptionView {
    
    private func setupIconImageView() {
        self.addSubview(self.iconImageView)
        self.iconImageView.snp.makeConstraints { (make) in
            make.top.leading.equalToSuperview()
            make.width.equalTo(dimension.normalMargin)
            make.height.equalTo(self.iconImageView.snp.width)
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    private func setupDescriptionLabel() {
        self.addSubview(self.descriptionLabel)
        self.descriptionLabel.snp.makeConstraints { (make) in
            make.top.trailing.bottom.equalToSuperview()
            make.leading.equalTo(self.iconImageView.snp.trailing).offset(dimension.mediumMargin)
        }
    }
}

// MARK: - Handle Action
extension CheckBoxAndDescriptionView {
    
    @objc private func onTap() {
        self.isActive = !self.isActive
        self.handleDidChange?(self.isActive)
    }
}
