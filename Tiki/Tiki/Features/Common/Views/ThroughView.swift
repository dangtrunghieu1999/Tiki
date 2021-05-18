//
//  ThroughView.swift
//  Tiki
//
//  Created by Bee_MacPro on 18/05/2021.
//

import UIKit

class ThroughView: BaseView {
    
    // MARK: - Define Variables
    var isEnable: Bool = true
    
    // MARK: - Override Methods
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subview in self.subviews {
            let convertPoint = self.convert(point, to: subview)
            if subview.point(inside: convertPoint, with: event) {
                return true
            }
        }
        
        return !isEnable
    }
}

class ThroughAllView: BaseView {
    
    // MARK: - Define Variables
    var isEnable: Bool = true
    
    // MARK: - Override Methods
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return !isEnable
    }
}

