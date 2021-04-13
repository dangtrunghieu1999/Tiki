//
//  InfomationSectionController.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 4/13/21.
//

import UIKit
import IGListKit

class InfomationSectionController: ListSectionController {
    var infomation: InfomationSectionModel?
    
    override init() {
        super.init()
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
        guard let cell = collectionContext?.dequeueReusableCell(of: InfomationProductCollectionViewCell.self, for: self, at: index)
        else {
            return UICollectionViewCell()
        }
        
//        if let cell = cell as? BannerCollectionViewDelegate, let infomation = self.infomation {
//            cell.configData(banner: banner.bannerModel ?? BannerModel())
//        }
        
       
        return cell
    }
    
    override func didUpdate(to object: Any) {
        self.infomation = object as? InfomationSectionModel
    }
}
