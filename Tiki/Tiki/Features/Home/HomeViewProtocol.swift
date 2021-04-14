//
//  HomeViewProtocol.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 4/13/21.
//

import UIKit

@objc protocol HomeViewProtocol: AnyObject {
    @objc optional func configDataBanner(banner: BannerModel?)
    @objc optional func configDataMenu(menu: MenuModel?)
    @objc optional func configDataEvent(event: EventModel?)
    @objc optional func configDataProductRecommend(product: ProductRecommendModel?, at index: Int)
    
}
