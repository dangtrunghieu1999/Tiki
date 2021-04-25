//
//  DeliveryInformation.swift
//  ZoZoApp
//
//  Created by LAP12852 on 8/25/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class DeliveryInformation: NSObject, NSCoding {
    var email           = ""
    var fullName        = ""
    var phoneNumber     = ""
    var address         = ""
    var province        : Province?
    var district        : District?
    var ward            : Ward?
    var apartmentNumber = ""
    
    var isValidInfo: Bool {
        if email != "" && email.isValidEmail
            && fullName != ""
            && phoneNumber != "" && phoneNumber.isPhoneNumber
            && address != ""
            && province != nil
            && district != nil
            && ward != nil
            && apartmentNumber != "" && apartmentNumber != TextManager.apartmentNumberStreet {
            return true
        } else {
            return false
        }
    }
    
    override init() {
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(email, forKey: "email")
        aCoder.encode(fullName, forKey: "fullName")
        aCoder.encode(phoneNumber, forKey: "phoneNumber")
        aCoder.encode(address, forKey: "address")
        aCoder.encode(province, forKey: "province")
        aCoder.encode(district, forKey: "district")
        aCoder.encode(ward, forKey: "ward")
        aCoder.encode(apartmentNumber, forKey: "apartmentNumber")
    }
    
    required init?(coder aDecoder: NSCoder) {
        email           = aDecoder.decodeObject(forKey: "email") as? String ?? ""
        fullName        = aDecoder.decodeObject(forKey: "fullName") as? String ?? ""
        phoneNumber     = aDecoder.decodeObject(forKey: "phoneNumber") as? String ?? ""
        phoneNumber     = aDecoder.decodeObject(forKey: "phoneNumber") as? String ?? ""
        address         = aDecoder.decodeObject(forKey: "address") as? String ?? ""
        apartmentNumber = aDecoder.decodeObject(forKey: "apartmentNumber") as? String ?? ""
        province        = aDecoder.decodeObject(forKey: "province") as? Province
        district        = aDecoder.decodeObject(forKey: "district") as? District
        ward            = aDecoder.decodeObject(forKey: "ward") as? Ward
    }
    
}
