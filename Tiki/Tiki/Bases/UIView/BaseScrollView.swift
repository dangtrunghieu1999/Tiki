//
//  BaseScrollView.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 5/15/21.
//

import UIKit

class BaseScrollView: UIScrollView {
    
    // MARK: - Define Components
    public let view: UIView = UIView()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupComponents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupComponents()
    }
    
    // MARK: - Setup UI
    func setupComponents() {
        self.backgroundColor = UIColor.white
        self.addSubview(self.view)
        
        self.view.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        self.view.backgroundColor = .clear
    }
}
