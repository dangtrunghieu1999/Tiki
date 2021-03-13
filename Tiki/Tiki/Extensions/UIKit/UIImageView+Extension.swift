//
//  UIImageView+Extension.swift
//  ZoZoApp
//
//  Created by MACOS on 7/20/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

extension UIImageView {
    func loadImage(by urlString: String, defaultImage: UIImage? = ImageManager.imagePlaceHolder) {
        sd_setImage(with: urlString.addImageDomainIfNeeded().url,
                    placeholderImage: defaultImage,
                    options: .retryFailed,
                    completed: nil)
    }
}
