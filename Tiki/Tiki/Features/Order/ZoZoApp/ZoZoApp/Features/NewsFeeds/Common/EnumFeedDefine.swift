//
//  EnumFeedDefine.swift
//  ZoZoApp
//
//  Created by LAP12852 on 10/27/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import Foundation

enum NewsFeedType: Int {
    case shopShareProduct = 0
    case userShareProduct = 1
    case postFeed         = 2
    case shareFeed        = 3
}

enum NewsFeedScope: Int {
    case `public`       = 1
    case friend         = 2
    case friendIgnore   = 3
    case someFriend     = 4
    case `private`      = 5
}

enum NewsFeedEmotion: String {
    case happy              = "Vui vẻ"
    case sad                = "Buồn"
}
