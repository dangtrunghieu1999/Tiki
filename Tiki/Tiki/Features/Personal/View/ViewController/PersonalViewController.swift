//
//  PersonalViewController.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 3/13/21.
//

import UIKit

class PersonalViewController: BaseViewController {
    
    // MARK: - Variables
    
    fileprivate lazy var personalViewModel: PersonalViewModel = {
        let personal = PersonalViewModel()
        return personal
    }()
    
    // MARK: - UI Elements
    
    fileprivate lazy var personalCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = personalViewModel
        collectionView.dataSource = personalViewModel
        collectionView.backgroundColor = UIColor.separator
        return collectionView
    }()
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutPersonalCollectionView()
        registerCollectionView()
        personalViewModel.reloadData()
        personalViewModel.delegate = self
    }
    
    // MARK: - Helper Method
    
    func registerCollectionView() {
        self.personalCollectionView.registerReusableCell(PersonCollectionViewCell.self)
        self.personalCollectionView
            .registerReusableSupplementaryView(PersonalHeaderCollectionReusableView.self,
                                               forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
    }
    
    // MARK: - GET API
    
    // MARK: - Layout
    
    private func layoutPersonalCollectionView() {
        view.addSubview(personalCollectionView)
        personalCollectionView.snp.makeConstraints { (make) in
            if #available(iOS 11, *) {
                make.top.equalTo(view.safeAreaLayoutGuide)
                    .offset(Dimension.shared.smallMargin)
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom)
                    .offset(Dimension.shared.smallMargin)
            }
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

extension PersonalViewController: PersonalViewModelDelegate {
    
    func reloadCollectionView() {
        DispatchQueue.main.async {
            self.personalCollectionView.reloadData()
        }
    }
}
