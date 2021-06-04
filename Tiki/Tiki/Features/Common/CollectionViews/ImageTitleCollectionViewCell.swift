//
//  ImageTitleCollectionViewCell.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 4/7/21.
//

import UIKit

class ImageTitleCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Variables
    
    // MARK: - UI Elements
    
    fileprivate lazy var imageView: ShimmerImageView = {
        let imageView = ShimmerImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius  = dimension.cornerRadiusSmall
        return imageView
    }()
    
    fileprivate lazy var titleLabel: ShimmerLabel = {
        let label = ShimmerLabel()
        label.font = UIFont.systemFont(ofSize: FontSize.h3.rawValue,
                                       weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.layer.cornerRadius = dimension.cornerRadiusSmall
        label.layer.masksToBounds = true
        return label
    }()
    
    // MARK: - View LifeCycles
    
    override func initialize() {
        super.initialize()
        layoutImageView()
        layoutTitleLabel()
        startShimmering()
    }
    
    func startShimmering() {
        imageView.startShimmer()
        titleLabel.startShimmer()
    }
    
    func stopShimmering() {
        imageView.stopShimmer()
        titleLabel.stopShimmer()
    }

    // MARK: - Helper Method
    
    func configCell(_ image: String?, _ title: String?) {
        self.imageView.loadImage(by: image,
             defaultImage: ImageManager.defaultAvatar)
        self.titleLabel.text = title
    }
    
    // MARK: - GET API
    
    // MARK: - Layout
    
    private func layoutImageView() {
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func layoutTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom)
                .offset(dimension.smallMargin)
            make.left.right.equalToSuperview()
        }
    }
}
