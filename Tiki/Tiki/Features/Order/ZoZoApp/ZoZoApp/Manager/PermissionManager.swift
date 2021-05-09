//
//  PermissionManager.swift
//  ZoZoApp
//
//  Created by MACOS on 6/15/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit
import Photos

class PermissionManager {

    static let shared = PermissionManager()
    
    private init() {}
    
    var isRetrictAccessPhotos: Bool {
        let status = PHPhotoLibrary.authorizationStatus()
        return (status == .restricted || status == .denied)
    }
    
    var isRetrictAccessCamera: Bool {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        return (status == .restricted || status == .denied)
    }
    
}
