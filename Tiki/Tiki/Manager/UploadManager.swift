//
//  UploadManager.swift
//  ZoZoApp
//
//  Created by LAP12852 on 10/20/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class UploadManager: NSObject {
    
    // MARK: - Variables
    
    static var shared = UploadManager()
    
    private override init() {}
    
    // MARK: Public methods
    
    func uploadImages(_ images: [UIImage]) {
        let group = DispatchGroup()
        DispatchQueue.global(qos: .userInteractive).async {
            for image in images {
                group.enter()
                let endPoint = CommonEndPoint.uploadPhoto(image: image)
                APIService.request(endPoint: endPoint, onSuccess: { (apiResponse) in
                    group.leave()
                }, onFailure: { (apiEror) in
                    group.leave()
                }, onRequestFail: {
                    group.leave()
                })
            }
            
            let result = group.wait(timeout: .now() + 10)
            if result == .success {
                
            } else {
                
            }
        }
    }
    
}
