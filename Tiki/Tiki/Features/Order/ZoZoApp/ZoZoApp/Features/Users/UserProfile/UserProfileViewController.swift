//
//  UserProfileViewController.swift
//  ZoZoApp
//
//  Created by LAP12852 on 7/31/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class UserProfileViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = TextManager.userProfile.localized()
        
        #if DEBUG
        addButton()
        #endif
        
    }
    
    private func addButton() {
        let button1 = UIButton(frame: CGRect(x: 80, y: 100, width: 200, height: 50))
        button1.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        button1.setTitle("Test 1", for: .normal)
        button1.setTitleColor(UIColor.bodyText, for: .normal)
        view.addSubview(button1)
        button1.addTarget(self, action: #selector(tapOnButton1), for: .touchUpInside)
        
        let button2 = UIButton(frame: CGRect(x: 80, y: 300, width: 200, height: 50))
        button2.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        button2.setTitle("Test 2", for: .normal)
        button2.setTitleColor(UIColor.bodyText, for: .normal)
        view.addSubview(button2)
        button2.addTarget(self, action: #selector(tapOnButton2), for: .touchUpInside)
        
    }
    
    @objc private func tapOnButton1() {
        let VC = TransportersViewController()
        navigationController?.pushViewController(VC, animated: true)
    }
    
    @objc private func tapOnButton2() {

    }

}
