//
//  Comment.swift
//  ZoZoApp
//
//  Created by MACOS on 7/3/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit
import SwiftyJSON

class Comment: NSObject, JSONParsable {

    var id: Int?
    var content = ""
    var parentId: Int?
    var productId = 0
    var userId = ""
    var userName = ""
    var fullName = ""
    var userAvatar = ""
    var createOn = Date()
    var rating: CGFloat = 0
    var photos: [Photo] = []
    var commentChild: [Comment] = []

    required override init() {}
    
    required init(json: JSON) {
        id          = json["Id"].int
        content     = json["Content"].stringValue
        parentId    = json["ParentId"].int
        productId   = json["ProductId"].intValue
        userId      = json["UserId"].stringValue
        userName    = json["UserName"].stringValue
        fullName    = json["FullName"].stringValue
        userAvatar  = json["UserAvatar"].stringValue
        createOn    = json["CreateOn"].dateValue
        rating      = CGFloat(json["Rating"].doubleValue)
        photos      = json["Photos"].arrayValue.map { Photo(json: $0) }
        commentChild = json["CommentsChild"].arrayValue.map { Comment(json: $0) }
    }
    
    var allComments: [Comment] {
        var comments: [Comment] = []
        comments.append(self)
        comments.append(contentsOf: commentChild)
        return comments
    }
    
    var isParrentComment: Bool {
        return parentId == nil
    }
    
}

// MARK: - To Dict

extension Comment {
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        
        if let id = id {
            dict["Id"] = id
        }
        
        if let parentId = parentId {
            dict["ParentId"]    = parentId
        }
        
        dict["Content"]     = content
        dict["ProductId"]   = productId
        dict["UserId"]      = userId
        dict["UserName"]    = userName
        dict["FullName"]    = fullName
        dict["UserAvatar"]  = userAvatar
        dict["CreateOn"]    = createOn.serverDateFormat
        dict["Rating"]      = rating
        
        return dict
    }
}
