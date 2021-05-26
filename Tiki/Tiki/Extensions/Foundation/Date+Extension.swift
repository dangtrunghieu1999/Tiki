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
    
    enum FormatType: String {
        case full               = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
        case medium             = "EEEE, MMM d, yyyy"
        case ddMMyyyy           = "dd/MM/yyyy"
        case yyyyMMdd           = "yyyy-MM-dd"
        case yyyyMMddHHmmss     = "yyyy-MM-dd HH:mm:ss"
        case time12Hour         = "h:mm a"
        case time24Hour         = "HH:mm"
        case date_time12Hour    = "dd/MM/yyyy - h:mm a"
        case MMMMyyyy           = "MMMM yyyy"
        case ddMMMMyyyy         = "dd MMMM yyyy"
    }

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
    
    func toString(_ format: FormatType = .full, timeZone: TimeZone = .current) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = format.rawValue
        dateFormatter.timeZone = timeZone
        let strDate = dateFormatter.string(from: self)
        return strDate
    }
}
