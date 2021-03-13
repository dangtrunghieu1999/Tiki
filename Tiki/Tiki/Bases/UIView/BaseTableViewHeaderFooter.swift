//
//  BaseUITableViewHeaderFooter.swift
//  Ecom
//
//  Created by MACOS on 3/25/19.
//  Copyright © 2019 Minh Tri. All rights reserved.
//

import UIKit

class BaseTableViewHeaderFooter: UITableViewHeaderFooterView, Reusable {
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        isUserInteractionEnabled = true
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initialize() {}
    
}
