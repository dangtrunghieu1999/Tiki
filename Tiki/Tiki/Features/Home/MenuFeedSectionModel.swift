//
//  MenuFeedSectionModel.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 3/28/21.
//

import UIKit
import IGListKit
import SwiftyJSON

class MenuFeedSectionModel: BaseHomeSectionModel {

    required init() {
        super.init()
    }
    
    required init(json: JSON) {
        super.init(json: json)
        
    }

}
