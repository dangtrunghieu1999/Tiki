//
//  User.swift
//  Ecom
//
//  Created by Minh Tri on 3/28/19.
//  Copyright © 2019 Minh Tri. All rights reserved.
//

import UIKit
import SwiftyJSON

class User: NSObject, JSONParsable, NSCoding {
    
    var id              = ""
    var token           = ""
    var firstName       = ""
    var lastName        = ""
    var pictureURL      = ""
    var fullName        = ""
    var email           = ""
    var user: JSON?
    
    required override init() {}

    required init(json: JSON) {
        self.user           = json["User"]
        self.id             = json["id"].stringValue
        self.firstName      = json["firstName"].stringValue
        self.lastName       = json["lastName"].stringValue
        self.pictureURL     = json["pictureUrl"].stringValue
        self.email          = json["gmail"].stringValue
        self.token          = json["token"].stringValue
        self.fullName       = json["fullName"].stringValue
        
        if fullName.isEmpty {
            self.fullName = "\(lastName) \(firstName)".trimmingCharacters(in: .whitespaces)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        id          = aDecoder.decodeObject(forKey: "id") as? String ?? ""
        firstName   = aDecoder.decodeObject(forKey: "firstName") as? String ?? ""
        lastName    = aDecoder.decodeObject(forKey: "lastName") as? String ?? ""
        email       = aDecoder.decodeObject(forKey: "email") as? String ?? ""
        fullName    = "\(lastName) \(firstName)".trimmingCharacters(in: .whitespaces)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id,           forKey: "id")
        aCoder.encode(token,        forKey: "token")
        aCoder.encode(firstName,    forKey: "firstName")
        aCoder.encode(lastName,     forKey: "lastName")
        aCoder.encode(email,        forKey: "email")
    }
    
}
