//
//  ChatShopTableViewCell.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 5/15/21.
//

import UIKit

protocol ChatShopTableViewCellDelegate: class {
    func didSelectChatRoomShop()
}

class ChatShopTableViewCell: BaseTableViewCell {
    
    weak var delegate: ChatShopTableViewCellDelegate?
    
    // MARK: - Define Components
    fileprivate lazy var itemImageView: UIImageView = {
        var imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.image = ImageManager.avatarDefault
        return imageView
    }()
    
    fileprivate lazy var itemNameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        label.numberOfLines = 0
        label.textColor = .bodyText
        label.setContentHuggingPriority(UILayoutPriority(249), for: .horizontal)
        label.setContentCompressionResistancePriority(UILayoutPriority(749), for: .horizontal)
        label.text = "Túi Du lịch Vali kéo đựng"
        label.numberOfLines = 1
        return label
    }()
    
    fileprivate lazy var subLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        label.numberOfLines = 0
        label.textColor = .lightBodyText
        label.setContentHuggingPriority(UILayoutPriority(249), for: .vertical)
        label.setContentCompressionResistancePriority(UILayoutPriority(749), for: .vertical)
        label.text = "Shop GH store"
        return label
    }()
    
    fileprivate lazy var chatButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.chat, for: .normal)
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.primary, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        button.isUserInteractionEnabled = true
        button.layer.borderWidth = 1
        button.titleLabel?.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        button.layer.borderColor = UIColor.primary.cgColor
        button.addTarget(self, action: #selector(tapOnChattingRoomShop), for: .touchUpInside)
        return button
    }()
    
    
    let lineView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.separator
        return view
    }()
    
    // MARK: - Define Variables
    
    // MARK: - Override Methods
    
    override func initialize() {
        self.setupItemImageView()
        self.setupItemNameLabel()
        self.setupSubLabel()
        self.setupChatButton()
        self.setupLineView()
    }
    
    // MARK: - UI Action
    
    @objc func tapOnChattingRoomShop() {
        delegate?.didSelectChatRoomShop()
    }
}

// MARK: - Setup Components
extension ChatShopTableViewCell {
    
    private func setupItemImageView() {
        self.contentView.addSubview(self.itemImageView)
        self.itemImageView.snp.makeConstraints { (make) in
            make.top.bottom.leading.equalToSuperview().inset(dimension.normalMargin)
            make.width.equalTo(dimension.largeMargin_56)
            make.height.equalTo(self.itemImageView.snp.width)
        }
    }
    
    private func setupItemNameLabel() {
        self.contentView.addSubview(self.itemNameLabel)
        self.itemNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.itemImageView)
            make.leading.equalTo(self.itemImageView.snp.trailing).offset(dimension.mediumMargin)
        }
    }
    
    private func setupSubLabel() {
        self.contentView.addSubview(self.subLabel)
        self.subLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.itemNameLabel.snp.bottom).offset(dimension.mediumMargin)
            make.leading.trailing.equalTo(self.itemNameLabel)
        }
    }
    
    private func setupChatButton() {
        self.contentView.addSubview(self.chatButton)
        self.chatButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalTo(self.itemNameLabel.snp.trailing).offset(dimension.normalMargin)
            make.trailing.equalToSuperview().inset(dimension.normalMargin)
            make.width.equalTo(80 + dimension.mediumMargin)
            make.height.equalTo(dimension.largeMargin_32 + dimension.smallMargin)
        }
    }
    
    private func setupLineView() {
        self.contentView.addSubview(self.lineView)
        self.lineView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(dimension.normalMargin)
            make.height.equalTo(1.0)
            make.bottom.equalToSuperview()
        }
    }
    
}
