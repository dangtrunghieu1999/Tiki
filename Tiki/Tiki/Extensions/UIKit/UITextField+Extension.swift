//
//  UITextField+Extension.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 5/9/21.
//

import UIKit

extension UITextField {
    
    func fontSizePlaceholder(text: String, size: CGFloat) {
        attributedPlaceholder = NSAttributedString(string: text, attributes: [
            .foregroundColor: UIColor.lightBodyText,
            .font: UIFont.systemFont(ofSize: size)
        ])
    }
    
    func addBottomBorder(_ color: UIColor){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
        bottomLine.backgroundColor = color.cgColor
        borderStyle = .none
        layer.addSublayer(bottomLine)
    }
}
