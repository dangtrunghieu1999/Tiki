//
//  Ultilities.swift
//  ZoZoApp
//
//  Created by LAP12852 on 9/2/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class Ultilities: NSObject {
    public static func randomStringKey() -> String {
        return UUID().uuidString
    }
    
    public static func lineSpacingLabel(title: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: title)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        paragraphStyle.minimumLineHeight = 5
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                      value:paragraphStyle,
                                      range:NSMakeRange(0, attributedString.length))
        return attributedString
    }
    
    public static func drawLineBetween(price: Double?) -> NSMutableAttributedString  {
        let myString = price?.currencyFormat ?? ""
        let attributeString = NSMutableAttributedString(string: myString)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                     value: 1,
                                     range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
}
