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
    
    required override init() {}

    required init(json: JSON) {
        self.id             = json["id"].stringValue
        self.token          = json["auth_token"].stringValue
        self.firstName      = json["FirstName"].stringValue
        self.lastName       = json["LastName"].stringValue
        self.pictureURL     = json["PictureUrl"].stringValue
        self.email          = json["Email"].stringValue
        self.fullName       = json["FullName"].stringValue
        
        if id == "" {
            id              = json["Id"].stringValue
        }
        if id == "" {
            id              = json["UserId"].stringValue
        }
        
        if fullName.isEmpty {
            self.fullName = "\(lastName) \(firstName)".trimmingCharacters(in: .whitespaces)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        id          = aDecoder.decodeObject(forKey: "id") as? String ?? ""
        token       = aDecoder.decodeObject(forKey: "auth_token") as? String ?? ""
        firstName   = aDecoder.decodeObject(forKey: "FirstName") as? String ?? ""
        lastName    = aDecoder.decodeObject(forKey: "LastName") as? String ?? ""
        email       = aDecoder.decodeObject(forKey: "PictureUrl") as? String ?? ""
        fullName    = "\(lastName) \(firstName)".trimmingCharacters(in: .whitespaces)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id,           forKey: "id")
        aCoder.encode(token,        forKey: "auth_token")
        aCoder.encode(firstName,    forKey: "FirstName")
        aCoder.encode(lastName,     forKey: "LastName")
        aCoder.encode(email,        forKey: "PictureUrl")
    }
    
}
