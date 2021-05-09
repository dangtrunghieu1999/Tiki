//
//  String+Extension.swift
//  Ecom
//
//  Created by MACOS on 3/31/19.
//  Copyright © 2019 Ecom. All rights reserved.
//

import Foundation

extension String {
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var isPhoneNumber: Bool {
        if count < 8 {
            return false
        }
        
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    func toDate(with format: DateFormat) -> Date {
        let dateFormater = DateFormatter()
        dateFormater.locale = Locale.current
        dateFormater.dateFormat = format.rawValue
        return dateFormater.date(from: self) ?? Date()
    }
    
    func toInt() -> Int {
        return Int(self) ?? 0
    }
    
    func toDouble() -> Double {
        return Double(self) ?? 0
    }
    
    func nsRange(from range: Range<String.Index>) -> NSRange {
        let from = range.lowerBound.samePosition(in: utf16)
        let to = range.upperBound.samePosition(in: utf16)
        return NSRange(location: utf16.distance(from: utf16.startIndex, to: from!),
                       length: utf16.distance(from: from!, to: to!))
    }
    
    var isUserName: Bool {
        if self != "" && (self.isValidEmail || self.isPhoneNumber) {
            return true
        } else {
            return false
        }
    }
    
    var url: URL? {
        return URL(string: self)
    }
    
    func stringRemoveDiacritics() -> String {
        var result = self.folding(options: .diacriticInsensitive, locale: NSLocale.current)
        result = result.replacingOccurrences(of: "đ", with: "d")
        result = result.replacingOccurrences(of: "Đ", with: "D")
        return result
    }
    
    func makeAliasCode() -> String {
        let components = self.components(separatedBy: .whitespacesAndNewlines)
        var result = components.filter { !$0.isEmpty }.joined(separator: " ")
        
        if result.first != nil && result.first == " " {
            result.removeFirst()
        }
        
        if result.last != nil && result.last == " " {
            result.removeLast()
        }
        
        result = result.replacingOccurrences(of: " ", with: "-", options: .literal, range: nil)
        result = result.uppercased()
        result = result.stringRemoveDiacritics()
        
        return result
    }
    
    func addImageDomainIfNeeded() -> String {
        guard !isValidURL else { return self }
        let baseURL = AppConfig.imageDomain as NSString
        return baseURL.appendingPathComponent(self)
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [NSAttributedString.Key.font: font],
                                            context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [NSAttributedString.Key.font: font],
                                            context: nil)
        
        return ceil(boundingBox.width)
    }
    
    var isValidURL: Bool {
        if self.contains("http:/") || self.contains("https:/") {
            return true
        }
        
        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector?.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
    
    var normalizeSearchText: String {
        return self.lowercased().removeDiacritics()
    }
    
    func removeDiacritics() -> String {
        var result = self.folding(options: .diacriticInsensitive, locale: Locale.current)
        result = result.replacingOccurrences(of: "đ", with: "d")
        result = result.replacingOccurrences(of: "Đ", with: "D")
        return result
    }
}
