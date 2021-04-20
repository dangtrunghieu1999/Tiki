//
//  TitleTableViewCell.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 4/18/21.
//

import UIKit

class TitleTableViewCell: BaseTableViewCell {

    // MARK: - Variables
    
    // MARK: - UI Elements
    
    public lazy var keyCoverView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    fileprivate lazy var nameKeyTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        return label
    }()
    
    public lazy var valueCoverView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    fileprivate lazy var nameValueTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        return label
    }()
    
    
    // MARK: - View LifeCycles
    
    override func initialize() {
        super.initialize()
        layoutKeyCoverView()
        layoutValueCoverView()
        layoutNameKeyTitleLabel()
        layoutNameValueTitleLabel()
    }
    
    // MARK: - Helper Method
    
    func configTitle(keyTitle: String, valueTitle: String) {
        self.nameKeyTitleLabel.text     = keyTitle
        self.nameValueTitleLabel.text   = valueTitle
    }
    
    // MARK: - GET API
    
    // MARK: - Layout
    
    private func layoutKeyCoverView() {
        addSubview(keyCoverView)
        keyCoverView.snp.makeConstraints { (make) in
            make.width.equalTo(self.snp.width).multipliedBy(0.4)
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview()
        }
    }
    
    private func layoutNameKeyTitleLabel() {
        keyCoverView.addSubview(nameKeyTitleLabel)
        nameKeyTitleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Dimension.shared.normalMargin)
            make.top.equalToSuperview().offset(Dimension.shared.mediumMargin)
            make.right.equalToSuperview().offset(-Dimension.shared.normalMargin)
            make.bottom.equalToSuperview().offset(-Dimension.shared.mediumMargin)
        }
    }
    
    private func layoutValueCoverView() {
        addSubview(valueCoverView)
        valueCoverView.snp.makeConstraints { (make) in
            make.width.equalTo(self.snp.width).multipliedBy(0.6)
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
    
    private func layoutNameValueTitleLabel() {
        valueCoverView.addSubview(nameValueTitleLabel)
        nameValueTitleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Dimension.shared.normalMargin)
            make.top.equalToSuperview().offset(Dimension.shared.mediumMargin)
            make.right.equalToSuperview().offset(-Dimension.shared.normalMargin)
            make.bottom.equalToSuperview().offset(-Dimension.shared.mediumMargin)
        }
    }

}
