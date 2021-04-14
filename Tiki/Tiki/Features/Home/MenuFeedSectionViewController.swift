//
//  MenuFeedViewController.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 3/28/21.
//

import UIKit
import IGListKit

class MenuFeedSectionViewController: ListSectionController{

    var menu: MenuFeedSectionModel?
    
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
        if let cell = cell as? HomeViewProtocol, let menu = self.menu {
            cell.configDataMenu?(menu: menu.menuModel)
        }
        return cell
    }
    
    override func didUpdate(to object: Any) {
        self.menu = object as? MenuFeedSectionModel
    }
    
}
