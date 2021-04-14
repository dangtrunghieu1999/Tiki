//
//  Photo.swift
//  ZoZoApp
//
//  Created by MACOS on 7/3/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit
import SwiftyJSON

class Photo: NSObject, JSONParsable {
    
    var alt = ""
    var base64String: String?
    var createdBy: String?
    var createdOn = Date()
    var id: Int?
    var name = ""
    var note = ""
    var order = 0
    var photoTypeId = 0
    var photoTypeName = ""
    var status = 0
    var updatedBy: String?
    var updatedOn = Date()
    var url = ""
    
    // Local data
    var currentImage: UIImage?
    
    required override init() {}
    
    init(image: UIImage?) {
        currentImage = image
    }
    
    required init(json: JSON) {
        alt             = json["Alt"].stringValue
        base64String    = json["Base64String"].string
        createdBy       = json["CreatedBy"].stringValue
        createdOn       = json["CreatedOn"].dateValue
        id              = json["id"].intValue
        name            = json["name"].stringValue
        note            = json["Note"].stringValue
        order           = json["Order"].intValue
        photoTypeId     = json["PhotoTypeId"].intValue
        photoTypeName   = json["PhotoTypeName"].stringValue
        status          = json["Status"].intValue
        updatedBy       = json["UpdatedBy"].stringValue
        updatedOn       = json["UpdatedOn"].dateValue
        url             = json["link"].stringValue
    }
    
}

// MARK: - Map to Dictionary

extension Photo {
    func toDictionary() -> [String: Any] {
        
        if currentImage != nil {
            return toUpdateDictionary()
        }
        
        var dict: [String: Any] = [:]
        
        if let id = id {
            dict["Id"] = id
        }
        
        if let image = currentImage {
            dict["Base64String"] = image.base64ImageString ?? ""
        } else if url != "" {
            dict["Url"] = url
        }
        
        dict["Alt"] = alt
        dict["createdBy"] = createdBy
        dict["createdOn"] = createdOn.desciption(by: .fullDateServerFormat)
        dict["Name"] = name
        dict["Note"] = note
        dict["Order"] = order
        dict["PhotoTypeId"] = photoTypeId
        dict["PhotoTypeName"] = photoTypeName
        dict["Status"] = status.description
        dict["UpdatedBy"] = updatedBy ?? ""
        dict["UpdatedOn"] = updatedOn.desciption(by: .fullDateServerFormat)
        
        return dict
    }
    
    func toUpdateDictionary() -> [String: Any] {
        var params: [String: Any] = [:]
        let id = UUID().uuidString
        params["Name"]          = id
        params["Alt"]           = id
        params["PhotoTypeId"]   = 1
        params["Base64String"]  = currentImage?.base64ImageString ?? ""
        params["Status"]        = 1
        return params
    }
}
