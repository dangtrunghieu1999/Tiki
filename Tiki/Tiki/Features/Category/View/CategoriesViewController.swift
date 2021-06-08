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
    var selectIndex: Int       = 0
    fileprivate lazy var categories: [Categories]?     = []
    fileprivate lazy var subCategories: [Categories]?  = []
    
    
    // MARK: - UI Elements
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerReusableCell(CategoriesTableViewCell.self)
        return tableView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing      = dimension.normalMargin
        layout.minimumInteritemSpacing = dimension.normalMargin
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate   = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.layer.cornerRadius = dimension.conerRadiusMedium
        collectionView.layer.masksToBounds = true
        collectionView.registerReusableCell(ImageCollectionViewCell.self)
        collectionView.contentInset = UIEdgeInsets(top: dimension.normalMargin,
                                                   left: dimension.normalMargin,
                                                   bottom: 0,
                                                   right: dimension.normalMargin)
        return collectionView
    }()
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = TextManager.category
        layoutTableView()
        layoutCollectionView()
        self.view.backgroundColor = UIColor.separator
        self.requestAPIMenu()
    }
    
    func requestAPIMenu() {
        let endPoint = HomeEndPoint.getCateogoryMenu
        self.showLoading()
        APIService.request(endPoint: endPoint) { [weak self] (apiResponse) in
            guard let self = self else { return }
            self.hideLoading()
            self.categories = apiResponse.toArray([Categories.self])
            self.subCategories = self.categories?[self.selectIndex].subCategorys
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
        self.tableView.reloadData()
    }
    
    // MARK: Layout
    
    private func layoutTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left
                .equalToSuperview()
            if #available(iOS 11, *) {
                make.top
                    .equalTo(view.safeAreaLayoutGuide)
                    .offset(dimension.mediumMargin)
            } else {
                make.top
                    .equalTo(topLayoutGuide.snp.bottom)
                    .offset(dimension.mediumMargin)
            }
            make.bottom
                .equalToSuperview()
                .offset(dimension.smallMargin)
            make.width
                .equalTo(100)
        }
    }
    
    private func layoutCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top
                .equalTo(tableView)
            make.left
                .equalTo(tableView.snp.right)
                .offset(dimension.mediumMargin)
            make.right
                .equalToSuperview()
                .inset(dimension.mediumMargin)
            make.bottom
                .equalToSuperview()
                .offset(dimension.smallMargin)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CategoriesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - dimension.normalMargin * 3) / 2
        return CGSize(width: width, height: width)
    }
}

extension CategoriesViewController: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDataSource

extension CategoriesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return self.subCategories?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ImageCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.configCell(subCategories?[indexPath.row].image)
        return cell
    }
}

extension CategoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        selectIndex = indexPath.row
        self.subCategories = self.categories?[selectIndex].subCategorys
        tableView.reloadData()
        self.collectionView.reloadData()
    }
}

extension CategoriesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CategoriesTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.backgroundColor = .clear
        if  let category = categories?[safe: indexPath.row] {
            cell.configCell(image: category.image,
                            title: category.name)
        }
        cell.isSelected = (indexPath.row == selectIndex)
        return cell
    }
}
