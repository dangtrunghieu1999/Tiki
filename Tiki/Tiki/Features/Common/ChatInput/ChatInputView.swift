//
//  ChatInputView.swift
//  ZoZoApp
//
//  Created by LAP12852 on 9/14/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

protocol ChatInputViewDelegate: class {
    func didSelectSendMessage(view: ChatInputView, message: String?)
}

class ChatInputView: BaseView {
    
    // MARK: - Support Types
    
    enum KeyBoardType: Int {
        case text       = 0
        case sticker    = 1
        case photo      = 2
    }

    // MARK: - Variables
    
    weak var delegate: ChatInputViewDelegate?
    
    private var keyboardType: KeyBoardType = .text
    
    // MARK: - UI Elements
    
    private lazy var inputStickerContainerView: InputContainerView = {
        let view = InputContainerView()
        view.allowsSelfSizing = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentHeight = UIScreen.main.defaultPortraitKeyboardHeight
        return view
    }()
    
    private lazy var stickerButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.emoji, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(touchInStickerButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var inputTextView: ExpandableTextView = {
       let textView = ExpandableTextView()
        textView.backgroundColor = UIColor.lightBackground
        textView.layer.cornerRadius = 18
        textView.layer.masksToBounds = true
        textView.setTextPlaceholderColor(UIColor.placeholder)
        textView.placeholderText = TextManager.inputComment.localized()
        let font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        textView.setTextPlaceholderFont(font)
        textView.font = font
        textView.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnInputTextView))
        textView.addGestureRecognizer(tapGesture)
        return textView
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.sendMessageDisable, for: .normal)
        button.addTarget(self, action: #selector(touchInSendMessageButton), for: .touchUpInside)
        return button
    }()

    // MARK: - LifeCycles
    
    override func initialize() {
        layoutEmojiButton()
        layoutSendButton()
        layoutInputTextView()
    }
    
    // MARK: - Public Methods
    
    func clearInputText() {
        inputTextView.text = ""
        checkEnableSendButton()
    }
    
    func beginEditing() {
        inputTextView.becomeFirstResponder()
    }
    
    // MARK: - UI Actions
    
    @objc private func touchInSendMessageButton() {
        delegate?.didSelectSendMessage(view: self, message: inputTextView.text)
    }
    
    @objc private func touchInStickerButton() {
        keyboardType = .sticker
        let stickerView = StickerView()
        inputStickerContainerView.contentView = stickerView
        inputTextView.inputView = inputStickerContainerView
        
        if inputTextView.isFirstResponder {
            inputTextView.reloadInputViews()
        } else {
            inputTextView.becomeFirstResponder()
        }
    }
    
    @objc private func tapOnInputTextView() {
        keyboardType = .text
        inputTextView.inputView = nil
        
        if inputTextView.isFirstResponder {
            inputTextView.reloadInputViews()
        } else {
            inputTextView.becomeFirstResponder()
        }
    }
    
    // MARK: - Helper Methods
    
    fileprivate func checkEnableSendButton() {
        if inputTextView.text == "" {
            sendButton.isUserInteractionEnabled = false
            sendButton.setImage(ImageManager.sendMessageDisable, for: .normal)
        } else {
            sendButton.isUserInteractionEnabled = true
            sendButton.setImage(ImageManager.sendMessageEnable, for: .normal)
        }
    }
    
    // MARK: - Layout
    
    private func layoutEmojiButton() {
        addSubview(stickerButton)
        stickerButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(28)
            make.left.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
    
    private func layoutInputTextView() {
        addSubview(inputTextView)
        inputTextView.snp.makeConstraints { (make) in
            make.left.equalTo(stickerButton.snp.right).offset(6)
            make.right.equalTo(sendButton.snp.left).offset(-12)
            make.bottom.equalToSuperview().offset(-12)
            make.top.equalToSuperview().offset(12)
        }
    }
    
    private func layoutSendButton() {
        addSubview(sendButton)
        sendButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(28)
            make.bottom.equalToSuperview().offset(-16)
            make.right.equalToSuperview().offset(-12)
        }
    }

}

// MARK: - UITextViewDelegate

extension ChatInputView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        checkEnableSendButton()
    }
}
