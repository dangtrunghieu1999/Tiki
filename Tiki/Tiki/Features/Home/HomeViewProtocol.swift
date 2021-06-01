//
//  HomeViewProtocol.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 4/13/21.
//

import UIKit

@objc protocol HomeViewProtocol: AnyObject {
    @objc optional func configDataBanner(banner: BannerFeedSectionModel?)
    @objc optional func configDataMenu(menu: MenuFeedSectionModel?)
    @objc optional func configDataEvent(event: BannerEventSectionModel?)
    @objc optional func configDataProductRecommend(product: [Product]?, at index: Int)
    @objc optional func configTitleHeader(title: String?)
}
