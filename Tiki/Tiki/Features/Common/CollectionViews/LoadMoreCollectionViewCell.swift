//
//  LoadMoreCollectionViewCell.swift
//  Ecom
//
//  Created by MACOS on 3/23/19.
//  Copyright © 2019 Minh Tri. All rights reserved.
//

import UIKit

class LoadMoreCollectionViewCell: BaseCollectionViewHeaderFooterCell {
    private let indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView()
        indicatorView.color = UIColor.gray
        return indicatorView
    }()
    
    override func initialize() {
        setupViewIndicatorView()
    }
    
    func animiate(_ value: Bool) {
        if value {
            indicatorView.startAnimating()
            indicatorView.isHidden = false
        } else {
            indicatorView.stopAnimating()
            indicatorView.isHidden = true
        }
    }
    
    private func setupViewIndicatorView() {
        addSubview(indicatorView)
        indicatorView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
}
