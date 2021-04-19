//
//  ProductDetailsCollectionViewCell.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 4/15/21.
//

import UIKit

protocol ProductDetailsDelegate: class {
    func didTapSeemoreParamter()
}

class ProductDetailsCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Variables
    
    weak var delegate: ProductDetailsDelegate?
    
    fileprivate lazy var productParamter: ProductParameterModel = {
        let paramter = ProductParameterModel()
        return paramter
    }()
    
    fileprivate lazy var valueTitles: [String] = []
    
    
    // MARK: - UI Elements
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.detailProduct
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .semibold)
        label.textAlignment = .left
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
    
    fileprivate lazy var seemoreButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.seemore, for: .normal)
        button.backgroundColor = UIColor.clear
        button.setTitleColor(UIColor.thirdColor, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        button.addTarget(self, action: #selector(tapSeeMore), for: .touchUpInside)
        return button
    }()
    
    // MARK: - View LifeCycles
    
    override func initialize() {
        super.initialize()
        layoutTitleLabel()
        layoutTableView()
        layoutSeemoreButton()
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    // MARK: - UI Action
    
    @objc private func tapSeeMore() {
        delegate?.didTapSeemoreParamter()
    }
    
    
    // MARK: - Helper Method
    
    func configValueTitle(values: [String]) {
        self.valueTitles = values
    }
    
    // MARK: - GET API
    
    // MARK: - Layout
    
    private func layoutTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Dimension.shared.normalMargin)
            make.top.equalToSuperview().offset(Dimension.shared.normalMargin )
        }
    }
    
    private func layoutTableView() {
        addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(Dimension.shared.normalMargin)
            make.left.equalToSuperview().offset(Dimension.shared.normalMargin)
            make.right.equalToSuperview().offset(-Dimension.shared.normalMargin)
            make.height.equalTo(200)
        }
    }
    
    private func layoutSeemoreButton() {
        addSubview(seemoreButton)
        seemoreButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(Dimension.shared.mediumMargin)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(100)
        }
    }
}

// MARK: - UITableViewDelegate

extension ProductDetailsCollectionViewCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

// MARK: - UITableViewDataSource

extension ProductDetailsCollectionViewCell: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell: TitleTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        if indexPath.row % 2 == 0{
            cell.keyCoverView.backgroundColor = UIColor.lightBackground
            cell.valueCoverView.backgroundColor = UIColor.lightBackground
        } else {
            cell.keyCoverView.backgroundColor = UIColor.white
            cell.valueCoverView.backgroundColor = UIColor.white
        }
        switch indexPath.row {
        case 0, 1, 2, 3:
            cell.configTitle(keyTitle: productParamter.keyTitle[indexPath.row],
                             valueTitle: valueTitles[indexPath.row])
        default:
            break
        }
    
        return cell
    }
}