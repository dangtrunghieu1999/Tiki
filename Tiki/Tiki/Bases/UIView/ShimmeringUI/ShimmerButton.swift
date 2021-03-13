//
//  ShimmerButton.swift
//  ZoZoApp
//
//  Created by LAP12852 on 7/7/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class ShimmerButton: BaseShimmerView {

    // MARK: - Variables
    
    var buttonBGColor: UIColor = UIColor.white {
        didSet {
            button.backgroundColor = buttonBGColor
        }
    }
    
    // MARK: - UI Elements
    
    private lazy var button: UIButton = {
        let button = UIButton()
        return button
    }()
    
    // MARK: - LifeCycles
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initialize() {
        layoutButton()
    }
    
    // MARK: - Public Methods
    
    func setTitle(_ title: String?, for state: UIControl.State) {
        button.setTitle(title, for: state)
    }
    
    func setTitleColor(_ color: UIColor?, for state: UIControl.State) {
        button.setTitleColor(color, for: state)
    }
    
    func setImage(_ image: UIImage?, for state: UIControl.State) {
        button.setImage(image, for: state)
    }
    
    func setFont(_ font: UIFont) {
        button.titleLabel?.font = font
    }
    
    func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        button.addTarget(target, action: action, for: controlEvents)
    }
    
    func startShimmer() {
        super.startShimmer()
        button.isHidden = true
    }
    
    func stopShimmer() {
        super.stopShimmer()
        button.isHidden = false
    }
    
    // MARK: - UI Actions
    
    // MARK: - Helper Methods
    
    // MARK: - Layout
    
    private func layoutButton() {
        addSubview(button)
        button.snp.makeConstraints { (make) in
            make.width.height.centerX.centerY.equalToSuperview()
        }
    }

}
