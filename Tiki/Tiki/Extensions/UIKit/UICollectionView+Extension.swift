//
//  UICollectionView+Extension.swift
//  Ecom
//
//  Created by Nguyen Dinh Trieu on 3/22/19.
//  Copyright © 2019 Minh Tri. All rights reserved.
//

import UIKit

public protocol Reusable {
    static var reuseIdentifier: String { get }
    static var nib: UINib? { get }
}

public extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
    
    static var nib: UINib? {
        return UINib(nibName: reuseIdentifier.self, bundle: nil)
    }
}

public extension UICollectionView {
    func registerReusableNibCell<T: UICollectionViewCell>(_: T.Type) where T: Reusable {
        register(T.nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func registerReusableCell<T: UICollectionViewCell>(_: T.Type) where T: Reusable {
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func registerReusableSupplementaryView<T: UICollectionReusableView>(_ T: T.Type,
                                                                        forSupplementaryViewOfKind kind: String)
        where T: Reusable {
            register(T.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T where T: Reusable {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else { return T() }
        return cell
    }
    
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind: String, for indexPath: IndexPath) -> T where T: Reusable {
        guard let cell = dequeueReusableSupplementaryView(ofKind: ofKind, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else { return T() }
        return cell
    }
    
    func safeReloadData() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
}

// MARK: - Safe Execute

extension UICollectionView {
    func safeSelectItem(at indexPath: IndexPath?, animated: Bool, scrollPosition: UICollectionView.ScrollPosition) {
        guard let indexPath = indexPath else { return }
        guard indexPath.section < numberOfSections else { return }
        guard indexPath.row < numberOfItems(inSection: indexPath.section) else { return }
        selectItem(at: indexPath, animated: animated, scrollPosition: scrollPosition)
    }
}

// MARK: - Tag layouts

extension UICollectionView {
    static func estimateHeightFortagLayout(_ width: CGFloat, datas: [String]) {
        let layout = UICollectionViewFlowLayout()
    }
}
