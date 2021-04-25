//
//  CGSize+Extension.swift
//  ZoZoApp
//
//  Created by LAP12852 on 9/5/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import Foundation

extension CGSize {
    mutating func offset(width: CGFloat, height: CGFloat) {
        self.width -= width
        self.height -= height
    }
    
    func offset(width: CGFloat, height: CGFloat) -> CGSize {
        return CGSize(width: self.width - width, height: self.height - height)
    }
}
