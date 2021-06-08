//
//  CategoryViewController.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 3/13/21.
//

import UIKit
import IGListKit
import SwiftyJSON

class CategoriesViewController: BaseViewController {
    
    // MARK: - Variables
    fileprivate lazy var viewModel = CategoriesViewModel()
    fileprivate lazy var categories: [Categories] = []
    
    // MARK: - UI Elements

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate   = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.registerReusableCell(CategoriesCollectionViewCell.self)
        collectionView
            .registerReusableSupplementaryView(TitleCollectionViewHeaderCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        
        return collectionView
    }()
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = TextManager.category
        layoutCollectionView()
        requestAPIMenu()
    }
    
    func requestAPIMenu() {
        let endPoint = HomeEndPoint.getCateogoryMenu
        
        APIService.request(endPoint: endPoint) { [weak self] (apiResponse) in
            guard let self = self else { return }
            self.categories = apiResponse.toArray([Categories.self])
            self.reloadDataWhenFinishLoadAPI()
        } onFailure: {  [weak self] (apiError) in
            self?.reloadDataWhenFinishLoadAPI()
            AlertManager.shared.show(message:
                                        TextManager.errorMessage.localized())
        } onRequestFail: {
            self.reloadDataWhenFinishLoadAPI()
            AlertManager.shared.show(message:
                                        TextManager.errorMessage.localized())
        }

    }
    
    private func reloadDataWhenFinishLoadAPI() {
        self.isRequestingAPI = false
        self.collectionView.reloadData()
    }
    
    // MARK: Layout
    
    private func layoutCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            if #available(iOS 11, *) {
                make.top
                    .equalTo(view.safeAreaLayoutGuide)
            } else {
                make.top
                    .equalTo(topLayoutGuide.snp.bottom)
            }
            
            make.left
                .right
                .bottom
                .equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CategoriesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ScreenSize.SCREEN_WIDTH, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: ScreenSize.SCREEN_WIDTH, height: 40)
    }
}

extension CategoriesViewController: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDataSource

extension CategoriesViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CategoriesCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        if !isRequestingAPI {
            cell.configCell(categories: categories[indexPath.section].subCategorys)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header: TitleCollectionViewHeaderCell =
                collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, for: indexPath)
            if !isRequestingAPI {
                header.title = self.categories[indexPath.row].name
            }
            return header
        } else {
            return UICollectionReusableView()
        }
    }
}
