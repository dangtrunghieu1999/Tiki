//
//  OrderInfomationCollectionViewCell.swift
//  ZoZoApp
//
//  Created by Dang Trung Hieu on 8/26/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class OrderCollectionViewCell: BaseCollectionViewCell {
    
    var products: [Product] = []
    
    // MARK: - UI Elements
    
    private let borderView: BaseView = {
        let view = BaseView()
        view.layer.borderColor  = UIColor.separator.cgColor
        view.layer.borderWidth  = 2
        view.layer.cornerRadius = dimension.conerRadiusMedium
        view.layer.masksToBounds = true
        return view
    }()
    
    private let firstHeaderView: BaseView = {
        let view = BaseView()
        view.backgroundColor    = .lightGreenColor
        view.layer.borderColor  = UIColor.greenColor.cgColor
        view.layer.borderWidth  = 1
        view.layer.cornerRadius = dimension.conerRadiusMedium
        return view
    }()
    
    private let packImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.icon_pack
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
   private let packTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .greenColor
        label.text = TextManager.pack
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        return label
    }()
    
    private let secondHeaderView: BaseView = {
        let view = BaseView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    fileprivate lazy var intendTimeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .greenColor
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        label.text = "Giao vào Thứ Ba, 08/06"
        return label
    }()
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = false
        tableView.isUserInteractionEnabled = false
        tableView.dataSource = self
        tableView.delegate   = self
        tableView.registerReusableCell(OrderProductTableViewCell.self)
        return tableView
    }()
    
    // MARK: - View LifeCycles
    
    override func initialize() {
        super.initialize()
        layoutBorderView()
        layoutFirstHeaderView()
        layoutPackImageView()
        layoutPackTitleLabel()
        layoutSecondHeaderView()
        layoutIntendTimeLabel()
        layoutTableView()
    }
    
    private func layoutBorderView() {
        addSubview(borderView)
        borderView.snp.makeConstraints { (make) in
            make.left.right
                .equalToSuperview()
                .inset(dimension.normalMargin)
            make.top
                .equalToSuperview()
                .offset(dimension.largeMargin_38)
            make.bottom
                .equalToSuperview()
                .inset(dimension.largeMargin)
        }
    }
    
    private func layoutFirstHeaderView() {
        addSubview(firstHeaderView)
        firstHeaderView.snp.makeConstraints { (make) in
            make.top
                .equalToSuperview()
                .offset(dimension.normalMargin)
            make.height
                .equalTo(50)
            make.width
                .equalTo(80)
            make.left
                .equalToSuperview()
                .offset(dimension.largeMargin)
        }
    }
    
    private func layoutPackImageView() {
        firstHeaderView.addSubview(packImageView)
        packImageView.snp.makeConstraints { (make) in
            make.left
                .equalToSuperview()
                .offset(dimension.mediumMargin_12)
            make.centerY
                .equalToSuperview()
            make.width.height
                .equalTo(24)
        }
    }
    
    private func layoutPackTitleLabel() {
        firstHeaderView.addSubview(packTitleLabel)
        packTitleLabel.snp.makeConstraints { (make) in
            make.left
                .equalTo(packImageView.snp_right)
                .offset(dimension.mediumMargin)
            make.right
                .equalToSuperview()
                .inset(dimension.mediumMargin)
            make.centerY
                .equalTo(packImageView)
        }
    }
    
    private func layoutSecondHeaderView() {
        addSubview(secondHeaderView)
        secondHeaderView.snp.makeConstraints { (make) in
            make.top
                .equalToSuperview()
                .offset(dimension.normalMargin)
            make.height
                .equalTo(50)
            make.width
                .equalTo(190)
            make.left
                .equalTo(firstHeaderView.snp.right)
        }
    }
    
    private func layoutIntendTimeLabel() {
        secondHeaderView.addSubview(intendTimeLabel)
        intendTimeLabel.snp.makeConstraints { (make) in
            make.centerY
                .equalToSuperview()
            make.left
                .equalToSuperview()
                .offset(dimension.mediumMargin)
        }
    }
    
    private func layoutTableView() {
        borderView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top
                .equalTo(firstHeaderView.snp.bottom)
                .offset(dimension.normalMargin)
            make.left.right
                .equalToSuperview()
                .inset(dimension.normalMargin)
            make.bottom
                .equalToSuperview()
                .inset(dimension.largeMargin)
        }
    }
}

// MARK: - UITableViewDataSource

extension OrderCollectionViewCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: OrderProductTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        
        if let product = products[safe: indexPath.row] {
            cell.configData(product: product)
        }

        return cell
    }
}

extension OrderCollectionViewCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
