//
//  ChatViewController.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 3/13/21.
//

import UIKit

class ChatViewController: BaseViewController {

    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.backgroundColor = UIColor.lightBackground
        tableView.showsVerticalScrollIndicator = false
        tableView.registerReusableCell(ChatShopTableViewCell.self)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = TextManager.chat
        navigationItem.rightBarButtonItem = cartBarButtonItem
        setupTableView()
    }
    
}

// MARK: - Setup Compoents
extension ChatViewController {
    private func setupTableView() {
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}


extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ChatShopTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.delegate = self
        return cell
    }
}


extension ChatViewController: ChatShopTableViewCellDelegate {
    func didSelectChatRoomShop() {
        let vc = ChatDetailViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
