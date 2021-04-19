//
//  ProductRecommendViewController.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 3/28/21.
//

import UIKit
import IGListKit

protocol ProductRecommendDelagte: class {
    func tapProductDetail(title: String?)
}

class ProductRecommendViewController: ListSectionController, ListSupplementaryViewSource {
    var productSection: ProductRecommendSectionModel?
    weak var delegate: ProductRecommendDelagte?
    
    override init() {
        super.init()
        supplementaryViewSource = self
    }
    
    override func numberOfItems() -> Int {
        return productSection?.productRecommend?.list.count ?? 0
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        let width = (ScreenSize.SCREEN_WIDTH - 1) / 2
        return CGSize(width: width, height: 320)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        
        guard let cell = collectionContext?.dequeueReusableCell(of: ProductRecommendCollectionViewCell.self, for: self, at: index)
        else {
            return UICollectionViewCell()
        }
        
        if let cell = cell as? HomeViewProtocol, let productSection = self.productSection {
            cell.configDataProductRecommend?(product: productSection.productRecommend?.list, at: index)
        }
        
        return cell
    }
    
    override func didUpdate(to object: Any) {
        self.productSection = object as? ProductRecommendSectionModel
    }
    
    // MARK: - ListSupplementaryViewSource
    
    func sizeForSupplementaryView(ofKind elementKind: String, at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 50)
    }
    
    func supportedElementKinds() -> [String] {
        return [UICollectionView.elementKindSectionHeader]
    }
    
    func viewForSupplementaryElement(ofKind elementKind: String, at index: Int) -> UICollectionReusableView {
        
        if elementKind == UICollectionView.elementKindSectionHeader {
            guard let header = collectionContext?.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                                   for: self,
                                                                                   class: HeaderTitleCollectionReusableView.self, at: index) else {
                return UICollectionReusableView()
            }
            
            if let header = header as? HomeViewProtocol, let productSection = self.productSection {
                header.configTitleHeader?(title: productSection.productRecommend?.title)
            }
            
            return header
        } else {
            return UICollectionReusableView()
        }
    }
    
    override func didSelectItem(at index: Int) {
        self.delegate?.tapProductDetail(title: productSection?.productRecommend?.title)
    }
}
