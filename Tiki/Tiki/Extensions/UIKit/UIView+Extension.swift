//
//  UIView+Extension.swift
//  Ecom
//
//  Created by MACOS on 3/22/19.
//  Copyright © 2019 Minh Tri. All rights reserved.
//

import UIKit

extension UIView {
    func setDefaultBackgroundColor() {
        backgroundColor = UIColor.white
    }
    
    func makeShadow() {
        layer.shadowOffset  = CGSize(width: 2, height: 2)
        layer.shadowRadius  = 0
        layer.shadowOpacity = 0.2
        layer.shadowColor   = UIColor.black.cgColor
    }
    
    func addShadow(offSet: CGSize = CGSize(width: 2, height: 2),
                   radius: CGFloat = 5,
                   opactity: Float = 0.2,
                   shadowColor: UIColor = UIColor.black) {
        layer.shadowOffset  = offSet
        layer.shadowRadius  = radius
        layer.shadowOpacity = opactity
        layer.shadowColor   = shadowColor.cgColor
    }
    
    func makeShadowAndCorner(cornerRadius: CGFloat = 16,
                             shadowRadius: CGFloat = 3,
                             shadowColor: CGColor = UIColor.black.withAlphaComponent(0.5).cgColor,
                             shadowOffset: CGSize = CGSize(width: 1, height: 1),
                             shadowOpacity: Float = 0.5) {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
        layer.shadowRadius = shadowRadius
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
    }
    
    
    func makeGradient(_ gradientPoint: GradientPoint = .bottomTop,
                      _ cornerRadius: CGFloat = 0,
                      _ fromColor: UIColor,
                      _ toColor: UIColor,
                      _ frame: CGRect) {
        let gradientType = gradientPoint.draw()
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame
        gradientLayer.colors = [fromColor.cgColor, toColor.cgColor]
        gradientLayer.startPoint = gradientType.x
        gradientLayer.endPoint = gradientType.y
        gradientLayer.cornerRadius = cornerRadius
        self.layer.addSublayer(gradientLayer)
    }
    
    public func roundCorners(cornerRadius: Double,
                             position: UIRectCorner = [.topLeft, .topRight]) {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() +  0.001) {
            let path = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: position,
                                    cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = path.cgPath
            self.layer.mask = maskLayer
        }
    }
    
    public func clearBackground() {
        self.backgroundColor = UIColor.clear
    }
    
    public func blurBackground() {
        let blurEffect = UIBlurEffect(style: .light)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = bounds
        self.addSubview(blurredEffectView)
    }
    
    func addTopBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: borderWidth)
        addSubview(border)
    }

    func addBottomBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        border.frame = CGRect(x: 0, y: frame.size.height - borderWidth, width: frame.size.width, height: borderWidth)
        addSubview(border)
    }

    func addLeftBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.frame = CGRect(x: 0, y: 0, width: borderWidth, height: frame.size.height)
        border.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
        addSubview(border)
    }

    func addRightBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
        border.frame = CGRect(x: frame.size.width - borderWidth, y: 0, width: borderWidth, height: frame.size.height)
        addSubview(border)
    }
    
}
