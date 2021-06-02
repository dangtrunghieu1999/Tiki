//
//  Home.swift
//  Tiki
//
//  Created by Bee_MacPro on 02/06/2021.
//

import SwiftyJSON

class Home: NSObject, JSONParsable {

    var menu    : [Menu]   = []
    var banner  : [Banner] = []
    var data    : JSON?
    var type    : String?   = ""
    
    required override init() {}
    
    required init(json: JSON) {
        self.data = json["data"]
        self.type = json["type"].stringValue
        
        if type == "SlideWidget" {
            banner = data?.arrayValue.map{ Banner(json: $0) } ?? []
        } else if type == "ShortcutWidget" {
            menu  = data?.arrayValue.map{ Menu(json: $0) } ?? []
        }
    }
}
