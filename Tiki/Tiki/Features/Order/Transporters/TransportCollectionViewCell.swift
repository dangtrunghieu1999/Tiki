//
//  TransportCollectionViewCell.swift
//  Tiki
//
//  Created by Bee_MacPro on 04/06/2021.
//

import UIKit

class TransportCollectionViewCell: BaseCollectionViewCell {
    
    fileprivate var selectedTransporter: TransportersType?
    
    private let selectTransportLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.selectTransporter.localized()
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue,
                                       weight: .bold)
        label.textColor = UIColor.bodyText
        label.textAlignment = .left
        return label
    }()
    
    fileprivate lazy var transporterTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.layer.cornerRadius  = dimension.conerRadiusMedium
        tableView.layer.masksToBounds = true
        tableView.layer.borderColor   = UIColor.primary.cgColor
        tableView.layer.borderWidth   = 1
        tableView.registerReusableCell(TransporterTableViewCell.self)
        return tableView
    }()
    
    private let headingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = ImageManager.triangle
        return imageView
    }()
    
    override func initialize() {
        super.initialize()
        layoutSelectTransportLabel()
        layoutTransportTableView()
        layoutHeadingImageView()
    }
    
    private func layoutSelectTransportLabel() {
        addSubview(selectTransportLabel)
        selectTransportLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
                .offset(dimension.normalMargin)
            make.left.equalToSuperview()
                .offset(dimension.normalMargin)
        }
    }
    
    private func layoutTransportTableView() {
        addSubview(transporterTableView)
        transporterTableView.snp.makeConstraints { (make) in
            make.top.equalTo(selectTransportLabel.snp.bottom)
                .offset(dimension.normalMargin)
            make.left.right.equalToSuperview()
                .inset(dimension.normalMargin)
            make.height.equalTo(150)
        }
    }
    
    private func layoutHeadingImageView() {
        addSubview(headingImageView)
        headingImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(30)
            make.top.equalTo(transporterTableView.snp.bottom)
                .offset(-10)
            make.centerX.equalToSuperview()
        }
    }
}

extension TransportCollectionViewCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TransporterTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.backgroundColor = UIColor.lightBackground
        if let transportersType = TransportersType(rawValue: indexPath.row) {
            cell.configData(transportersType)
        }
        cell.isSelected = (selectedTransporter == TransportersType(rawValue: indexPath.row))
        cell.backgroundColor = UIColor.white
        return cell
    }
}

extension TransportCollectionViewCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTransporter = TransportersType(rawValue: indexPath.row)
        transporterTableView.reloadData()
    }
}
