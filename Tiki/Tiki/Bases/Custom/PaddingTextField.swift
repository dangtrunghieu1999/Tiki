//
//  PaddingTextField.swift
//  Ecom
//
//  Created by MACOS on 3/29/19.
//  Copyright © 2019 Minh Tri. All rights reserved.
//

import UIKit

protocol PaddingTextFieldDelegate {
    func didTouchInRightView()
}

open class PaddingTextField: UITextField {
    
    var paddingViewDelegate: PaddingTextFieldDelegate?
    var padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    var rightImage: UIImage? {
        didSet {
            setupViewImagesIfNeeded()
        }
    }
    var leftImage: UIImage? {
        didSet {
            setupViewImagesIfNeeded()
        }
    }
    lazy var rightImageFrame = CGRect(x: -10, y: 2, width: 16, height: 16)
    lazy var leftImageFrame: CGRect = CGRect(x: 10, y: 2, width: 16, height: 16)
    
    private var isAddRightImage = false
    private var isAddLeftImage = false
    private let containerViewWidth: CGFloat = 20
    
    private var correctPadding: UIEdgeInsets {
        var leftPadding = padding.left
        var rightPadding = padding.right
        if leftImage != nil {
            leftPadding += containerViewWidth
        }
        if rightImage != nil {
            rightPadding += containerViewWidth
        }
        
        return UIEdgeInsets(top: padding.top,
                            left: leftPadding,
                            bottom: padding.bottom,
                            right: rightPadding)
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: correctPadding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: correctPadding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: correctPadding)
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        setupViewImagesIfNeeded()
    }
    
    @objc private func touchInRightView() {
        paddingViewDelegate?.didTouchInRightView()
    }
    
    func removeRightView() {
        rightView = nil
        rightImage = nil
        isAddRightImage = false
    }
    
    private func setupViewImagesIfNeeded() {
        if let leftImage = leftImage, !isAddLeftImage {
            leftViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(frame: leftImageFrame)
            imageView.image = leftImage
            imageView.contentMode = .scaleAspectFit
            let view = UIView(frame: CGRect(x: 0, y: 0, width: containerViewWidth, height: containerViewWidth))
            view.addSubview(imageView)
            leftView = view
            isAddLeftImage = true
        }
        
        if let rightImage = rightImage, !isAddRightImage {
            rightViewMode = UITextField.ViewMode.always
            let view = UIView(frame: CGRect(x: 0, y: 0, width: containerViewWidth, height: containerViewWidth))
            let imageView = UIImageView(image: rightImage)
            imageView.frame = rightImageFrame
            imageView.contentMode = .scaleAspectFit
            imageView.image = rightImage
            view.addSubview(imageView)
            rightView = view
            isAddRightImage = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchInRightView))
            view.addGestureRecognizer(tapGesture)
            
        }
    }
    
}

extension UITextField {
    
    func fontSizePlaceholder(text: String, size: CGFloat) {
        attributedPlaceholder = NSAttributedString(string: text, attributes: [
            .foregroundColor: UIColor.lightBodyText,
            .font: UIFont.systemFont(ofSize: size)
        ])
    }
}
