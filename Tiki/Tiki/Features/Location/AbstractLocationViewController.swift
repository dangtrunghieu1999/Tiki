//
//  AbstractLocationViewController.swift
//  Tiki
//
//  Created by Bee_MacPro on 19/06/2021.
//

import UIKit
import Alamofire
import SwiftyJSON
class AbstractLocationViewController: BaseViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero,
                                    style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.white
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.registerReusableCell(LocationsTableViewCell.self)
        return tableView
    }()
    
    private let whiteView: BaseView = {
        let view = BaseView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutWhiteView()
        layoutTableView()
        requestAPILocations()
    }
    
    func requestAPILocations() {}
    
    func reloadDataWhenFinishLoadAPI() {
        self.isRequestingAPI = false
        self.tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        self.view.addSubview(tableView)
    }

    private func layoutTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top
                .left
                .right
                .equalToSuperview()
            make.bottom
                .equalTo(whiteView.snp.top)
        }
    }
    
    private func layoutWhiteView() {
        view.addSubview(whiteView)
        whiteView.snp.makeConstraints { (make) in
            make.bottom
                .equalToSuperview()
            make.height
                .equalTo(100)
            make.left
                .right
                .equalToSuperview()
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


