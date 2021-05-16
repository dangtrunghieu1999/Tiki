//
//  ProductedBuyViewController.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 3/22/21.
//

import UIKit

class ProductedBuyViewController: BaseViewController {

    // MARK: - Variables
    
    var isBought = false
    var product  = Product()
    
    // MARK: - UI Elements
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.white
        tableView.showsVerticalScrollIndicator = false
        tableView.estimatedRowHeight = 150
        tableView.registerReusableCell(ProductItemTableViewCell.self)
        return tableView
    }()
    
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isBought {
            navigationItem.title = TextManager.bought
        } else {
            navigationItem.title = TextManager.loved
        }
        
        navigationItem.rightBarButtonItem = cartBarButtonItem
        layoutTableView()
    }
    
    // MARK: - Helper Method
    
    // MARK: - GET API
    
    // MARK: - Layout
    
    private func layoutTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            if #available(iOS 11, *) {
                make.top.equalTo(view.safeAreaLayoutGuide)
                    
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom)
                   
            }
            make.left.right.bottom.equalToSuperview()
        }
    }
}

extension ProductedBuyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
}

extension ProductedBuyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ProductItemTableViewCell = tableView.dequeueReusableCell(for: indexPath)

        return cell
    }
}
