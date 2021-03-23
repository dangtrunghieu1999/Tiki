//
//  PersonalHeaderCollectionReusableView.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 3/22/21.
//

import UIKit

class PersonalHeaderCollectionReusableView: BaseCollectionViewHeaderFooterCell {
    
    // MARK: - Variables
    
    // MARK: - UI Elements
    
    fileprivate lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.avatarDefault
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.welcome
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        label.textAlignment = .left
        return label
    }()
    
    fileprivate lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.welcomeSignInUp
        label.textColor = UIColor.subTitle
        label.font = UIFont.systemFont(ofSize: FontSize.body.rawValue, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
    // MARK: - View LifeCycles
    
    override func initialize() {
        super.initialize()
        backgroundColor = .white
        layoutAvatarImageView()
        layoutTitleLabel()
        layoutSubTitleLabel()
    }
    
    // MARK: - Helper Method
    
    // MARK: - GET API
    
    // MARK: - Layout
    
    private func layoutAvatarImageView() {
        addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(50)
            make.left.equalToSuperview().offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatarImageView.snp.right).offset(Dimension.shared.normalMargin)
            make.top.equalTo(avatarImageView)
            make.right.equalToSuperview().offset(-Dimension.shared.normalMargin)
        }
    }
    
    private func layoutSubTitleLabel() {
        addSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(Dimension.shared.smallMargin)
        }
    }
}
