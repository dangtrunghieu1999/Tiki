//
//  DeliveryAddressViewController.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 3/22/21.
//

import UIKit
import Alamofire
import SwiftyJSON
 
class DeliveryAddressViewController: BaseViewController {
    
    // MARK: - Variables
    fileprivate var selectedAddress: Bool = false
    fileprivate var arrayAdress: [Address] = []
    var selectIndex : Int? = 0
    
    // MARK: - UI Elements
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .semibold)
        label.textAlignment = .left
        label.text = TextManager.selectShipAddress
        return label
    }()
    
    fileprivate lazy var bottomView: BaseView = {
        let view = BaseView()
        view.addTopBorder(with: UIColor.separator, andWidth: 1)
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var shipAddressButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.shipAddress, for: .normal)
        button.backgroundColor = UIColor.primary
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Dimension.shared.cornerRadiusSmall
        return button
    }()
    
    fileprivate lazy var shipAdressTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.tableBackground
        tableView.isScrollEnabled = false
        tableView.showsVerticalScrollIndicator = false
        tableView.registerReusableCell(SelectShipAddressTableViewCell.self)
        tableView.registerReusableHeaderFooter(ShipAddressTableViewFooter.self)
        return tableView
    }()
    
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = TextManager.addressRecive
        layoutTitleLabel()
        layoutShipAddress()
        layoutBottomView()
        layoutShipAddress()
        layoutShipAddressTableView()
    }
    
    // MARK: - Helper Method
    
    // MARK: - GET API
    
    func requestShipAddressAPI() {
        guard let path = Bundle.main.path(forResource: "ShipAddress", ofType: "json") else {
            fatalError("Not available json")
        }
        let url = URL(fileURLWithPath: path)
        Alamofire.request(url).responseJSON { (response) in
            switch response.result {
            case.success(let value):
                let json = JSON(value)
                self.arrayAdress = json.arrayValue.map{Address(json: $0)}
                self.shipAdressTableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - Layout
    
    private func layoutTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Dimension.shared.normalMargin)
            if #available(iOS 11, *) {
                make.top.equalTo(view.safeAreaLayoutGuide)
                    .offset(Dimension.shared.normalMargin)
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom)
                    .offset(Dimension.shared.normalMargin)
            }
            make.right.equalToSuperview()
        }
    }
    
    private func layoutShipAddressTableView() {
        view.addSubview(shipAdressTableView)
        shipAdressTableView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
                .offset(Dimension.shared.largeMargin)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(bottomView.snp.top)
        }
    }
    
    private func layoutBottomView() {
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            if #available(iOS 11, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalTo(bottomLayoutGuide.snp.top)
            }
            make.left.right.equalToSuperview()
            make.height.equalTo(68)
        }
    }
    
    private func layoutShipAddress() {
        bottomView.addSubview(shipAddressButton)
        shipAddressButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Dimension.shared.normalMargin)
            make.right.equalToSuperview().offset(-Dimension.shared.normalMargin)
            make.height.equalTo(Dimension.shared.defaultHeightButton)
            make.bottom.equalToSuperview().offset(-Dimension.shared.mediumMargin)
        }
    }
}

// MARK: - UITableViewDelegate

extension DeliveryAddressViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectIndex = indexPath.row
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension DeliveryAddressViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayAdress.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SelectShipAddressTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        let index = indexPath.row
        cell.configData(arrayAdress[indexPath.row], index: index)
        cell.isSelected = (indexPath.row == selectIndex)
        return cell
    }
}

