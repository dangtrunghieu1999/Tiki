//
//  CheckMarkView.swift
//  ZoZoApp
//
//  Created by MACOS on 6/30/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

enum CheckMarkState {
    case check
    case unCheck
}

class CheckMarkView: BaseView {

    // MARK: - Variables
    
    var state: CheckMarkState = .unCheck {
        didSet {
            if state == .check {
                imageView.image = ImageManager.checkMarkCheck
            } else {
                imageView.image = ImageManager.checkMarkUnCheck
            }
        }
    }
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    // MARK: - UI Elements
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor.titleText
        label.font = UIFont.systemFont(ofSize: FontSize.body.rawValue)
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.checkMarkUnCheck
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - LifeCycles
    
    override func initialize() {
        layoutTitleLabel()
        layoutImageView()
    }

    func updateState() {
        if state == .check {
            state = .unCheck
        } else {
            state = .check
        }
    }
    
    // MARK: - Layouts
    
    private func layoutTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.centerY.equalToSuperview()
        }
    }
    
    private func layoutImageView() {
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(18)
            make.centerY.equalToSuperview()
            make.left.equalTo(titleLabel.snp.right).offset(16)
            make.right.equalToSuperview().offset(-8)
            make.top.equalToSuperview().offset(4)
            make.bottom.equalToSuperview().offset(-4)
        }
    }

}
