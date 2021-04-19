//
//  BannerFeedSectionController.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 3/28/21.
//

import UIKit
import IGListKit

class BannerFeedSectionController: ListSectionController{
    var banner: BannerFeedSectionModel?
    
    override init() {
        super.init()
        self.inset = UIEdgeInsets(top: Dimension.shared.mediumMargin_12,
                                  left: Dimension.shared.mediumMargin_12,
                                  bottom: 0,
                                  right: Dimension.shared.mediumMargin_12)
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext else {
          return .zero
        }
        
        let width = context.containerSize.width - ( Dimension.shared.mediumMargin_12 * 2 )
        return CGSize(width: width, height: 140)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: BannerCollectionViewCell.self, for: self, at: index)
        else {
            return UICollectionViewCell()
        }
        
        if let cell = cell as? HomeViewProtocol, let banner = self.banner {
            cell.configDataBanner?(banner: banner.bannerModel)
        }
        return cell
    }
    
    override func didUpdate(to object: Any) {
        self.banner = object as? BannerFeedSectionModel
    }
}