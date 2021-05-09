//
//  ChatHistoryViewController.swift
//  ZoZoApp
//
//  Created by LAP12852 on 8/31/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class ChatHistoryViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = TextManager.chatHistory.localized()
    }

}
