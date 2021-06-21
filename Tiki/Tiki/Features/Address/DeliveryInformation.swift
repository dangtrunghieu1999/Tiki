//
//  DeliveryInformation.swift
//  ZoZoApp
//
//  Created by LAP12852 on 8/25/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit
import SwiftyJSON

class DeliveryInformation: NSObject, NSCoding, JSONParsable {
    
    var fullName        = ""
    var phoneNumber     = ""
    var address         = ""
    var province        : Province?
    var district        : District?
    var ward            : Ward?
    var info            = ""
    var recive          = ""
    
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
    
    required override init() {
        super.init()
    }
    
    required init(json: JSON) {
        self.fullName = json["fullName"].stringValue
        self.phoneNumber = json["phoneNumber"].stringValue
        self.address  = json["address"].stringValue
        self.province = Province(json: json["province"])
        self.district = District(json: json["district"])
        self.ward     = Ward(json: json["ward"])
        self.info     = fullName + " - " + phoneNumber
        self.recive   =
            "\(address), \(ward?.name ?? ""), \(district?.name ?? ""), \(province?.name ?? "")"
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
    
    func setLocationFinishSelect(_ deliveryInfo: DeliveryInformation) {
        self.province = deliveryInfo.province
        self.district = deliveryInfo.district
        self.ward     = deliveryInfo.ward
    }
    
}
