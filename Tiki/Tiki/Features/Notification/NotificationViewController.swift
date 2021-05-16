//
//  NotificationViewController.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 4/8/21.
//

import UIKit

class NotificationViewController: BaseViewController {

    // MARK: - Variables
    
    // MARK: - UI Elements
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.lightBackground
        tableView.showsVerticalScrollIndicator = false
        tableView.registerReusableCell(NotificationsTableViewCell.self)
        return tableView
    }()

    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = TextManager.notification
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

// MARK: - UITableViewDelegate

extension NotificationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

// MARK: - UITableViewDataSource

extension NotificationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NotificationsTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        return cell
    }
}

