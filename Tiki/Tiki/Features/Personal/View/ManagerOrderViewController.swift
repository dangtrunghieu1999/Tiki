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
        .scrollMenuBackgroundColor(UIColor.scrollMenu),
        .selectionIndicatorColor(UIColor.clear),
        .selectedMenuItemLabelColor(UIColor.bodyText),
        .menuItemFont(UIFont.systemFont(ofSize: FontSize.h2.rawValue, weight: .medium)),
        .menuHeight(42),
    ]
    var pageMenu : CAPSPageMenu?
    
    fileprivate var subPageControllers: [UIViewController] = []
    
    
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
    }
    
    // MARK: - Helper Method
    
    fileprivate func addGuestChildsVC() {
        addOrderAll()
        addOrderPayment()
        addOrderProcess()
        addOrderTransport()
        addOrderSuccess()
        addOrderCancel()
        
        pageMenu = CAPSPageMenu(viewControllers: subPageControllers, frame: CGRect(x: 0.0, y: self.topbarHeight, width: self.view.frame.width, height: self.view.frame.height), pageMenuOptions: parameters)
        
        self.view.addSubview(pageMenu!.view)

    }
    
    private func addOrderAll() {
        let vc = OrderAllViewController()
        vc.title = TextManager.allOrder
        vc.view.frame = viewControllerFrame
        subPageControllers.append(vc)
    }
    
    private func addOrderPayment() {
        let vc = OrderPaymentViewController()
        vc.title = TextManager.waitOrder
        vc.view.frame = viewControllerFrame
        subPageControllers.append(vc)
    }
    
    private func addOrderProcess() {
        let vc = OrderProcessViewController()
        vc.title = TextManager.processing
        vc.view.frame = viewControllerFrame
        subPageControllers.append(vc)
    }
    
    private func addOrderTransport() {
        let vc = OrderTransportViewController()
        vc.title = TextManager.transported
        vc.view.frame = viewControllerFrame
        subPageControllers.append(vc)
    }
    
    private func addOrderSuccess() {
        let vc = OrderSuccessViewController()
        vc.title = TextManager.recivedSuccess
        vc.view.frame = viewControllerFrame
        subPageControllers.append(vc)
    }
    
    private func addOrderCancel() {
        let vc = OrderCancelViewController()
        vc.title = TextManager.cancelOrder
        vc.view.frame = viewControllerFrame
        subPageControllers.append(vc)
    }
    
    
    // MARK: - GET API
    
    // MARK: - Layout
    
    
    
}

