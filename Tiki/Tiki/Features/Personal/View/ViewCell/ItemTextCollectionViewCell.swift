//
//  ItemTextCollectionViewCell.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 3/19/21.
//

import UIKit

class ItemTextCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Variables
    
    
    // MARK: - UI Elements
    
    fileprivate lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor.titleText
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        return label
    }()
    
    fileprivate lazy var nextButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.setImage(ImageManager.more, for: .normal)
        button.backgroundColor = UIColor.clear
        return button
    }()
    
    
    // MARK: - View LifeCycles
    
    override func initialize() {
        super.initialize()
        layoutImageView()
        layoutNextButton()
        layoutTitleLabel()
    }
    
    // MARK: - Helper Method
    
    func configCell(_ title: String,_ image: UIImage?) {
        imageView.image = image
        titleLabel.text = title
    }
    
    // MARK: - GET API
    
    // MARK: - Layout
    
    private func layoutImageView() {
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Dimension.shared.normalMargin)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
    }
    
    private func layoutNextButton() {
        addSubview(nextButton)
        nextButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-Dimension.shared.normalMargin)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(12)
        }
    }
    
    private func layoutTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(imageView)
            make.left.equalTo(imageView.snp.right).offset(Dimension.shared.normalMargin)
        }
    }
}
