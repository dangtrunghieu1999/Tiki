//
//  UIImage+Extension.swift
//  ZoZoApp
//
//  Created by MACOS on 6/13/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

extension UIImage {
    
    /// Resize image when width or height > 1.000px
    /// Use this method when pick image from library
    func normalizeImage() -> UIImage? {
        let size = self.size
        let widthRatio  = size.width / 1000
        let heightRatio = size.height / 1000
        
        guard widthRatio > 1 || heightRatio > 1 else { return self }
        var newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width / widthRatio, height: size.height / widthRatio)
        } else {
            newSize = CGSize(width: size.width / heightRatio,  height: size.height / heightRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func resizeImage(targetSize: CGSize) -> UIImage? {
        let size = self.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    var base64ImageString: String? {
        return pngData()?.base64EncodedString()
    }
    
}

