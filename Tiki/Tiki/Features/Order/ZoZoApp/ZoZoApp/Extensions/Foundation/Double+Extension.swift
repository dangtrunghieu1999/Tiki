//
//  Double+Extension.swift
//  Ecom
//
//  Created by MACOS on 3/24/19.
//  Copyright © 2019 Minh Tri. All rights reserved.
//

import Foundation

extension Double {
    var currencyFormat: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return (formatter.string(from: NSNumber(value: self)) ?? "") + "đ"
    }
}
