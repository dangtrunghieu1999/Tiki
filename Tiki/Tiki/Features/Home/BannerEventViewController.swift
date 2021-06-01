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
        return 2
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext else {
            return .zero
        }
        
        let width = context.containerSize.width
        
        if index == 0 {
            return CGSize(width: width, height: Dimension.shared.largeMargin_120)
        } else {
            return CGSize(width: width, height: Dimension.shared.mediumViewHeight)
        }
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        if index == 0 {
            guard let cell = collectionContext?.dequeueReusableCell(of: EventCollectionViewCell.self,
                                                                    for: self,
                                                                    at: index)
            else {
                return UICollectionViewCell()
            }
            if let cell = cell as? HomeViewProtocol, let event = self.event {
                cell.configDataEvent?(event: event)
            }
            return cell
        } else {
            guard let cell = collectionContext?.dequeueReusableCell(of: SecparatorCollectionViewCell.self,
                                                                    for: self,
                                                                    at: index) else {
                return UICollectionViewCell()
            }
            return cell
        }
    }
    
    override func didUpdate(to object: Any) {
        self.event = object as? BannerEventSectionModel
    }
}
