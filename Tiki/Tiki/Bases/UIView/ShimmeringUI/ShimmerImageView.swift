//
//  ShimmerImageView.swift
//  ZoZoApp
//
//  Created by MACOS on 6/20/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

open class ShimmerImageView: BaseShimmerView {
    
    // MARK: - Variables
    
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    var imageContentMode: UIView.ContentMode = .scaleAspectFit {
        didSet {
            imageView.contentMode = imageContentMode
        }
    }
    
    // MARK: - UI Elements
    
    private lazy var imageView = UIImageView()
    
    // MARK: - LifeCycles
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    override public func initialize() {
        super.initialize()
        layoutImageView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadImage(by urlString: String?, defaultImage: UIImage?) {
        imageView.loadImage(by: urlString ?? "", defaultImage: defaultImage)
    }
    
    // MARK: - Override
    
    func startShimmer() {
        super.startShimmer()
        imageView.isHidden = true
    }
    
    func stopShimmer() {
        super.stopShimmer()
        imageView.isHidden = false
    }
    
    // MARK: - Layouts
    
    private func layoutImageView() {
        addSubview(imageView)
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius  = dimension.cornerRadiusSmall
        imageView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
}
