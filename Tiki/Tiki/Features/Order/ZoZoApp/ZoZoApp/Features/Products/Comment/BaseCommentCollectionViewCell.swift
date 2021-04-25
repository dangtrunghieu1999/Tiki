//
//  BaseCommentCollectionViewCell.swift
//  ZoZoApp
//
//  Created by LAP12852 on 9/15/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit
import HCSStarRatingView

protocol ProductDetailCommentCollectionViewCellDelegate: class {
    func didSelectLikeComment(_ comment: Comment)
    func didSelectReplyComment(_ comment: Comment)
}

class BaseCommentCollectionViewCell: BaseCollectionViewCell {
    private typealias Cell = BaseCommentCollectionViewCell
    
    // MARK: - Supporting caculate cell height
    
    static let avatarTopMargin:         CGFloat         = 10
    static let avatarHeight:            CGFloat         = 40
    static let normalAvatarLeftMargin:  CGFloat         = 16
    static let childAvatarLeftMargin:   CGFloat         = 60
    static let messageBGMargin:         CGFloat         = 10
    static let messageLeftMargin:       CGFloat         = 20
    static let messageRightMargin:      CGFloat         = 25
    static let ratingViewTopMargin:     CGFloat         = 4
    static let ratingViewHeight:        CGFloat         = 16
    static let likeCommentHeight:       CGFloat         = 30
    static let defaultVerticalMargin:   CGFloat         = 8
    static let displayNameHeight:       CGFloat         = 16
    
    // MARK: - Variables
    
    weak var delegate: ProductDetailCommentCollectionViewCellDelegate?
    
    private var comment = Comment()
    private let imageSpacing:           CGFloat         = 3
    
    var numberHorizontalItem: CGFloat {
        let ipadAirWidth: CGFloat = 768
        var numberHorizontalItem: CGFloat = 3
        
        if ScreenSize.SCREEN_WIDTH >= ipadAirWidth {
            numberHorizontalItem = 8
        }
        
        return numberHorizontalItem
    }
    
    fileprivate var defaultCommentImageWidth: CGFloat {
        return (ScreenSize.SCREEN_WIDTH - 2 * Dimension.shared.normalMargin - (numberHorizontalItem - 1) * imageSpacing) / numberHorizontalItem
    }
    
    func imageCollectionViewHeigh(photos: Int) -> CGFloat {
        if photos == 0 {
            return 0
        }
        let verticalItem = ceil(CGFloat(photos) / numberHorizontalItem)
        return defaultCommentImageWidth * verticalItem + (verticalItem - 1) * imageSpacing
    }
    
