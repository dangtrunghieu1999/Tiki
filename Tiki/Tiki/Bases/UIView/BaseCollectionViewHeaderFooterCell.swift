//
//  BaseCollectionViewHeaderFooterCell.swift
//  Ecom
//
//  Created by MACOS on 3/23/19.
//  Copyright © 2019 Minh Tri. All rights reserved.
//

import UIKit

class BaseCollectionViewHeaderFooterCell: UICollectionReusableView, Reusable {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    func initialize() {
        backgroundColor = UIColor.separator
    }
    
}
