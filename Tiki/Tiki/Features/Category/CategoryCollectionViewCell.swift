//
//  CategoryCollectionViewCell.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 5/16/21.
//

import UIKit

class CategoryCollectionViewCell: BaseCollectionViewCell {
    
    private lazy var containerView: BaseView = {
        let view = BaseView()
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightBackground.cgColor
        return view
    }()
    
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
    
    // MARK: - Life Cycles
    
    override func initialize() {
        super.initialize()
        layoutContainerView()
        layoutImageView()
        layoutTitleLabel()
    }
    
    // MARK: - Public Method
    
    public func configCell(image: UIImage?, title: String?) {
        imageView.image = image
        titleLabel.text = title
    }
    
    // MARK: - Layout
    
    private func layoutContainerView() {
        addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func layoutImageView() {
        containerView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Dimension.shared.mediumMargin)
            make.right.equalToSuperview().offset(-Dimension.shared.mediumMargin)
            make.height.equalTo(80)
            make.top.equalToSuperview().offset(Dimension.shared.smallMargin)
        }
    }
    
    private func layoutTitleLabel() {
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-Dimension.shared.smallMargin)
            make.left.right.equalToSuperview()
        }
    }
    
}
