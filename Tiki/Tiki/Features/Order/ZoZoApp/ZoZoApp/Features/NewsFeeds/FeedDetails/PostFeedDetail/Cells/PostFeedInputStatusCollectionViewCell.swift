//
//  PostFeedInputStatusCollectionViewCell.swift
//  ZoZoApp
//
//  Created by LAP12852 on 9/21/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit
import IGListKit

class PostFeedInputStatusCollectionViewCell: BaseCollectionViewCell {
    
    fileprivate weak var model: PostFeedInputStatusModel?
    
    // MARK: - UI Elements
    
    private (set) lazy var inputTextView: ExpandableTextView = {
        let textView = ExpandableTextView()
        textView.limitHeight = false
        textView.setTextPlaceholderColor(UIColor.placeholder)
        textView.placeholderText = TextManager.whatDoYouThink.localized()
        let font = PostFeedInputStatusModel.statusFont
        textView.setTextPlaceholderFont(font)
        textView.font = font
        textView.delegate = self
        return textView
    }()
    
    // MARK: - LifeCycles
    
    override func initialize() {
        layoutInputTextView()
    }
    
    // MARK: - Public Methods
    
    override func bindViewModel(_ viewModel: Any) {
        if let model = viewModel as? PostFeedInputStatusModel {
            self.model = model
        }
    }
    
    // MARK: - Layout
    
    private func layoutInputTextView() {
        addSubview(inputTextView)
        inputTextView.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview()
            make.right.bottom.equalToSuperview()
        }
    }
    
}

// MARK: - UITextViewDelegate

extension PostFeedInputStatusCollectionViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let estimateHeight = model?.estimateTextHeight(textView.text),
            model?.needUpdateHeight(estimateHeight) ?? true {
            model?.textHeight = estimateHeight
            NotificationCenter.default.post(name: Notification.Name.updateFostFeedInputStatusCellSize, object: nil)
        }
    }
}
