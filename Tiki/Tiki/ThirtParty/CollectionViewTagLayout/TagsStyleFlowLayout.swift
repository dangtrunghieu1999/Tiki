//
//  TagsStyleFlowLayout.swift
//  Ecom
//
//  Created by MACOS on 3/26/19.
//  Copyright © 2019 Minh Tri. All rights reserved.
//

import UIKit

public class TagsStyleFlowLayout: ContentDynamicLayout {
    override public func calculateCollectionViewCellsFrames() {
        guard let contentCollectionView = collectionView, delegate != nil else {
            return
        }
        
        contentSize.width = contentCollectionView.frame.size.width
        
        let leftPadding = 0 + contentPadding.horizontal
        let rightPadding = contentCollectionView.frame.size.width - contentPadding.horizontal
        
        var leftMargin: CGFloat = (contentAlign == .left) ? leftPadding : rightPadding
        
        var topMargin: CGFloat = contentPadding.vertical
        
        let sectionsCount = contentCollectionView.numberOfSections
        
        for section in 0..<sectionsCount {
            for item in 0 ..< contentCollectionView.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
                attributes.frame.size = delegate!.cellSize(indexPath: indexPath)
                
                let currentCellWidth = attributes.frame.size.width
                let currentCellHeight = attributes.frame.size.height
                
                if contentAlign == .left {
                    if leftMargin + currentCellWidth + cellsPadding.vertical > contentCollectionView.frame.size.width {
                        leftMargin = contentPadding.horizontal
                        topMargin += attributes.frame.size.height + cellsPadding.vertical
                    }
                    
                    attributes.frame.origin.x = leftMargin
                    attributes.frame.origin.y = topMargin
                    
                    leftMargin += currentCellWidth + cellsPadding.horizontal
                    
                } else if contentAlign == .right {
                    if leftMargin - currentCellWidth - cellsPadding.horizontal < 0 {
                        leftMargin = contentCollectionView.frame.size.width - contentPadding.horizontal
                        topMargin += attributes.frame.size.height + cellsPadding.vertical
                    }
                    
                    attributes.frame.origin.x = leftMargin - currentCellWidth
                    attributes.frame.origin.y = topMargin
                    
                    leftMargin -= currentCellWidth + cellsPadding.horizontal
                }
                
                addCachedLayoutAttributes(attributes: attributes)
                
                contentSize.height = topMargin + currentCellHeight + contentPadding.vertical
                
                if item == contentCollectionView.numberOfItems(inSection: section) - 1 {
                    leftMargin = contentPadding.horizontal
                    topMargin += attributes.frame.size.height + cellsPadding.vertical
                }
            }
        }
        
        delegate?.onContentSizeChange()
    }
    
    func caculateHeight(collectionViewWidth: CGFloat, datas: [String]) -> CGFloat {
        contentSize.width = collectionViewWidth
        
        let leftPadding = 0 + contentPadding.horizontal
        let rightPadding = collectionViewWidth - contentPadding.horizontal
        
        var leftMargin: CGFloat = (contentAlign == .left) ? leftPadding : rightPadding
        
        var topMargin: CGFloat = contentPadding.vertical
        
        for item in 0 ..< datas.count {
            let indexPath = IndexPath(item: item, section: 1)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            attributes.frame.size = TagCollectionViewCell.estimateCellSize(text: datas[item])
            
            let currentCellWidth = attributes.frame.size.width
            let currentCellHeight = attributes.frame.size.height
            
            if contentAlign == .left {
                if leftMargin + currentCellWidth + cellsPadding.vertical > collectionViewWidth {
                    leftMargin = contentPadding.horizontal
                    topMargin += attributes.frame.size.height + cellsPadding.vertical
                }
                
                attributes.frame.origin.x = leftMargin
                attributes.frame.origin.y = topMargin
                
                leftMargin += currentCellWidth + cellsPadding.horizontal
                
            } else if contentAlign == .right {
                if leftMargin - currentCellWidth - cellsPadding.horizontal < 0 {
                    leftMargin = collectionViewWidth - contentPadding.horizontal
                    topMargin += attributes.frame.size.height + cellsPadding.vertical
                }
                
                attributes.frame.origin.x = leftMargin - currentCellWidth
                attributes.frame.origin.y = topMargin
                
                leftMargin -= currentCellWidth + cellsPadding.horizontal
            }
            
            
            contentSize.height = topMargin + currentCellHeight + contentPadding.vertical
            
            if item == datas.count - 1 {
                leftMargin = contentPadding.horizontal
                topMargin += attributes.frame.size.height + cellsPadding.vertical
            }
        }
        
        return contentSize.height + 16
    }
    
}

