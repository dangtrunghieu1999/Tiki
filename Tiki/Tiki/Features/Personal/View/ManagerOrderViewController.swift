//
//  ManagerOrderViewController.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 3/22/21.
//

import UIKit

class ManagerOrderViewController: BaseViewController {

    // MARK: - Variables
    
    // MARK: - UI Elements
    
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = TextManager.myOrdered
        
        navigationController?.tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: - Helper Method
    
    // MARK: - GET API
    
    // MARK: - Layout
    

}
