//
//  Date+Extension.swift
//  Ecom
//
//  Created by Minh Tri on 3/31/19.
//  Copyright © 2019 Ecom. All rights reserved.
//

import UIKit
import Localize_Swift

extension Date {
    var serverDateFormat: String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        return dateFormater.string(from: self)
    }
    
    func desciption(by format: DateFormat) -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = format.rawValue
        return dateFormater.string(from: self)
    }
    
    var pretyDesciption: String {
        let dateFormatter       = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none
        dateFormatter.locale    = Locale(identifier: "vi_VN")
        return dateFormatter.string(from: self)
    }
}
