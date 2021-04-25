//
//  PHAsset.swift
//  ZoZoApp
//
//  Created by MACOS on 6/12/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import Photos

extension PHAsset {
    func getUIImage(completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            var img: UIImage?
            let manager = PHImageManager.default()
            let options = PHImageRequestOptions()
            options.version = .current
            options.isSynchronous = true
            manager.requestImageData(for: self, options: options) { data, _, _, _ in
                if let data = data {
                    img = UIImage(data: data)
                    DispatchQueue.main.async {
                        completion(img)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }
        }
        
    }
}
