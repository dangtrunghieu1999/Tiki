//
//  GuiderEarnMoneyWebViewViewController.swift
//  ZoZoApp
//
//  Created by Dang Trung Hieu on 8/29/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class GuiderEarnMoneyWebViewViewController: BaseViewController {
    
    // MARK: UI - Elements

    private let webView = UIWebView()
    
    // MARK: - View LifeCycles

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = TextManager.guideEarnMoney.localized()
        webView.backgroundColor = UIColor.white
        layoutWebView()
    }
    
    // MARK: - Public Method
    
    func configWebView(by url: URL) {
        webView.loadRequest(URLRequest(url: url))
    }
    
    // MARK: - Setup layots

    private func layoutWebView() {
        view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
    }

}
