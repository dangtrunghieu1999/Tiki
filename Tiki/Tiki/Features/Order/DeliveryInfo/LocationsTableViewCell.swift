//
//  LocationsTableViewCell.swift
//  Tiki
//
//  Created by Bee_MacPro on 19/06/2021.
//

import UIKit

class LocationsTableViewCell: BaseTableViewCell {
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        return label
    }()
    
    private let lineView: BaseView = {
        let view = BaseView()
        view.backgroundColor = UIColor.separator
        return view
    }()
    
    override func initialize() {
        super.initialize()
        layoutTitleLabel()
        layoutLineView()
    }
    
    func configCell(title: String) {
        self.titleLabel.text = title
    }

    private func layoutTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY
                .equalToSuperview()
            make.left
                .equalToSuperview()
                .offset(dimension.normalMargin)
        }
    }
    
    private func layoutLineView() {
        addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left
                .equalTo(titleLabel)
            make.right
                .equalToSuperview()
            make.height
                .equalTo(1)
            make.bottom
                .equalToSuperview()
        }
        
    }
}
