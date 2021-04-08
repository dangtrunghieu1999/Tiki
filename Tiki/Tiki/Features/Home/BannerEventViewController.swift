//
//  BannerEventViewController.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 3/28/21.
//

import UIKit
import IGListKit

class BannerEventViewController: ListSectionController {

    var event: BannerEventSectionModel?
    
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
        
        let width = context.containerSize.width
        return CGSize(width: width, height: 180)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: MenuCollectionViewCell.self, for: self, at: index)
        else {
            return UICollectionViewCell()
        }
        if let cell = cell as? MenuCollectionViewCellDelegate, let event = self.event {
            
        }
        return cell
    }
    
    override func didUpdate(to object: Any) {
        self.event = object as? BannerEventSectionModel
    }
    
}
