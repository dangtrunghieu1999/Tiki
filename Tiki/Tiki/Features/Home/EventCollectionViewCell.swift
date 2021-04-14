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
        imageView.contentMode = .scaleAspectFit
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
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - HomeViewProtocol

extension EventCollectionViewCell: HomeViewProtocol {
    func configDataEvent(event: EventModel?) {
        self.imageView.sd_setImage(with: event?.list[0].image.url, completed: nil)
    }
}
