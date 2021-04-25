//
//  BaseAlertViewController.swift
//  StylePizza
//
//  Created by MACOS on 11/24/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit
import SnapKit

class BaseAlertViewController: BaseViewController {
    
    // MARK: Define controls
    internal let viewBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        view.alpha = 0
        return view
    }()
    
    // MARK: This function is a default initialization function
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        setupViewBackground()
        initialize()
    }
    
    // MARK: Setup layout
    private func setupViewBackground() {
        view.addSubview(viewBackground)
        viewBackground.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalToSuperview()
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissAlert))
        viewBackground.addGestureRecognizer(tapGesture)
    }
    
    func initialize() {}
    
    @objc func dismissAlert() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.1) {
            self.viewBackground.alpha = 1
        }
    }
}


