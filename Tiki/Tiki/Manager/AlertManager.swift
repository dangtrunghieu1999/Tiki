//
//  AlertManager.swift
//  Ecom
//
//  Created by Minh Tri on 3/23/19.
//  Copyright © 2019 Minh Tri. All rights reserved.
//

import UIKit
import Localize_Swift
import Toast_Swift

class AlertManager {
    
    public static let shared = AlertManager()
    
    private func topController() -> UIViewController? {
        return UIViewController.topViewController()
    }
    
    // MARK: - Functions
    
    /// Show default error
    func showDefaultError() {
        show(TextManager.alertTitle.localized(),
                  message: TextManager.errorMessage.localized(),
                  acceptMessage: TextManager.IUnderstand.localized(),
                  acceptBlock: nil)
    }
    
    func show(_ title: String = TextManager.alertTitle.localized(),
              message: String) {
        show(title, message: message,
                  acceptMessage: TextManager.IUnderstand.localized(),
                  acceptBlock: nil)
    }
    
    func show(_ title: String, message: String, acceptMessage: String, acceptBlock: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let acceptButton = UIAlertAction(title: acceptMessage, style: .default, handler: { (_: UIAlertAction) in
            acceptBlock?()
        })
        alert.addAction(acceptButton)
        topController()?.present(alert, animated: true, completion: nil)
    }
    
    func show(_ title: String? = nil,
              style: UIAlertController.Style = .alert,
              message: String? = nil,
              buttons: [String],
              tapBlock: ((UIAlertAction, Int) -> Void)?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: style, buttons: buttons, tapBlock: tapBlock)
        
        if style == .actionSheet {
            alert.addAction(UIAlertAction(title: TextManager.cancel.localized(), style: .cancel, handler: nil))
        }
        
        topController()?.present(alert, animated: true, completion: nil)
    }
    
    
    func showToast(message: String = TextManager.errorMessage.localized()) {
        guard let topView = UIViewController.topViewController()?.view else { return }
        topView.makeToast(message)
    }
    
    func showConfirmMessage(mesage: String?, confirmBlock: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController(title: TextManager.alertTitle.localized(),
                                      message: mesage,
                                      preferredStyle: .alert)
        let cancel = UIAlertAction(title: TextManager.cancel.localized(), style: .cancel, handler: nil)
        let confirm = UIAlertAction(title: TextManager.agree.localized(),
                                    style: .destructive,
                                    handler: confirmBlock)
        alert.addAction(cancel)
        alert.addAction(confirm)
        self.topController()?.present(alert, animated: true, completion: nil)
    }
}

private extension UIAlertController {
    convenience init(title: String?, message: String?, preferredStyle: UIAlertController.Style, buttons: [String], tapBlock: ((UIAlertAction, Int) -> Void)?) {
        self.init(title: title, message: message, preferredStyle: preferredStyle)
        var buttonIndex = 0
        for buttonTitle in buttons {
            let action = UIAlertAction(title: buttonTitle, preferredStyle: .default, buttonIndex: buttonIndex, tapBlock: tapBlock)
            buttonIndex += 1
            addAction(action)
        }
    }
}

private extension UIAlertAction {
    convenience init(title: String?, preferredStyle: UIAlertAction.Style, buttonIndex: Int, tapBlock: ((UIAlertAction, Int) -> Void)?) {
        self.init(title: title, style: preferredStyle) { (action: UIAlertAction) in
            if let block = tapBlock {
                block(action, buttonIndex)
            }
        }
    }
}
