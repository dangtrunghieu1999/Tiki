//
//  ProductParameterViewController.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 4/19/21.
//

import UIKit


class ProductParameterViewController: BaseViewController {
    
    // MARK: - Variables
    
    fileprivate lazy var productParamter: ProductParameterModel = {
        let paramter = ProductParameterModel()
        return paramter
    }()
    
    fileprivate lazy var valueTitles: [String] = []
    
    // MARK: - UI Elements
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.white
        tableView.isScrollEnabled = false
        tableView.showsVerticalScrollIndicator = false
        tableView.registerReusableCell(TitleTableViewCell.self)
        return tableView
    }()
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLeftNavigationBar(ImageManager.dismiss_close)
        navigationItem.title = TextManager.detailProduct
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        layoutTableView()
    }
    
    // MARK: - Helper Method
    
    override func touchUpInLeftBarButtonItem() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helper Method
    
    func configValueTitle(values: [String]) {
        self.valueTitles = values
    }
    
    // MARK: - GET API
    
    // MARK: - Layout
    
    private func layoutTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
}

// MARK: - UITableViewDelegate

extension ProductParameterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

// MARK: - UITableViewDataSource

extension ProductParameterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return valueTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: TitleTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        
        if indexPath.row % 2 == 0{
            cell.keyCoverView.backgroundColor = UIColor.lightBackground
            cell.valueCoverView.backgroundColor = UIColor.lightBackground
        } else {
            cell.keyCoverView.backgroundColor = UIColor.white
            cell.valueCoverView.backgroundColor = UIColor.white
        }
        
        cell.configTitle(keyTitle: productParamter.keyTitle[indexPath.row],
                         valueTitle: valueTitles[indexPath.row])
        return cell
    }
}
