//
//  PostFeedActionView.swift
//  ZoZoApp
//
//  Created by LAP12852 on 9/20/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

protocol PostFeedActionViewDelegate: class {
    func didSelectLocationButton()
    func didSelectTagFriendButton()
    func didSelectEmojiButton()
    func didSelectPostPhotoButton()
}

class PostFeedActionView: BaseView {

    // MARK: - Variables
    
    weak var delegate: PostFeedActionViewDelegate?
    
    // MARK: - UI Elements
    
    private lazy var locationButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.location, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(touchInLocationButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var emojiButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.emoji, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(touchInEmojiButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var tagFriendButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.tagFriend, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(touchInTagFriendButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var postPhotoButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.postPhoto, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(touchInPostPhotoButton), for: .touchUpInside)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.addToYourPost.localized()
        label.textColor = UIColor.lightBodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        return label
    }()
    
    // MARK: - LifeCycles
    
    override func initialize() {
        layoutLocationButton()
        layoutEmojiButton()
        layoutTagFriendButton()
        layoutPostPhotoButton()
        layoutTitleLabel()
    }
    
    // MARK: - Public Methods
    
    // MARK: - UI Actions
    
    @objc private func touchInLocationButton() {
        delegate?.didSelectLocationButton()
    }
    
    @objc private func touchInEmojiButton() {
        delegate?.didSelectEmojiButton()
    }
    
    @objc private func touchInTagFriendButton() {
        delegate?.didSelectTagFriendButton()
    }
    
    @objc private func touchInPostPhotoButton() {
        delegate?.didSelectPostPhotoButton()
    }
    
    // MARK: - Layout
    
    private func layoutLocationButton() {
        addSubview(locationButton)
        locationButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(25)
            make.bottom.equalToSuperview().offset(-16)
            make.right.equalToSuperview().offset(-16)
        }
    }
    
    private func layoutEmojiButton() {
        addSubview(emojiButton)
        emojiButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(locationButton)
            make.bottom.equalTo(locationButton)
            make.right.equalTo(locationButton.snp.left).offset(-16)
        }
    }
    
    private func layoutTagFriendButton() {
        addSubview(tagFriendButton)
        tagFriendButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(locationButton)
            make.bottom.equalTo(locationButton)
            make.right.equalTo(emojiButton.snp.left).offset(-16)
        }
    }
    
    private func layoutPostPhotoButton() {
        addSubview(postPhotoButton)
        postPhotoButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(locationButton)
            make.bottom.equalTo(locationButton)
            make.right.equalTo(tagFriendButton.snp.left).offset(-16)
        }
    }
    
    private func layoutTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(locationButton)
            make.left.equalToSuperview().offset(8)
        }
    }

}
