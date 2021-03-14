//
//  PersonalViewController.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 3/13/21.
//

import UIKit

class PersonalViewController: BaseViewController {

    // MARK: - Variables
    
    // MARK: - UI Elements
    
    fileprivate lazy var personalCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()
    
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutPersonalCollectionView()
    }
    
    // MARK: - Helper Method
    
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
                .offset(-Dimension.shared.largeMargin_56)
        }
    }

}

// MARK: - UICollectionViewDelegateFlowLayout
extension PersonalViewController: UICollectionViewDelegateFlowLayout {
    
}

// MARK: - UICollectionViewDataSource

extension PersonalViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PersonCollectCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        return cell
    }
}
