//
//  ZButton.swift
//  ZoZoApp
//
//  Created by LAP12852 on 9/2/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class ZButton: BaseView {
    
    // MARK: - Variables
    
    private var imageWidth:    CGFloat           = 20
    private var title:          String           = ""
    private let titleFont                        = UIFont.systemFont(ofSize: 16)
    
    // MARK: - UI Elements
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode =  .scaleAspectFit
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.like.localized()
        label.textAlignment = .center
        label.textColor = UIColor.bodyText.withAlphaComponent(0.8)
        label.font = titleFont
        return label
    }()
    
    // MARK: - View LifeCycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let titleWidth = title.width(withConstrainedHeight: imageWidth, font: titleFont)
        let titleMarginLeft: CGFloat = 8
        let imageX = (frame.width - imageWidth - titleWidth - titleMarginLeft) / 2
        let imageY = (frame.height - imageWidth) / 2
        
        imageView.frame = CGRect(x: imageX, y: imageY, width: imageWidth, height: imageWidth)
        addSubview(imageView)
        
        titleLabel.frame = CGRect(x: imageX + imageWidth + titleMarginLeft,
                                  y: imageY,
                                  width: titleWidth,
                                  height: imageWidth)
        addSubview(titleLabel)
    }
    
    init(with image: UIImage?, title: String, imageWidth: CGFloat = 20) {
        super.init(frame: .zero)
        self.imageWidth      = imageWidth
        self.title           = title
        self.titleLabel.text = title
        self.imageView.image = image
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
