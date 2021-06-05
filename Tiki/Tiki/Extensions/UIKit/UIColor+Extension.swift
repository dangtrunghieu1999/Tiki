//
//  UIColorExtension.swift
//  Ecom
//
//  Created by Minh Tri on 3/3/19.
//  Copyright © 2019 Minh Tri. All rights reserved.
//

import UIKit

// MARK: - App Color
extension UIColor {
    class var background: UIColor {
        return UIColor(hex: "#C8102E")
    }
    
    class var thirdColor: UIColor {
        return UIColor(hex: "#0D5CB6")
    }
    
    class var superLightColor: UIColor {
        return UIColor(hex: "#F3F3F3")
    }
    
    class var subTitle: UIColor {
        return UIColor(hex: "#13B7FF")
    }
    
    class var tabbarIcon: UIColor {
        return UIColor(hex: "#157CDB")
    }
    
    class var lightBackground: UIColor {
        return UIColor(hex: "#EFEFEF")
    }
    
    class var primary: UIColor {
        return UIColor(hex: "#C8102E")
    }
    
    class var second: UIColor {
        return UIColor(hex: "#276DBD")
    }
    
    class var titleText: UIColor {
        return UIColor(hex: "#333333")
    }
    
    class var bodyText: UIColor {
        return UIColor(hex: "#3B3A3A")
    }
    
    class var lightBodyText: UIColor {
        return UIColor(hex: "#787878")
    }
    
    class var lightSeparator: UIColor {
        return UIColor(hex: "#E9E9E9")
    }
    
    class var separator: UIColor {
        return UIColor(hex: "#EEEEEE")
    }
    
    class var grayBoder: UIColor {
        return UIColor(hex: "#919191")
    }

    class var accentColor: UIColor {
        return UIColor(hex: "#FF6639")
    }
    
    class var ratingColor: UIColor {
        return UIColor(hex: "#FDD835")
    }
    
    class var darkAccentColor: UIColor {
        return UIColor(hex: "#DA0707")
    }

    class var tabbarTitle: UIColor {
        return UIColor(hex: "#D4D0D0")
    }
    
    class var lightDisable: UIColor {
        return UIColor(hex: "#EAEAEA")
    }
    
    class var disable: UIColor {
        return UIColor(hex: "#D8D8D8")
    }

    class var tableBackground: UIColor {
        return UIColor(hex: "#F4F4F4")
    }
    
    class var buttonBackgroundActive: UIColor {
        return UIColor(hex: "#1975a3")
    }
    
    class var link: UIColor {
        return UIColor(hex: "#1da9fe")
    }
    
    class var darkBackgroundColor: UIColor {
        return UIColor(hex: "#888888")
    }
    
    class var placeholder: UIColor {
        return UIColor.lightBodyText.withAlphaComponent(0.5)
    }
    
    class var shimmerBGColor: UIColor {
        return UIColor.lightGray.withAlphaComponent(0.35)
    }
    
    class var scrollMenu: UIColor {
        return UIColor(hex: "#F5F5F5")
    }
    
    class var messageBackground: UIColor {
        return UIColor(hex: "EFF1F3")
    }
    
    class var boderColor: UIColor {
        return UIColor(hex: "E0E0E5")
    }
    
    class var secondary1: UIColor {
        return UIColor(hex: "#313131")
    }
    
    class var greenColor: UIColor {
        return UIColor(hex: "#009900")
    }
    
    class var lightGreenColor: UIColor {
        return UIColor(hex: "#EFF8EF")
    }
}

// MARK: - Support Method
extension UIColor {
    convenience init(hex: String) {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            self.init(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.0)
            return
        }
        
        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: 1.0)
    }
}

