//
//  EmptyCollectionViewCell.swift
//  ZoZoApp
//
//  Created by LAP12852 on 7/7/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class EmptyCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Variables
    
    var message: String? {
        didSet {
            emptyView.message = message
        }
    }
    
    var image: UIImage? {
        didSet {
            emptyView.image = image
        }
    }
    
    var imageSize: CGSize = CGSize(width: 90, height: 90) {
        didSet {
            emptyView.updateImageSize(imageSize)
        }
    }
    
    var messageFont: UIFont = UIFont.systemFont(ofSize: FontSize.body.rawValue) {
        didSet {
            emptyView.font = messageFont
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
            make.edges.equalToSuperview()
        }
    }
    
}
