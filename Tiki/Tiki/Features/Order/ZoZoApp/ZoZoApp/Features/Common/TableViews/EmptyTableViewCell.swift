//
//  EmptyTableViewCell.swift
//  ZoZoApp
//
//  Created by LAP12852 on 7/7/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class EmptyTableViewCell: BaseTableViewCell {

    // MARK: - Variables
    
    var message: String? {
        didSet {
            emptyView.message = message
        }
    }
    
    // MARK: - UI Elements
    
    let emptyView = EmptyView()
    
    // MARK: - LifeCycles
    
    override func initialize() {
        layoutEmptyView()
    }
    
    // MARK: - Layout
    
    private func layoutEmptyView() {
        addSubview(emptyView)
        emptyView.snp.makeConstraints { (make) in
            make.left.right.bottom.top.equalToSuperview()
        }
    }

}
