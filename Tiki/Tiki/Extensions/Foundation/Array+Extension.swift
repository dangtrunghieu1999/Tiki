//
//  Array+Extension.swift
//  Ecom
//
//  Created by MACOS on 3/24/19.
//  Copyright © 2019 Minh Tri. All rights reserved.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        if index < count && index >= 0 {
            return self[index]
        } else {
            return nil
        }
    }
}
