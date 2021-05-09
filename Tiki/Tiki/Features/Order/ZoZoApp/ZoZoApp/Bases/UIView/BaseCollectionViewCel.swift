//
//  BaseCollectionView.swift
//  Tweeter
//
//  Created by Nguyen Dinh Trieu on 3/8/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit
import Shimmer
import IGListKit

open class BaseCollectionViewCell: UICollectionViewCell, Reusable {
    
    // MARK: - UI Elements
    
    // MARKL - LifeCycles
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefault()
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupDefault()
        initialize()
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        setupDefault()
        initialize()
    }
    
    // MARK: - Override
    
    // MARK: - Public
    
    public func initialize() {}
    
    // MARK: - Layouts
    
    private func setupDefault() {
        backgroundColor = UIColor.white
    }
   
}

// MARK: - ListBindable

extension BaseCollectionViewCell: ListBindable {
    public func bindViewModel(_ viewModel: Any) {}
}
