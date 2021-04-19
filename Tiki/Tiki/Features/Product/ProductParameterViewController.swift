//
//  ProductParameterViewController.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 4/19/21.
//

import UIKit


class ProductParameterViewController: BaseViewController {

    // MARK: - Variables
    
    // MARK: - UI Elements
    
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLeftNavigationBar(ImageManager.dismiss_close)
    }
    
    // MARK: - Helper Method
    
    override func touchUpInLeftBarButtonItem() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - GET API
    
    // MARK: - Layout
    

}
