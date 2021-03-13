//
//  ContentDynamicLayout.swift
//  Ecom
//
//  Created by MACOS on 3/26/19.
//  Copyright © 2019 Minh Tri. All rights reserved.
//

import UIKit

public protocol ContentDynamicLayoutDelegate: class {
    func cellSize(indexPath: IndexPath) -> CGSize
    func onContentSizeChange()
}

public enum DynamicContentAlign {
    case left
    case right
}

public struct ItemsPadding {
    public let horizontal: CGFloat
    public let vertical: CGFloat
    
    public init(horizontal: CGFloat = 0, vertical: CGFloat = 0) {
        self.horizontal = horizontal
        self.vertical = vertical
    }
    
    static var zero: ItemsPadding {
        return ItemsPadding()
    }
}

public class ContentDynamicLayout: UICollectionViewFlowLayout {
    public private(set) var cachedLayoutAttributes = [UICollectionViewLayoutAttributes]()
    
    public var contentAlign: DynamicContentAlign = .left
    public var contentPadding: ItemsPadding = .zero
    public var cellsPadding: ItemsPadding = .zero
    public var contentSize: CGSize = .zero
    public weak var delegate: ContentDynamicLayoutDelegate?
    
    override public func prepare() {
        super.prepare()
        
        cachedLayoutAttributes.removeAll()
        calculateCollectionViewCellsFrames()
    }
    
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes in cachedLayoutAttributes {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    
    override public func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cachedLayoutAttributes.first { attributes -> Bool in
            return attributes.indexPath == indexPath
        }
    }
    
    public func calculateCollectionViewCellsFrames() {
    }
    
    func addCachedLayoutAttributes(attributes: UICollectionViewLayoutAttributes) {
        cachedLayoutAttributes.append(attributes)
    }
    
    override public var collectionViewContentSize: CGSize {
        return contentSize
    }
}

