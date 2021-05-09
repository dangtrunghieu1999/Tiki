//
//  Int+Extension.swift
//  Ecom
//
//  Created by MACOS on 3/23/19.
//  Copyright © 2019 Minh Tri. All rights reserved.
//

import Foundation

extension Int {
    var currencyFormat: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return (formatter.string(from: NSNumber(value: self)) ?? "") + "đ"
    }
}
