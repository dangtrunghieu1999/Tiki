//
//  CategoryViewController.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 3/13/21.
//

import UIKit

class CategoryViewController: BaseViewController {
    
    // MARK: - Variables
    
    
    // MARK: - Properties
    
    private let viewModel: CategoryViewModel = {
        let viewModel = CategoryViewModel()
        return viewModel
    }()
    
    // MARK: - UI Elements
    
    private let containerView: BaseView = {
        let view = BaseView()
        view.layer.cornerRadius = 5
        return view
    }()
    
    private let titleRecommendLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.myCategory
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .semibold)
        return label
    }()
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0.25
        layout.minimumInteritemSpacing = 0.25
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.registerReusableCell(CategoryCollectionViewCell.self)
        return collectionView
    }()
    
    // MARK: - ViewLifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = TextManager.category
        layoutContainerView()
        layoutTitleRecommendLabel()
        layoutCollectionView()
    }
    
    // MARK: - Helper Method
    
    // MARK: - Public Method
    
    // MARK: - Layout
    
    private func layoutContainerView() {
        view.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            if #available(iOS 11, *) {
                make.top.equalTo(view.safeAreaLayoutGuide)
                    .offset(Dimension.shared.normalMargin)
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom)
                    .offset(Dimension.shared.normalMargin)
            }
            make.left.equalToSuperview().offset(Dimension.shared.normalMargin)
            make.right.equalToSuperview().offset(-Dimension.shared.normalMargin)
            make.bottom.equalToSuperview()
        }
    }
    
    private func layoutTitleRecommendLabel() {
        containerView.addSubview(titleRecommendLabel)
        titleRecommendLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Dimension.shared.mediumMargin)
            make.left.equalToSuperview()
        }
    }
    
    private func layoutCollectionView() {
        containerView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(titleRecommendLabel.snp.bottom).offset(Dimension.shared.normalMargin)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
}

extension CategoryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 0.25 * 2) / 3
        return CGSize(width: width, height: 120)
    }
}

extension CategoryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CategoryCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.configCell(image: viewModel.images[indexPath.row], title: viewModel.titles[indexPath.row])
        return cell
    }
}

extension ProductByCateogryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ProductByCateogryViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}



