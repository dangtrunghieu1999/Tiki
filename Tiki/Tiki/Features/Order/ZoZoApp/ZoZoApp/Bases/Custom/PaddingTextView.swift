//
//  PaddingTextView.swift
//  ZoZoApp
//
//  Created by MACOS on 6/9/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

open class PaddingTextView: UITextView {
    var padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        textContainerInset = padding
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        textContainerInset = padding
    }
    
}
