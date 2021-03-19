//
//  PersonalViewModel.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 3/14/21.
//

import UIKit

protocol PersonalViewModelDelegate: class {
    func reloadCollectionView()
    func itemSelected(at: IndexPath)
}

class PersonalViewModel: NSObject {
        
    // MARK: - Properties
    
    var personal = Personal()
    
    weak var delegate: PersonalViewModelDelegate?
    
    func reloadData() {
        delegate?.reloadCollectionView()
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PersonalViewModel: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
                            UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width
        let type = PersonalType(rawValue: indexPath.section)
        switch type {
        case .welcome:
            return CGSize(width: width, height: 80)
        case .managerOrder:
            return CGSize(width: width, height: 420)
        case .address:
            return CGSize(width: width, height: 140)
        case .managerProduct:
            return CGSize(width: width, height: 210)
        default:
            return CGSize(width: width, height: 50)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
                            UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: 10.0)
    }
}

// MARK: - UICollectionViewDelegate

extension PersonalViewModel: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.itemSelected(at: indexPath)
    }
}

// MARK: - UICollectionViewDataSource

extension PersonalViewModel: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return PersonalType.numberOfSection()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = PersonalType(rawValue: indexPath.section)
        switch type {
        case .welcome:
            let cell: PersonCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            return cell
        case .managerOrder:
            let cell: InfomationCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.parseDataString(data: personal.managerOrder)
            return cell
        case .address:
            let cell: InfomationCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.parseDataString(data: personal.address)
            return cell
        case .managerProduct:
            let cell: InfomationCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.parseDataString(data: personal.managerProduct)
            return cell
        default:
            let cell: LogoutCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footer: BaseCollectionViewHeaderFooterCell =
                collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)
            return footer
        } else {
            return UICollectionReusableView()
        }
    }
    
}
