//
//  TransporterTableViewCell.swift
//  ZoZoApp
//
//  Created by Dang Trung Hieu on 8/25/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class TransporterTableViewCell: BaseTableViewCell {
    
    // MARK: - UI Elements
    
    fileprivate lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightBackground
        return view
    }()
    
    private lazy var checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = ImageManager.checkMarkUnCheck
        return imageView
    }()
    
    private let logoTransportImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = ImageManager.logoGHTK
        return imageView
    }()
    
    // MARK: - View LifeCycles
    
    override func initialize() {
        super.initialize()
        layoutContainerView()
        layoutCheckImageView()
        layoutLogoTransportImageView()
    }
    
    // MARK: - Public methods
    
    func configData(_ transporterType: TransportersType) {
        logoTransportImageView.image = transporterType.logo
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                checkImageView.image = ImageManager.checkMarkCheck
            } else {
                checkImageView.image = ImageManager.checkMarkUnCheck
            }
        }
    }
    
    // MARK: - Setup Layouts
    
    private func layoutContainerView() {
        addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func layoutCheckImageView() {
        containerView.addSubview(checkImageView)
        checkImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(18)
            make.left.equalToSuperview().offset(Dimension.shared.largeMargin)
            make.centerY.equalToSuperview()
        }
    }
    
    private func layoutLogoTransportImageView() {
        containerView.addSubview(logoTransportImageView)
        logoTransportImageView.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.width.equalTo(200)
            make.centerY.equalToSuperview()
            make.left.equalTo(checkImageView.snp.right).offset(Dimension.shared.normalMargin)
        }
    }

}
