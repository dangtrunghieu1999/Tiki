//
//  DeliveryInformation.swift
//  ZoZoApp
//
//  Created by LAP12852 on 8/25/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class DeliveryInformation: NSObject, NSCoding {

    var fullName        = ""
    var phoneNumber     = ""
    var address         = ""
    var province        : Province?
    var district        : District?
    var ward            : Ward?
    
    var isValidInfo: Bool {
        if fullName != ""
            && phoneNumber != "" && phoneNumber.isPhoneNumber
            && address != ""
            && province != nil
            && district != nil
            && ward != nil
        {
            return true
        } else {
            return false
        }
    }
    
    override init() {
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(fullName, forKey: "fullName")
        aCoder.encode(phoneNumber, forKey: "phoneNumber")
        aCoder.encode(address, forKey: "address")
        aCoder.encode(province, forKey: "province")
        aCoder.encode(district, forKey: "district")
        aCoder.encode(ward, forKey: "ward")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fullName        = aDecoder.decodeObject(forKey: "fullName") as? String ?? ""
        phoneNumber     = aDecoder.decodeObject(forKey: "phoneNumber") as? String ?? ""
        address         = aDecoder.decodeObject(forKey: "address") as? String ?? ""
        province        = aDecoder.decodeObject(forKey: "province") as? Province
        district        = aDecoder.decodeObject(forKey: "district") as? District
        ward            = aDecoder.decodeObject(forKey: "ward") as? Ward
    }
    
}
