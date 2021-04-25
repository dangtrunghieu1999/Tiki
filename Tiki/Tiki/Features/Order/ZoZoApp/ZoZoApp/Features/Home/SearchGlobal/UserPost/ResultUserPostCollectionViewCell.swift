//
//  ResultUserPostCollectionViewCell.swift
//  ZoZoApp
//
//  Created by Dang Trung Hieu on 8/31/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class ResultUserPostCollectionViewCell: BaseCollectionViewCell {
    
    fileprivate lazy var userPostImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "productImage")
        imageView.layer.cornerRadius = 40
        return imageView
    }()
    
    fileprivate lazy var userPostLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = UIColor.lightBodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        label.text = "Một đôi giày tốt sẽ đưa ta đến những nơi tốt đẹp nhất, ước mơ cũng chúng ta nằm trên đôi chân ấy.Nhiều phụ nữ nghĩ rằng giày không quan trọng, nhưng chính phụ kiện dành cho đôi chân này là yếu tố quyết định nét duyên dáng của các bạn,là hành trang vững chắc để đưa ta đến những ước mơ còn đang dang dở."
        return label
    }()
    
    override func initialize() {
        super.initialize()
        layoutUserPostImageView()
        layoutUserPostLabel()
    }
    
    
    private func layoutUserPostImageView() {
        addSubview(userPostImageView)
        userPostImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(80)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(Dimension.shared.normalMargin)
        }
    }
    private func layoutUserPostLabel() {
        addSubview(userPostLabel)
        userPostLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Dimension.shared.mediumMargin)
            make.left.equalTo(userPostImageView.snp.right).offset(Dimension.shared.mediumMargin)
            make.right.equalToSuperview().offset(-Dimension.shared.normalMargin)
            make.bottom.equalToSuperview().offset(-Dimension.shared.mediumMargin)
        }
    }
}
