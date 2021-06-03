//
//  HeaderCollectionViewCell.swift
//  Tiki
//
//  Created by Bee_MacPro on 03/06/2021.
//

import UIKit

class HeaderCollectionViewCell: BaseCollectionViewCell {
    
    fileprivate lazy var titleLabel: ShimmerLabel = {
        let label = ShimmerLabel()
        label.textColor = UIColor.primary
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .bold)
        return label
    }()
    
    // MARK: - View LifeCycles
    
    override func initialize() {
        super.initialize()
        backgroundColor = .white
        layoutTitleLabel()
        startShimmering()
    }
    
    // MARK: - Helper Method
    
    func configTitle(title: String?) {
        self.titleLabel.text = title
    }
    
    func startShimmering() {
        self.titleLabel.startShimmer()
    }
    
    func stopShimmering() {
        self.titleLabel.stopShimmer()
    }
    
    // MARK: - GET API
    
    // MARK: - Layout
    
    private func layoutTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
                .offset(dimension.normalMargin)
            make.top.equalToSuperview()
                .offset(dimension.mediumMargin)
            make.width.equalTo(150)
        }
    }
}
