//
//  PersonalViewModel.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 3/14/21.
//

import UIKit

protocol PersonalViewModelDelegate: class {
    func reloadCollectionView()
    func didTapOnCellRow(type: PersonalType)
    func didTapOnSignIn()
}

class PersonalViewModel: NSObject {
    
    // MARK: - Properties
    
    weak var delegate: PersonalViewModelDelegate?
    
    func reloadData() {
        delegate?.reloadCollectionView()
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PersonalViewModel: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width
        let type = PersonalType(rawValue: indexPath.row)
        switch type {
        case .section1, .section2, .section3, .section4:
            return CGSize(width: width, height: 10)
        default:
            return CGSize(width: width, height: 50)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: 80.0)
    }
    
}

// MARK: - UICollectionViewDelegate

extension PersonalViewModel: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let type = Personal.cellObject[indexPath.row].cellType else { return }
        delegate?.didTapOnCellRow(type: type)
    }
}

// MARK: - UICollectionViewDataSource

extension PersonalViewModel: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return PersonalType.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return PersonalType.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: PersonCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.configCell(personal: Personal.cellObject[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header: PersonalHeaderCollectionReusableView =
                collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)
            header.delegate = self
            if UserManager.isLoggedIn() {
                let title   = UserManager.user?.fullName ?? ""
                header.configData(title: title)
            }
            return header
        } else {
            return UICollectionReusableView()
        }
    }
}

extension PersonalViewModel: PersonalHeaderCollectionViewDelegate {
    func tapOnSignIn() {
        delegate?.didTapOnSignIn()
    }
}