    // MARK: - UI Elements
    
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.defaultAvatar
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = ProductParentCommentCollectionViewCell.avatarHeight / 2
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnUserProfile))
        imageView.addGestureRecognizer(tapGesture)
        return imageView
    }()
    
    lazy var displayNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .medium)
        return label
    }()
    
    let messageBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.messageBackground
        view.layer.cornerRadius = 14
        view.layer.masksToBounds = true
        return view
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor.lightBodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h3.rawValue)
        label.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnUserProfile))
        label.addGestureRecognizer(tapGesture)
        return label
    }()
    
    var messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var imagesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = imageSpacing
        layout.minimumInteritemSpacing = imageSpacing
        layout.itemSize = CGSize(width: defaultCommentImageWidth, height: defaultCommentImageWidth)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.registerReusableCell(ImageCollectionViewCell.self)
        return collectionView
    }()
    
    let ratingView: HCSStarRatingView = {
        let ratingView = HCSStarRatingView()
        ratingView.allowsHalfStars = true
        ratingView.emptyStarColor = UIColor.lightBackground
        ratingView.tintColor = UIColor.accentColor
        ratingView.isUserInteractionEnabled = false
        return ratingView
    }()
    
    lazy var likeCommentButton: UIButton = {
        let button = UIButton()
        button.sizeToFit()
        button.contentHorizontalAlignment = .left
        button.setTitle(TextManager.like.localized(), for: .normal)
        button.setTitleColor(UIColor.lightBodyText, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .medium)
        button.addTarget(self, action: #selector(tapOnLikeButton), for: .touchUpInside)
        button.contentVerticalAlignment = .bottom
        return button
    }()
    
    lazy var replyButton: UIButton = {
        let button = UIButton()
        button.sizeToFit()
        button.contentHorizontalAlignment = .left
        button.setTitle(TextManager.reply.localized(), for: .normal)
        button.setTitleColor(UIColor.lightBodyText, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .medium)
        button.addTarget(self, action: #selector(tapOnReplyButton), for: .touchUpInside)
        button.contentVerticalAlignment = .bottom
        return button
    }()
    
    override func initialize() {
        super.initialize()
        addSubview(messageBackgroundView)
    }
    
    // MARK: - Public Methods
    
    func setupLayout(isParentComment: Bool) {
        layoutAvatarImageView(isParentComment: isParentComment)
        layoutDisplayNameLabel()
        layoutMessageLabel()
        layoutMessageBGView()
        layoutImagesCollectionView()
        layoutRatingView(isParentComment: isParentComment)
        layoutTimeLabel(isParentComment: isParentComment)
        layoutLikeCommentButton()
        layoutReplyButton()
    }
    
    static func estimateHeight(_ comment: Comment) -> CGFloat {
        var messageWidth = ScreenSize.SCREEN_WIDTH - avatarHeight - messageLeftMargin - messageRightMargin
        
        if comment.isParrentComment {
            messageWidth -= normalAvatarLeftMargin
        } else {
            messageWidth -= childAvatarLeftMargin
        }
        
        let estimateMessageHeight = comment.content.height(withConstrainedWidth: messageWidth, font: UIFont.systemFont(ofSize: FontSize.h1.rawValue))
        
        let likeCommentHeight: CGFloat = 30
        var cellHeight = avatarTopMargin + displayNameHeight + estimateMessageHeight + 2 * defaultVerticalMargin + likeCommentHeight
        
        if (!comment.photos.isEmpty) {
            cellHeight += ProductParentCommentCollectionViewCell().imageCollectionViewHeigh(photos: comment.photos.count)
            cellHeight += defaultVerticalMargin
        }
        
        if comment.isParrentComment {
            cellHeight += ratingViewTopMargin
            cellHeight += ratingViewHeight
        }
        
        return cellHeight
    }
    
    func configData(comment: Comment) {
        self.comment = comment
        
        messageLabel.text = comment.content
        avatarImageView.loadImage(by: comment.userAvatar,
                                  defaultImage: ImageManager.smallUserAvatar)
        ratingView.value = CGFloat(comment.rating)
        displayNameLabel.text = comment.fullName
        timeLabel.text = comment.createOn.desciption(by: .shortDateUserFormat)
        
        if comment.photos.isEmpty {
            imagesCollectionView.snp.updateConstraints { (make) in
                make.top.equalTo(messageBackgroundView.snp.bottom).offset(0)
                make.height.equalTo(0)
            }
        } else {
            let imagesHeight = imageCollectionViewHeigh(photos: comment.photos.count)
            imagesCollectionView.snp.updateConstraints { (make) in
                make.top.equalTo(messageBackgroundView.snp.bottom)
                    .offset(Dimension.shared.normalMargin)
                make.height.equalTo(imagesHeight)
            }
        }
        
        imagesCollectionView.reloadData()
    }
    
    // MARK: - User Actions
    
    @objc private func tapOnUserProfile() {
        AppRouter.pushToUserProfile(comment.userId)
    }
    
    @objc private func tapOnLikeButton() {
        delegate?.didSelectLikeComment(comment)
    }
    
    @objc private func tapOnReplyButton() {
        delegate?.didSelectReplyComment(comment)
    }
    
    // MARK: - Layouts
    
    private func layoutAvatarImageView(isParentComment: Bool) {
        let leftMargin = isParentComment ? Cell.normalAvatarLeftMargin : Cell.childAvatarLeftMargin
        
        addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(Cell.avatarHeight)
            make.top.equalToSuperview().offset(Cell.avatarTopMargin)
            make.left.equalToSuperview().offset(leftMargin)
        }
    }
    
    private func layoutDisplayNameLabel() {
        addSubview(displayNameLabel)
        displayNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatarImageView.snp.right).offset(Cell.messageLeftMargin)
            make.right.equalToSuperview().offset(-Cell.messageRightMargin)
            make.top.equalTo(avatarImageView)
        }
    }
    
    private func layoutMessageLabel() {
        addSubview(messageLabel)
        messageLabel.snp.makeConstraints { (make) in
            make.left.equalTo(displayNameLabel)
            make.right.equalToSuperview().offset(-Cell.messageRightMargin)
            make.top.equalTo(displayNameLabel.snp.bottom)
        }
    }
    
    private func layoutMessageBGView() {
        messageBackgroundView.snp.makeConstraints { (make) in
            make.left.equalTo(messageLabel).offset(-Cell.messageBGMargin)
            make.right.equalTo(messageLabel).offset(Cell.messageBGMargin)
            make.top.equalTo(displayNameLabel).offset(-Cell.messageBGMargin)
            make.bottom.equalTo(messageLabel).offset(Cell.messageBGMargin)
        }
    }
    
    private func layoutImagesCollectionView() {
        let height: CGFloat = imageCollectionViewHeigh(photos: comment.photos.count)
        addSubview(imagesCollectionView)
        imagesCollectionView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Dimension.shared.normalMargin)
            make.right.equalToSuperview().offset(-Dimension.shared.normalMargin)
            make.top.equalTo(messageBackgroundView.snp.bottom).offset(Cell.defaultVerticalMargin)
            make.height.equalTo(height)
        }
    }
    
    private func layoutRatingView(isParentComment: Bool) {
        addSubview(ratingView)
        ratingView.snp.makeConstraints { (make) in
            make.left.equalTo(messageLabel)
            make.width.equalTo(130)
            make.top.equalTo(imagesCollectionView.snp.bottom).offset(Cell.ratingViewTopMargin)
            if isParentComment {
                make.height.equalTo(Cell.ratingViewHeight)
                make.top.equalTo(imagesCollectionView.snp.bottom)
                    .offset(Cell.ratingViewTopMargin)
            } else {
                make.height.equalTo(0)
                make.top.equalTo(imagesCollectionView.snp.bottom).offset(0)
            }
        }
    }
    
    private func layoutTimeLabel(isParentComment: Bool) {
        addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(displayNameLabel)
            make.top.equalTo(ratingView.snp.bottom)
                .offset(2 * Cell.defaultVerticalMargin)
            if isParentComment {
                make.top.equalTo(ratingView.snp.bottom)
                    .offset(2 * Cell.defaultVerticalMargin)
            } else {
                make.top.equalTo(imagesCollectionView.snp.bottom)
                    .offset(2 * Cell.defaultVerticalMargin)
            }
        }
    }
    
    private func layoutLikeCommentButton() {
        addSubview(likeCommentButton)
        likeCommentButton.snp.makeConstraints { (make) in
            make.left.equalTo(timeLabel.snp.right)
                .offset(Dimension.shared.normalMargin)
            make.bottom.equalTo(timeLabel).offset(6)
        }
    }
    
    private func layoutReplyButton() {
        addSubview(replyButton)
        replyButton.snp.makeConstraints { (make) in
            make.left.equalTo(likeCommentButton.snp.right)
                .offset(Dimension.shared.normalMargin)
            make.bottom.equalTo(likeCommentButton)
        }
    }
    
}

// MARK: - UICollectionViewDelegate

extension BaseCommentCollectionViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let url = comment.photos.map { $0.url }
        AppRouter.presentPopupImage(urls: url, selectedIndexPath: indexPath, productName: "")
    }
}

// MARK: - UICollectionViewDataSource

extension BaseCommentCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return comment.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ImageCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.setupData(comment.photos[indexPath.row])
        return cell
    }
}
