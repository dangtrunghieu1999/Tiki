//
//  Ultilities.swift
//  ZoZoApp
//
//  Created by LAP12852 on 9/2/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class Ultilities: NSObject {
    public static func randomStringKey() -> String {
        return UUID().uuidString
    }
}
