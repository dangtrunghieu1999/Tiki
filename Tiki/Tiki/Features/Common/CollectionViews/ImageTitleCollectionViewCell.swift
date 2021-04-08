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
    
    fileprivate lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontSize.h3.rawValue, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    // MARK: - View LifeCycles
    
    override func initialize() {
        super.initialize()
        layoutImageView()
        layoutTitleLabel()
    }
    
    // MARK: - Helper Method
    
    func configCell(_ image: String?, _ title: String?) {
        self.imageView.sd_setImage(with: image?.url, completed: nil)
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
            make.top.equalTo(imageView.snp.bottom).offset(Dimension.shared.smallMargin)
            make.left.right.equalToSuperview()
        }
    }
}
