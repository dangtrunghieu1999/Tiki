//
//  ViewController.swift
//  Tiki
//
//  Created by Bee_MacPro on 27/05/2021.
//

import UIKit
import FBSDKLoginKit

class ViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let loginButton = FBLoginButton()
        loginButton.center = view.center
        view.addSubview(loginButton)
        NotificationCenter.default.addObserver(forName: .AccessTokenDidChange, object: nil, queue: OperationQueue.main) { (notification) in
            print("\(String(describing: AccessToken.current?.tokenString))")
            
        }
    }
    

  

}
