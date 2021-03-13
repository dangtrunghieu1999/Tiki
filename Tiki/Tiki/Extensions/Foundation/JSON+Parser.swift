//
//  JSON+Parser.swift
//  ZoZoApp
//
//  Created by MACOS on 7/3/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import Foundation
import SwiftyJSON

extension JSON {
    var date: Date? {
        return stringValue.toDate(with: .fullDateServerFormat)
    }
    
    var dateValue: Date {
        return date ?? Date()
    }
}
