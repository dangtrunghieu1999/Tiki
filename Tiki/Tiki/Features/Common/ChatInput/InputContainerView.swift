//
//  InputContainerView.swift
//  ZoZoApp
//
//  Created by LAP12852 on 10/1/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

open class InputContainerView: UIInputView {
    
    public var contentHeight: CGFloat = 0 {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    public var contentView: UIView? {
        willSet {
            contentView?.removeFromSuperview()
        }
        didSet {
            if let contentView = self.contentView {
                contentView.frame = bounds
                addSubview(contentView)
                setNeedsLayout()
            }
        }
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        contentView?.frame = bounds
    }
    
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: contentHeight)
    }
    
}
