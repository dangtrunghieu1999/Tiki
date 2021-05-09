//
//  FeedHeaderInfoModel.swift
//  ZoZoApp
//
//  Created by LAP12852 on 9/2/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit
import IGListKit
import SwiftyJSON

class FeedHeaderInfoModel: BaseFeedSectionModel {
    
    // MARK: - Variables
    
    // MARK: - User
    var feedId                          = 0
    var userId                          = ""
    var displayName                     = ""
    var avatar                          = ""
    var content                         = ""
    var tags: [User]                    = []
    var address                         = ""
    var lat: CGFloat                    = 0
    var long: CGFloat                   = 0
    var sendList: [User]                = []
    var scope: NewsFeedScope            = .public
    var createdTime                     = Date()
    
    // MARK: Shop
    var shopId                          = 0
    var shopName                        = ""
    var shopAvatar                      = ""
    
    // MARK: Helper
    var headerTitle                     = ""
    var headerAttrString          = NSMutableAttributedString(string: "")
    var numberOfPhoto                   = 0
    var headerTitleHeight: CGFloat      = 16
    var estimateCellHeight: CGFloat     = 60
    
    // MARK: - LifeCycle
    
    required init() {
        super.init()
    }
  
    convenience init(from json: JSON, numberPhotos: Int) {
        self.init(json: json)
        numberOfPhoto = numberPhotos
        mapHeaderTitle()
        calculateHeight()
    }
    
    required init(json: JSON) {
        super.init(json: json)
        
        feedId          = json["Id"].intValue
        userId          = json["UserId"].stringValue
        displayName     = json["DisplayName"].stringValue
        avatar          = json["Avatar"].stringValue
        content         = json["Content"].stringValue
        createdTime     = json["CreatedTime"].dateValue
        tags            = json["Tags"].arrayValue.map { User(json: $0) }
        address         = json["Address"].stringValue
        long            = CGFloat(json["Lng"].doubleValue)
        lat             = CGFloat(json["Lat"].doubleValue)
        sendList        = json["SendList"].arrayValue.map { User(json: $0) }
        scope           = NewsFeedScope(rawValue: json["Scope"].intValue) ?? .public
        
        mapHeaderTitle()
        calculateHeight()
    }
    
    // MARK: - Override methods
    
    override func cellSize() -> CGSize {
        return CGSize(width: ScreenSize.SCREEN_WIDTH, height: estimateCellHeight)
    }
    
    // MARK: - Helper methods
    
    private func calculateHeight() {
        let cell = FeedHeaderInfoCollectionViewCell()
        headerTitleHeight = headerAttrString.height(containerWidth: cell.headerTitleWidth)
        
        let cellHeight = 2 * cell.avatarTopMargin + headerTitleHeight + 10
        estimateCellHeight = max(60, cellHeight)
    }
    
    private func mapHeaderTitle() {
        let highlightAttrs  = [NSAttributedString.Key.foregroundColor: UIColor.bodyText,
                              NSAttributedString.Key.font: UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .medium)]
        let normalAttrs     = [NSAttributedString.Key.foregroundColor: UIColor.bodyText,
                               NSAttributedString.Key.font: UIFont.systemFont(ofSize: FontSize.h1.rawValue)]
        
        headerAttrString    = NSMutableAttributedString(string: displayName,
                                                        attributes: highlightAttrs)
        
        if address.isEmpty && tags.isEmpty && numberOfPhoto == 0 {
            
        }
        
        if address.isEmpty && tags.isEmpty {
            if numberOfPhoto > 0 {
                let text = String(format: " \(TextManager.addPhotoToFeed.localized())", numberOfPhoto)
                let attrs = NSAttributedString(string: text, attributes: normalAttrs)
                headerAttrString.append(attrs)
            }
        }
        
        if address != "" {
            let atLocationAttrs = NSAttributedString(string: " \(TextManager.at.localized())", attributes: normalAttrs)
            let addressAttrs = NSAttributedString(string: " \(address)", attributes: highlightAttrs)
            headerAttrString.append(atLocationAttrs)
            headerAttrString.append(addressAttrs)
        }
        
        if !tags.isEmpty {
            let withAttrs = NSAttributedString(string: " \(TextManager.widthFriend.localized())",
                attributes: normalAttrs)
            let friendAttrs = NSAttributedString(string: " \(tags.first?.fullName ?? "")", attributes: highlightAttrs)
            headerAttrString.append(withAttrs)
            headerAttrString.append(friendAttrs)
            
            if tags.count == 2 {
                let andFiend = NSAttributedString(string: " \(TextManager.and.localized())",
                    attributes: normalAttrs)
                let fullName = tags[safe: 1]?.fullName ?? ""
                let secondFriendAttrs = NSAttributedString(string: " \(fullName)", attributes: highlightAttrs)
                headerAttrString.append(andFiend)
                headerAttrString.append(secondFriendAttrs)
            } else if tags.count > 2 {
                let numberOtherFriends = tags.count - 2
                let text = String.init(format: " \(TextManager.andOtherFriend)", numberOtherFriends)
                let numberOtherFriendsAttrs = NSAttributedString(string: text, attributes: highlightAttrs)
                headerAttrString.append(numberOtherFriendsAttrs)
            }
        }
    
    }
    
}
