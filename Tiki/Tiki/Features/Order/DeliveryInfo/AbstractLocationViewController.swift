//
//  AbstractLocationViewController.swift
//  Tiki
//
//  Created by Bee_MacPro on 19/06/2021.
//

import UIKit

class AbstractLocationViewController: BaseViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.lightBackground
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.registerReusableCell(LocationsTableViewCell.self)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutTableView()
        requestAPILocations()
    }
    
    func requestAPILocations() {}
    
    func reloadDataWhenFinishLoadAPI() {
        self.isRequestingAPI = false
        self.tableView.reloadData()
    }

    private func layoutTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            if #available(iOS 11, *) {
                make.top
                    .equalTo(view.safeAreaLayoutGuide)
            } else {
                make.top
                    .equalTo(topLayoutGuide.snp.bottom)
            }
            make.left
                .right
                .equalToSuperview()
            make.bottom
                .equalToSuperview()
                .offset(-dimension.normalMargin)
        }
    }
}

extension AbstractLocationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    }
}

