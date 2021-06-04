//
//  TransporterTableViewCell.swift
//  Tiki
//
//  Created by Bee_MacPro on 04/06/2021.
//

import UIKit

class TransporterTableViewCell: BaseTableViewCell {
    
    // MARK: - UI Elements
    
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
    
    
    private func layoutCheckImageView() {
        addSubview(checkImageView)
        checkImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(18)
            make.left.equalToSuperview()
                .offset(dimension.largeMargin)
            make.centerY.equalToSuperview()
        }
    }
    
    private func layoutLogoTransportImageView() {
        addSubview(logoTransportImageView)
        logoTransportImageView.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.width.equalTo(200)
            make.centerY.equalToSuperview()
            make.left.equalTo(checkImageView.snp.right)
                .offset(dimension.normalMargin)
        }
    }
    
}
