//
//  ReplyCommentView.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 4/20/21.
//

import UIKit
import HCSStarRatingView

protocol ReplyCommentViewDelegate: class {
    func didSelectClose(_ view: ReplyCommentView)
}

class ReplyCommentView: BaseView {
    
    // MARK: - Helper types
    
    enum ReplyCommentType: Int {
        case rating         = 0
        case replyComment   = 1
    }

    // MARK: - Variables
    
    weak var delegate: ReplyCommentViewDelegate?
    private (set) var type: ReplyCommentType = .rating
    
    var ratingValue: CGFloat {
        get {
            return ratingView.value
        }
        set {
            ratingView.value = 0
        }
    }
    
    // MARK: - UI Elements
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.ratingForProduct.localized()
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        return label
    }()
    
    private let ratingView: HCSStarRatingView = {
        let ratingView = HCSStarRatingView()
        ratingView.allowsHalfStars = false
        ratingView.emptyStarColor = UIColor.lightBackground
        ratingView.tintColor = UIColor.accentColor
        return ratingView
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightBodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        label.isHidden = true
        return label
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.closeIconWhite?.withRenderingMode(.alwaysTemplate),
                        for: .normal)
        button.tintColor = UIColor.lightGray
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(touchInCloseButton), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    private let verticalView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.background
        return view
    }()
    
    // MARK: - LifeCycles
    
    override func initialize() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnSuperView))
        addGestureRecognizer(tapGesture)
        
        makeShadowAndCorner()
        layoutVerticalView()
        layoutTitleLabel()
        layoutRatingView()
        layoutMessageLabel()
        layoutCloseButton()
    }
    
    // MARK: - Public Methods
    
    func replyForComment(_ comment: Comment) {
        type = .replyComment
        titleLabel.text = "\(TextManager.replyComment.localized()) \(comment.fullName)"
        messageLabel.text = comment.content
        updateReplyCommentType(.replyComment)
    }
    
    func updateReplyCommentType(_ type: ReplyCommentType) {
        self.type = type
        if type == .rating {
            titleLabel.text         = TextManager.ratingForProduct.localized()
            ratingView.isHidden     = false
            messageLabel.isHidden   = true
            closeButton.isHidden    = true
        } else if type == .replyComment {
            ratingView.isHidden     = true
            messageLabel.isHidden   = false
            closeButton.isHidden    = false
        }
    }
    
    // MARK: - UI Actions
    
    @objc private func touchInCloseButton() {
        delegate?.didSelectClose(self)
    }
    
    @objc private func tapOnSuperView() {}
    
    // MARK: - Helper Methods
    
    // MARK: - Layout
    
    private func layoutVerticalView() {
        addSubview(verticalView)
        verticalView.snp.makeConstraints { (make) in
            make.width.equalTo(2)
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(4)
            make.bottom.equalToSuperview().offset(-4)
        }
    }
    
    private func layoutTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(verticalView.snp.right).offset(8)
            make.right.equalToSuperview().offset(-80)
            make.top.equalToSuperview().offset(6)
        }
    }

    private func layoutRatingView() {
        addSubview(ratingView)
        ratingView.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.width.equalTo(200)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.height.equalTo(24)
        }
    }
    
    private func layoutMessageLabel() {
        addSubview(messageLabel)
        messageLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
    }
    
    private func layoutCloseButton() {
        addSubview(closeButton)
        closeButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
            make.width.height.equalTo(15)
        }
    }
    
}
