
//
//  UINavigationController+Extension.swift
//  Ecom
//
//  Created by MACOS on 4/6/19.
//  Copyright © 2019 Ecom. All rights reserved.
//

import UIKit

extension UINavigationController {
    @discardableResult
    func popToViewController<T: BaseViewController>(_ viewcontroller: T.Type) -> Bool {
        for controller in viewControllers as Array {
            if controller.isKind(of: viewcontroller.self) {
                popToViewController(controller, animated: false)
                return true
            }
        }
        return false
    }
    
    func popToViewControllerType(_ type: UIViewController.Type, completion: (()-> Void)?) {
        let vc = self.viewControllers.filter {return $0.isKind(of: type)}.first
        if let vc = vc { self.popToViewControllerWithHandler(vc, completion: completion) }
    }
    
    func popToViewControllerWithHandler(_ viewController: UIViewController, completion: (()-> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.popToViewController(viewController, animated: true)
        CATransaction.commit()
    }
    
    override open var shouldAutorotate: Bool {
        get {
            if let visibleVC = visibleViewController {
                return visibleVC.shouldAutorotate
            }
            return super.shouldAutorotate
        }
    }
    
    override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        get {
            if let visibleVC = visibleViewController {
                return visibleVC.preferredInterfaceOrientationForPresentation
            }
            return super.preferredInterfaceOrientationForPresentation
        }
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            if let visibleVC = visibleViewController {
                return visibleVC.supportedInterfaceOrientations
            }
            return super.supportedInterfaceOrientations
        }
    }
    
    func popViewControllerWithHandler(completion: @escaping ()->()) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.popViewController(animated: true)
        CATransaction.commit()
    }
    
    func pushViewController(viewController: UIViewController, completion: @escaping ()->()) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.pushViewController(viewController, animated: true)
        CATransaction.commit()
    }
    
    
}
