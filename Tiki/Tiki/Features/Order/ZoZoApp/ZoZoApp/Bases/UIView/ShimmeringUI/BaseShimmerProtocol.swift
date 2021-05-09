//
//  BaseShimmerProtocol.swift
//  ZoZoApp
//
//  Created by MACOS on 6/15/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import Shimmer

protocol BaseShimmerProtocol: class {
    
    /// This view to show Shimmerting
    var shimmeringView: FBShimmeringView { get set }
    
    /// ContentView of ShimmeringView
    var shimmerContentView: UIView { get set }
    
    /**
     This view will show when start shimmer
     
     It will cover all subViews for users do not see any view when shimmering is animating
     */
    var backgroundShimmerView: UIView { get set }
    
    /**
     Start shimmer animation
     
     This methods will add shimmer view to current view and trigger start nimation. This method will be setup default action
     
     - Note: Must call after setup all layouts
     */
    func startShimmer()
    
    /**
     Stop shimmer animation
     
     Call this method to stop animation and remove all views support shimmer. This method will be setup default action
     */
    func stopShimmer()
    
    /// Must use this method to layout background shimmerview
    func layoutBackgroundShimmerView()
    
    /// Must use this method to layout shimmerview
    func layoutShimeringView()
}

extension BaseShimmerProtocol {
    func startShimmer() {
        layoutBackgroundShimmerView()
        layoutShimeringView()
        shimmeringView.isShimmering = true
    }
    
    func stopShimmer() {
        shimmeringView.isShimmering = false
        backgroundShimmerView.removeFromSuperview()
        shimmeringView.removeFromSuperview()
    }
}
