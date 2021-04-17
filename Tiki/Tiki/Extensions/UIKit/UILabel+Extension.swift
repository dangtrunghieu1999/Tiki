//
//  UILabel+Extension.swift
//  Ecom
//
//  Created by MACOS on 3/26/19.
//  Copyright © 2019 Minh Tri. All rights reserved.
//

import UIKit

extension UILabel {
    func loadHTML(width text: String) {
        let modifiedFont = NSString(format: "<span style=\"font-size: 12pt\">%@</span>", text) as String
        guard let data = modifiedFont.data(using: String.Encoding.unicode, allowLossyConversion: true) else {
            return
        }
        let options: [NSAttributedString.DocumentReadingOptionKey : Any]
            = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
               NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue]
        
        do {
            let attrStr =  try NSAttributedString.init(data: data,
                                                       options: options,
                                                       documentAttributes: nil)
            
            let combination = NSMutableAttributedString()
            combination.append(attrStr)
            self.attributedText = combination
        } catch {
            print("error load html")
        }
    }
    
    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {

        guard let labelText = self.text else { return }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple

        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }

        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))


        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))

        self.attributedText = attributedString
    }

}

