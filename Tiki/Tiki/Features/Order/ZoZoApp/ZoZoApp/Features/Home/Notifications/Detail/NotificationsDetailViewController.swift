//
//  NotificationsDetailViewController.swift
//  ZoZoApp
//
//  Created by Dang Trung Hieu on 9/1/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class NotificationsDetailViewController: BaseViewController {

    // MARK: - Variables
    
    private var notificationType: NotificationsViewController.NotificationType = .order
    
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
        layoutTableView()
    }
    
    // Public - Method

    func setupData(with notificationType: NotificationsViewController.NotificationType) {
        self.notificationType = notificationType
        switch notificationType {
        case .order:
            navigationItem.title = TextManager.notificationOrder.localized()
        case .addFriend:
            navigationItem.title = TextManager.notificationAddFriend.localized()
        case .news:
            navigationItem.title = TextManager.notificationNews.localized()
        }
    }
    
    // MARK: - Setup layouts
    
    private func layoutTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - UITableViewDelegate

extension NotificationsDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

// MARK: - UITableViewDataSource

extension NotificationsDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NotificationsTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        return cell
    }
}

