//
//  UploadImageCollectionViewCell.swift
//  ZoZoApp
//
//  Created by MACOS on 7/2/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

protocol UploadImageCollectionViewCellDelegate: class {
    func didSelectDeleteButton(cell: UploadImageCollectionViewCell, at inexPath: IndexPath)
}

class UploadImageCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Variables
    
    weak var delegate: UploadImageCollectionViewCellDelegate?
    var indexPath: IndexPath?
    
    private let rightMargin: CGFloat = 13
    private var imageURL: String?
    private var image: UIImage?
    
    // MARK: - UI Elements
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.addNewImgPlaceHolder
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.closeCircle, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(tapOnDeleteButton), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    private lazy var deleteButtonView: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(tapOnDeleteButton), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    // MARK: - LifeCycles
    
    override func initialize() {
        layoutImageView()
        layoutDeleteButton()
        layoutDeleteButtonView()
    }
    
    // MARK: - Public methods
    
    func setPhoto(photo: Photo?) {
        if let url = photo?.url, url != "" {
            setImageURL(urlString: url.addImageDomainIfNeeded())
        } else if let image = photo?.currentImage {
            setImage(image: image)
        } else {
            imageURL = nil
            image = nil
            imageView.image = ImageManager.addNewImgPlaceHolder
            checkShowDeleteButton()
        }
    }
    
    func setImageURL(urlString: String) {
        imageURL = urlString
        imageView.sd_setImage(with: urlString.url, completed: nil)
        image = nil
        checkShowDeleteButton()
    }
    
    func setImage(image: UIImage) {
        imageView.image = image
        self.image = image
        self.imageURL = nil
        checkShowDeleteButton()
    }
    
    // MARK: - UI Action
    
    @objc private func tapOnDeleteButton() {
        guard let indexPath = indexPath else { return }
        delegate?.didSelectDeleteButton(cell: self, at: indexPath)
    }
    
    // MARK: - Helper methods
    
    private func checkShowDeleteButton() {
        if imageURL != nil || image != nil {
            deleteButton.isHidden = false
            deleteButtonView.isHidden = false
            imageView.layer.borderColor = UIColor.separator.withAlphaComponent(0.5).cgColor
            imageView.layer.borderWidth = 0.5
        } else {
            deleteButton.isHidden = true
            deleteButtonView.isHidden = true
            imageView.layer.borderColor = UIColor.clear.cgColor
            imageView.layer.borderWidth = 0.5
        }
    }
    
    // MARK: - Layouts
    
    private func layoutImageView() {
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(rightMargin / 2)
            make.bottom.equalToSuperview().offset(-rightMargin / 2)
            make.right.equalToSuperview().offset(-rightMargin)
        }
    }
    
    private func layoutDeleteButton() {
        addSubview(deleteButton)
        deleteButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(20)
            make.centerX.equalTo(imageView.snp.right).offset(-4)
            make.centerY.equalTo(imageView.snp.top).offset(4)
        }
    }
    
    private func layoutDeleteButtonView() {
        addSubview(deleteButtonView)
        deleteButtonView.snp.makeConstraints { (make) in
            make.width.height.equalTo(37)
            make.right.top.equalToSuperview()
        }
    }
    
}
