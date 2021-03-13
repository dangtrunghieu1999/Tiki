//
//  BageButton.swift
//  Ecom
//
//  Created by Nguyen Dinh Trieu on 3/28/19.
//  Copyright © 2019 Minh Tri. All rights reserved.
//

import UIKit

public class BadgeButton: UIButton {
    
    // MARK: - Private Properties
    
    private var badgeLabel = UILabel()
    private var needUpdateLayout = false
    
    // MARK: - Public properties
    
    public var badgeNumber: Int = 0 {
        didSet {
            if frame == .zero {
                needUpdateLayout = true
            } else {
                setupBadgeViewWithString(badgeText: badgeString)
            }
        }
    }
    
    private var badgeString: String? {
        if badgeNumber == 0 {
            return ""
        } else if badgeNumber > 99 {
            return "99+"
        } else {
            return badgeNumber.description
        }
    }
    
    public var badgeEdgeInsets: UIEdgeInsets? = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: -3) {
        didSet {
            setupBadgeViewWithString(badgeText: badgeString)
        }
    }
    
    public var badgeBackgroundColor = UIColor.accentColor {
        didSet {
            badgeLabel.backgroundColor = badgeBackgroundColor
        }
    }
    
    public var badgeTextColor = UIColor.white {
        didSet {
            badgeLabel.textColor = badgeTextColor
        }
    }
    
    // MARK: - Initialize
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupBadgeViewWithString(badgeText: "")
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupBadgeViewWithString(badgeText: "")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if needUpdateLayout {
            setupBadgeViewWithString(badgeText: badgeString)
            needUpdateLayout = false
        }
    }

    // MARK: - Helper Methods
    
    private func setupBadgeViewWithString(badgeText: String?) {
        badgeLabel.clipsToBounds = true
        badgeLabel.text = badgeText
        badgeLabel.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        badgeLabel.textAlignment = .center
        badgeLabel.sizeToFit()
        let badgeSize = badgeLabel.frame.size
        
        let height = max(14, Double(badgeSize.height) + 0.0)
        let width = max(height, Double(badgeSize.width) + 5.0)
        var vertical: Double?, horizontal: Double?
        
        if let badgeInset = self.badgeEdgeInsets {
            vertical = Double(badgeInset.top) - Double(badgeInset.bottom)
            horizontal = Double(badgeInset.left) - Double(badgeInset.right)
            
            let x = (Double(bounds.size.width) - 10 + horizontal!)
            let y = -(Double(badgeSize.height) / 2) - 10 + vertical!
            badgeLabel.frame = CGRect(x: x - 4, y: y + 3, width: width, height: height)
        } else {
            let x = self.frame.width - CGFloat((width / 2.0)) - 8
            let y = CGFloat(-(height / 2.0)) + 6
            badgeLabel.frame = CGRect(x: x, y: y, width: CGFloat(width), height: CGFloat(height))
        }
        
        setupBadgeStyle()
        addSubview(badgeLabel)
        
        if let text = badgeText {
            badgeLabel.isHidden = text != "" ? false : true
        } else {
            badgeLabel.isHidden = true
        }
    }
    
    private func setupBadgeStyle() {
        badgeLabel.textAlignment = .center
        badgeLabel.backgroundColor = badgeBackgroundColor
        badgeLabel.textColor = badgeTextColor
        badgeLabel.layer.cornerRadius = badgeLabel.bounds.size.height / 2
    }
}

