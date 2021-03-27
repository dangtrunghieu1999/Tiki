//
//  Dimension.swift
//  Ecom
//
//  Created by MACOS on 3/22/19.
//  Copyright © 2019 Minh Tri. All rights reserved.
//

import UIKit

let dimension = Dimension.shared

class Dimension {
    
    class var shared: Dimension {
        struct Static {
            static var instance = Dimension()
        }
        return Static.instance
    }
    
    var widthScreen:  CGFloat = 1.0
    var heightScreen: CGFloat = 1.0
    var widthScale:   CGFloat = 1.0
    var heightScale:  CGFloat = 1.0
    
    // MARK: - Initialize
    private init() {
        self.widthScreen  = UIScreen.main.bounds.width
        self.heightScreen = UIScreen.main.bounds.height
    }
    
    // MARK: - Spacing
    var smallMargin: CGFloat {
        return 4 * self.widthScale
    }
    
    var mediumMargin: CGFloat {
        return 8 * self.widthScale
    }
    
    var mediumMargin_12: CGFloat {
        return 12 * self.widthScale
    }
    
    var normalMargin: CGFloat {
        return 16 * self.widthScale
    }
    
    var largeMargin: CGFloat {
        return 24 * self.widthScale
    }

    var largeMargin_32: CGFloat {
        return 32 * self.widthScale
    }
   
    var largeMargin_38: CGFloat {
        return 42 * self.widthScale
    }
    
    var largeMargin_42: CGFloat {
        return 42 * self.widthScale
    }
    
    var largeMargin_56: CGFloat {
        return 56 * self.widthScale
    }
   
    var largeMargin_60: CGFloat {
        return 60 * self.widthScale
    }
    
    var largeMargin_90: CGFloat {
        return 90 * self.widthScale
    }
   
    var largeMargin_120: CGFloat {
        return 120 * self.widthScale
    }
    
    // MARK: - Button
    
    var largeHeightButton: CGFloat {
        return 50 * self.widthScale
    }
    
    var defaultHeightButton: CGFloat {
        return 42 * self.widthScale
    }
    
    var smalltHeightButton: CGFloat {
        return 32 * self.widthScale
    }
    
    var largeWidthButton: CGFloat {
        return 291 * self.widthScale
    }
    
    var smallWidthButton: CGFloat {
        return 120 * self.widthScale
    }
    
    var supperSmallWidthButton: CGFloat {
        return 100 * self.widthScale
    }
    
    var mediumWidthButton: CGFloat {
        return 195 * self.widthScale
    }
    
    //MARK: - Alpha
    
    var smallAlpha: CGFloat {
        return 0.25
    }
    
    var mediumAlpha: CGFloat {
        return 0.5
    }
    
    var largeAlpha: CGFloat {
        return 0.75
    }
    
    // MARK: - Line height
    
    var smallLineHeight: CGFloat {
        return 1 * widthScale
    }
    
    var mediumLineHeight: CGFloat {
        return 2 * widthScale
    }
    
    var normalLineHeight: CGFloat {
        return 3 * widthScale
    }
    
    var largeLineHeight: CGFloat {
        return 4 * widthScale
    }
    
    // MARK: - TextField
    
    var defaultHeightTextField: CGFloat {
        return 40 * heightScale
    }
    
    var cornerRadiusSmall: CGFloat {
        return 5 * self.widthScale
    }
    
    var conerRadiusMedium: CGFloat {
        return 10 * self.widthScale
    }
    
}
