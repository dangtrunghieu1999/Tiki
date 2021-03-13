//
//  SearchResultView.swift
//  ZoZoApp
//
//  Created by LAP12852 on 8/4/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

protocol SearchResultViewDelegate: class {
    func didSelectSearchResult(user: User)
}

class SearchResultView: BaseView {

    // MARK: - Variables
    
    var isShowCheckBox: Bool = false {
        didSet {
            searchResultsTableView.reloadData()
        }
    }
    
    var selectedUsers: [User] = [] {
        didSet {
            searchResultsTableView.reloadData()
        }
    }
    
    weak var delegate: SearchResultViewDelegate?
    fileprivate var resultDatas: [User] = []
    
    // MARK: - UI Elements
    
    fileprivate lazy var searchResultsTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.white
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.registerReusableCell(SearchResultUserTableViewCell.self)
        tableView.registerReusableHeaderFooter(BaseTableViewHeaderFooter.self)
        return tableView
    }()
    
    // MARK: - LifeCycles
    
    override func initialize() {
        layoutSearchResultsTabelView()
    }
    
    // MARK: - Public Methods
    
    func configureData(_ searchResults: [User]) {
        self.resultDatas = searchResults
        searchResultsTableView.reloadData()
    }
    
    func searchUser(text: String) {
        guard text.isValidEmail || text.isPhoneNumber else {
            return
        }
        
        let endPoint = UserEndPoint.searchUser(params: ["EmailOrPhoneNumber": text])
        
        APIService.request(endPoint: endPoint, onSuccess: { [weak self] (apiResponse) in
            guard let self = self else { return }
            self.resultDatas = apiResponse.toArray([User.self])
            self.configureData(self.resultDatas)
            }, onFailure: { (apiError) in
                
        }) {
            
        }
    }
    
    // MARK: - UI Actions
    
    // MARK: - Helper Methods
    
    // MARK: - Layout
    
    private func layoutSearchResultsTabelView() {
        addSubview(searchResultsTableView)
        searchResultsTableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

}

// MARK: - UITableViewDelegate

extension SearchResultView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectSearchResult(user: resultDatas[indexPath.row])
    }
}

// MARK: - UITableViewDelegate

extension SearchResultView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SearchResultUserTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.isShowCheckBox = true
        
        if let user = resultDatas[safe: indexPath.row] {
            cell.configureData(user: user)
            
            if isShowCheckBox {
                cell.isCheck = selectedUsers.contains(user)
            }
        }
        
        return cell
    }
}
