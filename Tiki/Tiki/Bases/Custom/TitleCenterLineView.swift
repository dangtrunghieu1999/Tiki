//
//  TitleCenterLineView.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 5/17/21.
//

import UIKit

class TitleCenterLineView: BaseView {
    
    private let leftLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightSeparator
        return view
    }()
    
    private let rightLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightSeparator
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightBodyText
        return label
    }()
    
    var titleText: String = "" {
        didSet {
            self.titleLabel.text = titleText
        }
    }
    
    var lineColor: UIColor = .lightGray {
        didSet {
            self.leftLineView.backgroundColor  = self.lineColor
            self.rightLineView.backgroundColor = self.lineColor
        }
    }
    
    var lineHeight: CGFloat = 1.0 {
        didSet {
            self.leftLineView.snp.remakeConstraints { (remake) in
                remake.leading.centerY.equalToSuperview()
                remake.trailing.equalTo(self.titleLabel.snp.leading)
                    .offset(-self.lineSpacing)
            }
        }
    }
    
    var lineSpacing: CGFloat = 4 {
        didSet {
            self.leftLineView.snp_remakeConstraints { (remake) in
                remake.leading.centerY.equalToSuperview()
                remake.trailing.equalTo(self.titleLabel.snp.leading).offset(-self.lineSpacing)
                remake.height.equalTo(self.lineHeight)
            }
            
            self.rightLineView.snp.remakeConstraints { (remake) in
                remake.top.bottom.equalTo(self.leftLineView)
                remake.leading.equalTo(self.titleLabel.snp.trailing).offset(-self.lineSpacing)
                remake.trailing.equalToSuperview()
            }
        }
    }
    
    override func initialize() {
        super.initialize()
        self.setupTitleLabel()
        self.setupLeftLineView()
        self.setupRightLineView()
    }
}

extension TitleCenterLineView {
    
    private func setupTitleLabel() {
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    private func setupLeftLineView() {
        self.addSubview(self.leftLineView)
        self.leftLineView.snp.makeConstraints { (make) in
            make.left.centerY.equalToSuperview()
            make.right.equalTo(titleLabel.snp.left).offset(-Dimension.shared.normalMargin)
            make.height.equalTo(1.0)
        }
    }
    
    private func setupRightLineView() {
        self.addSubview(self.rightLineView)
        self.rightLineView.snp.makeConstraints { (make) in
            make.right.centerY.equalToSuperview()
            make.left.equalTo(titleLabel.snp.right).offset(Dimension.shared.normalMargin)
            make.height.equalTo(1.0)
        }
    }
}
