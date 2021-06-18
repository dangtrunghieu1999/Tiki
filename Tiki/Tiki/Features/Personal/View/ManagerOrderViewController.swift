//
//  ManagerOrderViewController.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 3/22/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class ManagerOrderViewController: BaseViewController {
    
    // MARK: - Variables
    
    private lazy var viewControllerFrame = CGRect(x: 0,
                                                  y: 0,
                                                  width: view.bounds.width,
                                                  height: view.bounds.height)
    
    var parameters: [CAPSPageMenuOption] = [
        .centerMenuItems(true),
        .scrollMenuBackgroundColor(UIColor.white),
        .selectionIndicatorColor(UIColor.primary),
        .selectedMenuItemLabelColor(UIColor.bodyText),
        .menuItemFont(UIFont.systemFont(ofSize: FontSize.h2.rawValue, weight: .medium)),
        .menuHeight(42),
        
    ]
    
    var order: [Order] = []
    var pageMenu : CAPSPageMenu?
    var numberIndex = 0
    fileprivate var subPageControllers: [AbstractOrderViewController] = []
    
    
    // MARK: - UI Elements
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addBackButtonIfNeeded()
    }
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = TextManager.myOrdered
        addGuestChildsVC()
        pageMenu?.moveToPage(numberIndex)
    }
    
    // MARK: - Helper Method
    
    fileprivate func addGuestChildsVC() {
        createSubViewOrderManager()
        
        pageMenu = CAPSPageMenu(viewControllers: subPageControllers,
                                frame: CGRect(x: 0.0, y: self.topbarHeight,
                                width: self.view.frame.width,
                                height: self.view.frame.height),
                                pageMenuOptions: parameters)
        self.view.addSubview(pageMenu!.view)
        requestAPIOrder()
    }
    
    func requestAPIOrder() {
        guard let path = Bundle.main.path(forResource: "Order", ofType: "json") else {
            fatalError("Not available json")
        }
        let url = URL(fileURLWithPath: path)
        Alamofire.request(url).responseJSON { (response) in
            switch response.result {
            case.success(let value):
                let json = JSON(value)
                self.order = json.arrayValue.map{ Order(json: $0)}
                self.reloadAllChildOrderVC(with: self.order)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func createSubViewOrderManager() {
        for status in Order.arraySubVC {
            let vc = AbstractOrderViewController(status: status)
            vc.view.frame = viewControllerFrame
            vc.title = status.title
            subPageControllers.append(vc)
        }
    }
    
    private func reloadAllChildOrderVC(with orders: [Order]) {
        for vc in subPageControllers {
            let currentOrders = filterOrders(orders, by: vc.status)
            vc.reloadData(currentOrders)
        }
    }
    
    func filterOrders(_ order: [Order], by status: OrderStatus) -> [Order] {
        switch status {
        case .recive, .transport, .success, .canccel:
            return order.filter { $0.status == status }
        case .all:
            return order
        }
    }
    
}
