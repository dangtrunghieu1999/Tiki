//
//  BaseUITableViewCell.swift
//  Ecom
//
//  Created by Nguyen Dinh Trieu on 3/22/19.
//  Copyright © 2019 Minh Tri. All rights reserved.
//

import UIKit

open class BaseTableViewCell: UITableViewCell, Reusable {
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupDefault()
        initialize()
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        setupDefault()
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupDefault()
        initialize()
    }
    
    public func initialize() {}
    
    private func setupDefault() {
        selectionStyle = .none
        backgroundColor = UIColor.white
    }
}
