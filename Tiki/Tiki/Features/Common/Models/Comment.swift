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
    var fullName = ""
    var userAvatar = ""
    var createOn = Date()
    var rating: CGFloat = 0
    var photos: [Photo] = []
    var commentChild: [Comment] = []

    required override init() {}
    
    required init(json: JSON) {
        
        id          = json["id"].int
        content     = json["content"].stringValue
        parentId    = json["parentId"].int
        productId   = json["productId"].intValue
        userId      = json["userId"].stringValue
        fullName    = json["fullName"].stringValue
        userAvatar  = json["userAvatar"].stringValue
        createOn    = json["createOn"].dateValue
        photos      = json["photos"].arrayValue.map { Photo(json: $0) }
        commentChild = json["commentChild"].arrayValue.map { Comment(json: $0) }
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
            dict["id"] = id
        }
        
        if let parentId = parentId {
            dict["productId"]    = parentId
        }
        
        dict["content"]     = content
        dict["productId"]   = productId
        dict["userId"]      = userId
        dict["fullName"]    = fullName
        dict["userAvatar"]  = userAvatar
        dict["createOn"]    = createOn.serverDateFormat
        
        return dict
    }
}

