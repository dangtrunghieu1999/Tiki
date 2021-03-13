//
//  UIFont+Extension.swift
//  Ecom
//
//  Created by Minh Tri on 3/27/19.
//  Copyright © 2019 Minh Tri. All rights reserved.
//

import UIKit

enum FontSize: CGFloat {
    case superHeadline  = 36.0
    case headline       = 24.0
    
    case title          = 20.0
    case body           = 18.0
    
    case h1             = 15.0
    case h2             = 13.0
    case h3             = 11.0
    
    case paragraph      = 8.0
}

extension UIFont {
    func width(for string: String, constrainedToHeight height: CGFloat) -> CGFloat {
        return NSString(string: string).boundingRect(with: CGSize(width: .greatestFiniteMagnitude, height: height),
                                                     options: .usesLineFragmentOrigin,
                                                     attributes: [NSAttributedString.Key.font: self],
                                                     context: nil).size.width
    }
}
