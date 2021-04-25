//
//  UserdecentralizationViewController.swift
//  ZoZoApp
//
//  Created by MACOS on 6/30/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class ShopRoleViewController: BaseViewController {
    
    // MARK: - Variables
    
    fileprivate var shopId: Int?
    fileprivate var userRoles: [UserRole]       = []
    fileprivate var searchResults: [User]       = []
    
    // MARK: - UI Elements
    
    private lazy var searchTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.placeholder = TextManager.signInUserNamePlaceHolder.localized()
        textField.leftImage = ImageManager.searchGray
        textField.layer.cornerRadius = Dimension.shared.defaultHeightTextField / 2
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 1.0
        textField.returnKeyType = .search
        textField.clearButtonMode = .whileEditing
        textField.layer.borderColor = UIColor.lightSeparator.cgColor
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldValueChange), for: .editingChanged)
        textField.addTarget(self, action: #selector(textFieldEndEditing), for: .editingDidEnd)
        textField.addTarget(self, action: #selector(touchInTextField), for: .editingDidBegin)
        return textField
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.tintColor = UIColor.background
        control.addTarget(self, action: #selector(getAPIListUserRole), for: .valueChanged)
        return control
    }()
    
    fileprivate lazy var listUserTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.white
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerReusableCell(SearchResultUserTableViewCell.self)
        tableView.registerReusableHeaderFooter(BaseTableViewHeaderFooter.self)
        return tableView
    }()
    
    fileprivate lazy var searchResultView: SearchResultView = {
        let view = SearchResultView()
        view.delegate = self
        view.isHidden = true
        return view
    }()
    
    // MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = TextManager.userDecentralization.localized()
        
        layoutSearchTextField()
        layoutListUserTableView()
        addEmptyView(message: TextManager.emptyUserHasRoleInShop, image: nil)
        layoutSearchResultView()
    }
    
    // MARK: - Public Methods
    
    func configureData(shopId: Int) {
        self.shopId = shopId
        getAPIListUserRole()
    }
    
    // MARK: - API Request
    
    @objc private func getAPIListUserRole() {
        if !isRequestingAPI {
            isRequestingAPI = true
            showLoading()
        }
        
        let endPoint = ShopEndPoint.getAllUserHasRoleInShop(params: ["ShopId":shopId ?? 0])
        APIService.request(endPoint: endPoint, onSuccess: { [weak self] (apiResponse) in
            guard let self = self else { return }
       
            self.hideLoading()
            self.userRoles = apiResponse.toArray([UserRole.self])
            self.listUserTableView.reloadData()
            self.checkShowEmptyView()
            
            }, onFailure: { [weak self] (apiError) in
                guard let self = self else { return }
                self.checkShowEmptyView()
                AlertManager.shared.showToast()
        }) {  [weak self] in
            guard let self = self else { return }
            self.checkShowEmptyView()
            AlertManager.shared.showToast()
        }
    }
    
    // MARK: - UI Actions
    
    @objc func touchInTextField() {
        if searchTextField.text != "" {
            searchResultView.isHidden = false
        }
    }
    
    @objc func textFieldValueChange() {
        guard let text = searchTextField.text, text != "" else {
            searchResultView.isHidden = true
            searchResults.removeAll()
            searchResultView.configureData(searchResults)
            return
        }
        
        guard text.isValidEmail || text.isPhoneNumber else {
            searchResultView.isHidden = true
            return
        }
    
        searchResultView.isHidden = false
        
        let endPoint = UserEndPoint.searchUser(params: ["EmailOrPhoneNumber": text])
        
        APIService.request(endPoint: endPoint, onSuccess: { [weak self] (apiResponse) in
            guard let self = self else { return }
            self.searchResults = apiResponse.toArray([User.self])
            self.searchResultView.configureData(self.searchResults)
        }, onFailure: { (apiError) in
            
        }) {
            
        }
    }
    
    @objc func textFieldEndEditing() {
        if searchTextField.text == nil || searchTextField.text == "" {
            searchResultView.isHidden = true
        }
    }
    
    // MARK: - Helper Methods
    
    fileprivate func confirmDeleteUser(_ user: User) {
        AlertManager.shared.showConfirmMessage(mesage: TextManager.confirmDeleteUser.localized()) { [weak self] (action) in
            guard let self = self else { return }
            let params: [String: Any] = ["ShopId": (self.shopId ?? 0), "UserId": user.id]
            let endPoint = ShopEndPoint.removeUserInShop(params: params)
            
            APIService.request(endPoint: endPoint, onSuccess: { (apiResponse) in
                if let index = self.userRoles.firstIndex(where: { $0.user.id == user.id }) {
                    self.userRoles.remove(at: index)
                    self.listUserTableView.reloadData()
                } else {
                    self.getAPIListUserRole()
                }
                self.checkShowEmptyView()
                AlertManager.shared.showToast(message: TextManager.deleteUserSuccess.localized())
                
            }, onFailure: { (apiError) in
                AlertManager.shared.showToast()
            }, onRequestFail: {
                AlertManager.shared.showToast()
            })
        }
    }
    
    private func checkShowEmptyView() {
        if userRoles.isEmpty {
            emptyView.isHidden = false
            listUserTableView.isHidden = true
        } else {
            emptyView.isHidden = true
            listUserTableView.isHidden = false
        }
    }
    
    // MARK: - Layout
    
    private func layoutSearchTextField() {
        view.addSubview(searchTextField)
        searchTextField.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Dimension.shared.normalMargin)
            make.right.equalToSuperview().offset(-Dimension.shared.normalMargin)
            make.height.equalTo(Dimension.shared.defaultHeightTextField)
            if #available(iOS 11, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Dimension.shared.normalMargin)
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom).offset(Dimension.shared.normalMargin)
            }
        }
    }
    
    private func layoutListUserTableView() {
        view.addSubview(listUserTableView)
        listUserTableView.snp.makeConstraints { (make) in
            make.width.bottom.centerX.equalToSuperview()
            make.top.equalTo(searchTextField.snp.bottom).offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutSearchResultView() {
        view.addSubview(searchResultView)
        searchResultView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(searchTextField.snp.bottom).offset(Dimension.shared.smallMargin)
        }
    }
    
}

