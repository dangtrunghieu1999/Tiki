//
//  UIApplication+Exension.swift
//  Ecom
//
//  Created by MACOS on 4/6/19.
//  Copyright © 2019 Ecom. All rights reserved.
//

import UIKit

public extension UIApplication {
    var topSafeAreaInsets: CGFloat {
        if #available(iOS 11, *) {
            let window = UIApplication.shared.keyWindow
            return window?.safeAreaInsets.top ?? 0
        }
        return 20
    }
    
    var bottomSafeAreaInsets: CGFloat {
        if #available(iOS 11, *) {
            let window = UIApplication.shared.keyWindow
            return window?.safeAreaInsets.bottom ?? 0
        }
        return 0
    }
}

