//
//  NotificationsViewController.swift
//  ZoZoApp
//
//  Created by MACOS on 6/8/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class NotificationsViewController: BaseViewController {
    
    // MARK: - Helper Type
    
    enum NotificationType: Int {
        case order          = 0
        case addFriend      = 1
        case news           = 2
        
        static func numberSection() -> Int {
            return 3
        }
        var title: String {
            switch self {
            case .order:
                return TextManager.order.localized()
            case .addFriend:
                return TextManager.addFriend.localized()
            case .news:
                return TextManager.news.localized()
            }
        }
    }
    
    
    // MARK: - UI Elements
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.lightBackground
        tableView.showsVerticalScrollIndicator = false
        tableView.registerReusableCell(NotificationsTableViewCell.self)
        tableView.registerReusableHeaderFooter(NotificationsTableViewHeaderCell.self)
        tableView.registerReusableHeaderFooter(NotificationsTableViewFooterCell.self)
        return tableView
    }()
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = TextManager.notification.localized()
        
        layoutTableView()
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

extension NotificationsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    
}

// MARK: - UITableViewDataSource

extension NotificationsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return NotificationType.numberSection()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let noticationType = NotificationType(rawValue: section) else { return 0 }
        switch noticationType {
        case .order:
            return 5
        case .addFriend:
            return 6
        case .news:
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let _ = NotificationType(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        let cell: NotificationsTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let notificationType = NotificationType(rawValue: section) else {
            return UITableViewHeaderFooterView()
        }
        let header: NotificationsTableViewHeaderCell = tableView.dequeueReusableHeaderFooterView()
        header.titleName = notificationType.title
        return header
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let notificationType = NotificationType(rawValue: section) else { return nil }
        
        let footer: NotificationsTableViewFooterCell = tableView.dequeueReusableHeaderFooterView()
        footer.delegate = self
        footer.notificationType = notificationType
        return footer
    }
}

// MARK: - NotificationsTableViewDelegateCell

extension NotificationsViewController: NotificationsTableViewDelegateCell {
    func didSelectSeeMore(with notificationType: NotificationsViewController.NotificationType) {
        let vc = NotificationsDetailViewController()
        vc.setupData(with: notificationType)
        navigationController?.pushViewController(vc, animated: true)
    }
}
