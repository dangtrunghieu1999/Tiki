//
//  PersonalViewAdapter.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 3/14/21.
//

import UIKit



class PersonalViewAdapter: NSObject {

    weak var delegate: PersonalViewProtocol?
    
    init(delegate: PersonalViewProtocol) {
        self.delegate = delegate
    }
    
}

// MARK: -

extension PersonalViewAdapter: UICollectionViewDelegateFlowLayout {
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
//                            UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        
//    }
}

extension PersonalViewAdapter: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.itemSelected(at: indexPath)
    }
}


extension PersonalViewAdapter: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return delegate?.numberOfSections() ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return delegate?.numberOfItemSection() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PersonCollectCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        return cell
    }
    
}
