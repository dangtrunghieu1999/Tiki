//
//  BaseUIView.swift
//  Ecom
//
//  Created by MACOS on 4/19/19.
//  Copyright © 2019 Ecom. All rights reserved.
//

import UIKit

open class BaseView: UIView {
    override public init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initialize() {}
}
