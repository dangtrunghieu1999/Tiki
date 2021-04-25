//
//  SelectedFriendCollectionViewCell.swift
//  ZoZoApp
//
//  Created by LAP12852 on 10/20/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

protocol SelectedFriendCollectionViewCellDelegate: class {
    func didSelectDelete(at indexPath: IndexPath)
}

class SelectedFriendCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Variables
    
    weak var delegate: SelectedFriendCollectionViewCellDelegate?
    
    private var indexPath: IndexPath?
    
    // MARK: - UI Elements
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.lightSeparator.cgColor
        imageView.layer.borderWidth = 0.5
        return imageView
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.closeCircle, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(touchInDeleteButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - LifeCycles
    
    override func initialize() {
        layoutAvatarImageView()
        layoutDeleteButton()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
    }
    
    // MARK: - Public Methods
    
    func configure(_ imageURL: String, indexPath: IndexPath) {
        self.indexPath = indexPath
        avatarImageView.loadImage(by: imageURL, defaultImage: ImageManager.userAvatar)
    }
    
    // MARK: - UI Actions
    
    @objc private func touchInDeleteButton() {
        if let indexPath = indexPath {
            delegate?.didSelectDelete(at: indexPath)
        }
    }
    
    // MARK: - Layout
    
    private func layoutAvatarImageView() {
        addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { (make) in
            make.leading.top.equalToSuperview().offset(Dimension.shared.mediumMargin)
            make.trailing.bottom.equalToSuperview().inset(Dimension.shared.mediumMargin)
        }
    }
    
    private func layoutDeleteButton() {
        addSubview(deleteButton)
        deleteButton.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().inset(dimension.smallMargin)
            make.top.equalToSuperview().offset(dimension.smallMargin)
            make.width.height.equalTo(20)
        }
    }
    
}
