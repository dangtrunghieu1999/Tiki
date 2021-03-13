//
//  Dictionary+Extension.swift
//  ZoZoApp
//
//  Created by LAP12852 on 8/31/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import Foundation
import SwiftyJSON

extension Dictionary {
    var jsonString: String? {
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(data: data, encoding: .utf8)
        } catch {
            #if DEBUG
            fatalError("DICT EXT >> JSONSTRING >> Can not convert")
            #else
            return nil
            #endif
        }
    }
    
    var jsonData: Data? {
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return data
        } catch {
            #if DEBUG
            fatalError("DICT EXT >> JSON_DATA >> Can not convert")
            #else
            return nil
            #endif
        }
    }
    
    var JSON_Swifty: JSON? {
        if let data = jsonData {
            do {
                let json = try JSON(data: data)
                return json
            } catch {
                #if DEBUG
                fatalError("DICT EXT >> JSON_SWIFTY >> Can not convert")
                #else
                return nil
                #endif
            }
        } else {
            return nil
        }
    }
}
