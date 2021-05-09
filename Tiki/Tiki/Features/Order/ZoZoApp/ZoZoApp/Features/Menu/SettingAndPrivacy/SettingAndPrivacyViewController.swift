//
//  SettingAndPrivacyViewController.swift
//  ZoZoApp
//
//  Created by Dang Trung Hieu on 8/29/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class SettingAndPrivacyViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = TextManager.settingAndPrivacy.localized()
    }
}
