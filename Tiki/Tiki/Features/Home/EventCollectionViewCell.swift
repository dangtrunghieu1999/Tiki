//
//  EventCollectionViewCell.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 4/8/21.
//

import UIKit

class EventCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Variables
    
    // MARK: - UI Elements
    
    fileprivate lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = dimension.conerRadiusMedium
        return imageView
    }()
    
    // MARK: - View LifeCycles
    
    override func initialize() {
        super.initialize()
        layoutImageView()
    }
    
    // MARK: - Helper Method
    
    
    // MARK: - GET API
    
    // MARK: - Layout
    
    private func layoutImageView() {
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
                .inset(dimension.normalMargin)
            make.left.right.equalToSuperview()
                .inset(dimension.normalMargin)
        }
    }
}

// MARK: - HomeViewProtocol

extension EventCollectionViewCell: HomeViewProtocol {
    func configDataEvent(event: BannerEventSectionModel?) {
        self.imageView.sd_setImage(with: event?.url.url, completed: nil)
    }
}
