//
//  FilterCouponPulleyView.swift
//  Tiki
//
//  Created by Bee_MacPro on 18/05/2021.
//

import UIKit

protocol SeeMoreProductPulleyViewDelegate: class {
    func tapOnCloseView()
}

class SeeMoreProductPulleyView: ShowHidePulleyView {

    // MARK: - Variables
    
    weak var delegate: SeeMoreProductPulleyViewDelegate?
    
    // MARK: - UI Elements
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.infoGuarantee
        label.textAlignment = .center
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.title.rawValue, weight: .semibold)
        return label
    }()
    
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
    
    fileprivate let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.separator
        return view
    }()
    
    fileprivate lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.close, for: .normal)
        button.backgroundColor = UIColor.primary
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(tapOnCloseView), for: .touchUpInside)
        return button
    }()

    override func initialize() {
        super.initialize()
    }
    
    // MARK: - UI Action
    
    @objc private func tapOnCloseView() {
        delegate?.tapOnCloseView()
    }
}

// MARK: - Layout

extension SeeMoreProductPulleyView {
    
}


// MARK: - UITableViewDelegate

extension SeeMoreProductPulleyView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

// MARK: - UITableViewDelegate

extension SeeMoreProductPulleyView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TitleTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        return cell
    }
}

