//
//  WaitingReviewViewController.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 5/16/21.
//

import UIKit

class WaitingReviewViewController: BaseViewController {

    // MARK: - Variables
    
    fileprivate lazy var reviews: [Review] = []
    
    // MARK: - UI Element
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = Dimension.shared.mediumMargin
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.tableBackground
        collectionView.delegate =  self
        collectionView.dataSource = self
        collectionView.registerReusableCell(ReviewCollectionViewCell.self)
        collectionView.registerReusableCell(EmptyCollectionViewCell.self)
        return collectionView
    }()
    
    // MARK: - ViewLife Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutCollectionView()
    }
    
    private func layoutCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            if #available(iOS 11, *) {
                make.top.equalTo(view.safeAreaLayoutGuide)
                    .offset(Dimension.shared.mediumMargin)
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom)
                    .offset(Dimension.shared.mediumMargin)
            }
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

extension WaitingReviewViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if reviews.isEmpty {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        } else {
            return CGSize(width: collectionView.frame.width, height: 100)
        }
    }
}

extension WaitingReviewViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if reviews.isEmpty {
            return 1
        } else {
            return 5
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if reviews.isEmpty {
            let cell: EmptyCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.image = UIImage(named: "temp2")
            cell.message = "Chưa có đánh giá nào"
            return cell
        } else {
            let cell: ReviewCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            return cell
        }
    }
}
