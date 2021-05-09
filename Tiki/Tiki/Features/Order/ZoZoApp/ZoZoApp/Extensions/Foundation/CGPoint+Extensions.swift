//
//  CGPoint+Extensions.swift
//  ZoZoApp
//
//  Created by LAP12852 on 9/14/19.
//  Copyright © 2019 MACOS. All rights reserved.
//
import CoreGraphics

public extension CGPoint {
    func bma_offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: self.x + dx, y: self.y + dy)
    }
}

extension CGPoint {
    func clamped(to rect: CGRect) -> CGPoint {
        return CGPoint(
            x: self.x.clamped(to: rect.minX...rect.maxX),
            y: self.y.clamped(to: rect.minY...rect.maxY)
        )
    }
}
