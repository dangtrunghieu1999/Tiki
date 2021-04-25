//
//  UserPermissionViewController.swift
//  ZoZoApp
//
//  Created by LAP12852 on 8/4/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

protocol UserPermissionViewControllerDelegate: class {
    func didUpdateRole()
}

class UserPermissionViewController: BaseViewController {

    // MARK: - Variables
    
    weak var delegate: UserPermissionViewControllerDelegate?
    
    fileprivate var shopRoles   = [ShopRole]()
    fileprivate var shopId      = 0
    fileprivate var user        = User()
    
    // MARK: - UI Elements
    
    fileprivate let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    fileprivate lazy var permissionCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerReusableCell(SelectPermissionCollectionViewCell.self)
        return collectionView
    }()
    
    // MARK: - LifeCycles
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = TextManager.selectPermissionUser.localized()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutContainerView()
        layoutPermissionCollectionView()
    }
    
    deinit {
        delegate?.didUpdateRole()
    }
    
    // MARK: - Public Methods
    
    func configureData(user: User, shopId: Int) {
        showLoading()
        self.user = user
        self.shopId = shopId
        let endPoint = ShopEndPoint.getAllShopRolesByUserId(params: ["userId": user.id, "shopId": shopId])
        
        APIService.request(endPoint: endPoint, onSuccess: { [weak self] (apiResponse) in
            guard let self = self else { return }
            self.hideLoading()
            self.shopRoles = apiResponse.toArray([ShopRole.self])
            self.permissionCollectionView.reloadData()
            
            }, onFailure: { [weak self] (apiError) in
                guard let self = self else { return }
                self.hideLoading()
        }) { [weak self] in
            guard let self = self else { return }
            self.hideLoading()
        }
    }
    
    func configureData(userRole: UserRole, shopId: Int) {
        self.shopId = shopId
        self.shopRoles = userRole.shopRoles
        self.user = userRole.user
        self.permissionCollectionView.reloadData()
    }
    
    func configureTitle(title: String) {
        navigationItem.title = title
    }
    
    // MARK: - UI Actions
    
    // MARK: - Helper Methods
    
    // MARK: - Layout
    
    private func layoutContainerView() {
        view.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Dimension.shared.largeMargin)
            make.left.right.bottom.equalToSuperview().offset(-Dimension.shared.smallMargin)
        }
    }
    
    private func layoutPermissionCollectionView() {
        containerView.addSubview(permissionCollectionView)
        permissionCollectionView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Dimension.shared.normalMargin)
            make.bottom.right.equalToSuperview().offset(-Dimension.shared.normalMargin)
            make.top.equalToSuperview().offset(Dimension.shared.largeMargin)
        }
    }
    
}

// MARK: - UICollectionViewDelegate

extension UserPermissionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let role = shopRoles[safe: indexPath.row] else { return }
        let params: [String: Any] = ["ShopId": shopId,
                                     "UserId": user.id,
                                     "ShopRoleId": role.shopRoleId,
                                     "HasRole": (role.hasRole ? 0 : 1)]
        
        let endPoint = ShopEndPoint.updateShopRole(params: params)
        APIService.request(endPoint: endPoint, onSuccess: { [weak self] (apiResponse) in
            guard let self = self else { return }
            role.hasRole = !role.hasRole
            self.permissionCollectionView.reloadData()
        }, onFailure: { (apiError) in
            AlertManager.shared.showToast()
        }) {
            AlertManager.shared.showToast()
        }
    }
}

// MARK: - UICollectionViewDataSource

extension UserPermissionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shopRoles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SelectPermissionCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.configureData(shopRoles[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension UserPermissionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
}
