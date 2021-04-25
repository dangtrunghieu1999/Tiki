//
//  APIConfig.swift
//  GlobeDr
//
//  Created by MACOS on 9/28/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import Foundation

class APIConfig {
    enum NetworkEnviroment {
        case production
        case test
    }
    
    static let requestTimeOut: TimeInterval = 60
    static let defaultNullValue  = ""
    static let enviroment        = NetworkEnviroment.production
    static let GGPlaceAPIKey     = "AIzaSyDVwSKCBNG-WtaWHzcY01N797KFhhsBkLs"
    
    static var baseURLString: String {
        switch enviroment {
        case .production:
            return "https://fitfood.topfly.vn/api/1.0"
        case .test:
             return "https://fitfood.topfly.vn/api/1.0"
        }
    }
    
}


