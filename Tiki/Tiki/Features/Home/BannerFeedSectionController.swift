//
//  BannerFeedSectionController.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 3/28/21.
//

import UIKit
import IGListKit

class BannerFeedSectionController: ListSectionController{
    var banner: BannerModel?
    
    override init() {
        super.init()
    }
    
    override func numberOfItems() -> Int {
        return banner?.list.count ?? 0
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext else {
          return .zero
        }
        
        let width = context.containerSize.width
        return CGSize(width: width, height: 50)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        return BannerCollectionViewCell()
    }
    
    override func didUpdate(to object: Any) {
        self.banner = object as? BannerModel
    }
}