// MARK: - UICollectionViewDelegate

extension ShopRoleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = UserPermissionViewController()
        viewController.delegate = self
        if let userRole = userRoles[safe: indexPath.section], let shopId = shopId {
            viewController.configureData(userRole: userRole, shopId: shopId)
        }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }
}

// MARK: - Editing TableViewCell

extension ShopRoleViewController {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return TextManager.delete.localized()
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        confirmDeleteUser(userRoles[indexPath.section].user)
    }
}

// MARK: - UICollectionViewDataSource

extension ShopRoleViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return userRoles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SearchResultUserTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        if let userRole = userRoles[safe: indexPath.section] {
            cell.configureData(user: userRole.user)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer: BaseTableViewHeaderFooter = tableView.dequeueReusableHeaderFooterView()
        footer.backgroundColor = UIColor.lightSeparator
        return footer
    }
}

// MARK: - SearchResultViewDelegate

extension ShopRoleViewController: SearchResultViewDelegate {
    func didSelectSearchResult(user: User) {
        let viewController = UserPermissionViewController()
        navigationController?.pushViewController(viewController, animated: true)
        searchResultView.isHidden = true
        viewController.delegate = self
        viewController.configureData(user: user, shopId: shopId ?? 0)
        searchTextField.text = ""
    }
}

// MARK: - UITextFieldDelegate

extension ShopRoleViewController {
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
}

// MARK: - UserPermissionViewControllerDelegate

extension ShopRoleViewController: UserPermissionViewControllerDelegate {
    func didUpdateRole() {
        getAPIListUserRole()
    }
}
